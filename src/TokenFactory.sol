// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Token} from "./Token.sol";
import "@uniswap-v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap-v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap-v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {BondingCurve} from "./BondingCurve.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

event TokenCreated(address indexed tokenAddress, string name, string symbol);

contract TokenFactory is BondingCurve, ReentrancyGuard {
    enum TokenState {
        NOT_CREATED,
        FUNDING,
        TRADING
    }

    uint256 public constant MAX_SUPPLY = 10 ** 9 * 10 ** 18;
    uint256 public constant INITIAL_SUPPLY = (MAX_SUPPLY * 1) / 5;
    uint256 public constant FUNDING_SUPPLY = (MAX_SUPPLY * 4) / 5;

    mapping(address => uint256) public aConstants;
    mapping(address => uint256) public bConstants;
    mapping(address => uint256) public fundingGoals;
    mapping(address => TokenState) public tokens;
    mapping(address => uint256) public collateral;
    address public immutable tokenImplementation;
    IERC20 public baseToken;

    // POLYGON MAINNET
    address public constant UNISWAP_V2_FACTORY = 0x9e5A52f57b3038F1B8EeE45F28b3C1967e22799C;
    address public constant UNISWAP_V2_ROUTER = 0xedf6066a2b290C185783862C7F4776A2C8077AD1;

    // POLYGON AMOY
    // address public constant UNISWAP_V2_FACTORY = 0xeD04530614eA831d407bD916aF0625FC0B17f062;
    // address public constant UNISWAP_V2_ROUTER = 0x6a4e354aFa1075fE98771a72fa85F4F003006242;

    // ETHEREUM MAINNET
    // address public constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    // address public constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // ETHEREUM SEPOLIA
    // address public constant UNISWAP_V2_FACTORY = 0x0227628f3F023bb0B980b67D528571c95c6DaC1c;
    // address public constant UNISWAP_V2_ROUTER = 0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E;

    constructor(address _tokenImplementation, address _baseToken) {
        tokenImplementation = _tokenImplementation;
        baseToken = IERC20(_baseToken);
        // fundingGoal = 10 ** 6 * 10 ** 18;
    }
    
    function createToken(string memory name, string memory symbol, uint256 fundingGoal, uint256 a, uint256 b, uint256 initialPurchase) public returns (address) {
        address tokenAddress = Clones.clone(tokenImplementation);
        Token token = Token(tokenAddress);
        token.initialize(name, symbol);
        tokens[tokenAddress] = TokenState.FUNDING;
        fundingGoals[tokenAddress] = fundingGoal;
        aConstants[tokenAddress] = a;
        bConstants[tokenAddress] = b;
        if (initialPurchase > 0){
            buy(tokenAddress, initialPurchase);
        }
        emit TokenCreated(tokenAddress, name, symbol);
        return tokenAddress;
    }

    function buy(address tokenAddress, uint256 baseTokenAmount) public nonReentrant {
        require(tokens[tokenAddress] == TokenState.FUNDING, "Token not found");
        require(baseTokenAmount > 0, "Base token amount not enough");
        Token token = Token(tokenAddress);
        uint256 valueToBuy = baseTokenAmount;
        uint256 fundingGoal = fundingGoals[tokenAddress];
        uint256 a = aConstants[tokenAddress];
        uint256 b = bConstants[tokenAddress];
        
        if (collateral[tokenAddress] + valueToBuy > fundingGoal) {
            valueToBuy = fundingGoal - collateral[tokenAddress];
        }

        uint256 amount = getAmountOut(a, b, token.totalSupply(), valueToBuy);
        uint256 availableSupply = FUNDING_SUPPLY - token.totalSupply();
        require(amount <= availableSupply, "Token not enough");

        require(baseToken.transferFrom(msg.sender, address(this), valueToBuy), "Base token transfer failed");

        collateral[tokenAddress] += valueToBuy;
        token.mint(msg.sender, amount);

        if (collateral[tokenAddress] >= fundingGoal) {
            token.mint(address(this), INITIAL_SUPPLY);
            address pair = createLiquilityPool(tokenAddress);
            uint256 liquidity = addLiquidity(tokenAddress, INITIAL_SUPPLY, collateral[tokenAddress]);
            burnLiquidityToken(pair, liquidity);
            collateral[tokenAddress] = 0;
            tokens[tokenAddress] = TokenState.TRADING;
        }

        if (valueToBuy < baseTokenAmount) {
            require(baseToken.transfer(msg.sender, baseTokenAmount - valueToBuy), "Base token refund failed");
        }
    }

    function sell(address tokenAddress, uint256 amount) external {
        require(tokens[tokenAddress] == TokenState.FUNDING, "Token not found");
        require(amount > 0, "Token not enough");
        Token token = Token(tokenAddress);
        token.burn(msg.sender, amount);
        uint256 a = aConstants[tokenAddress];
        uint256 b = bConstants[tokenAddress];
        uint256 receivedBaseToken = getFundsNeeded(a, b, token.totalSupply(), amount);
        collateral[tokenAddress] -= receivedBaseToken;
        require(baseToken.transfer(msg.sender, receivedBaseToken), "Base token transfer failed");
    }

    function calculateBuyReturn(address tokenAddress, uint256 baseTokenAmount) public view returns (uint256) {
        Token token = Token(tokenAddress);
        uint256 a = aConstants[tokenAddress];
        uint256 b = bConstants[tokenAddress];
        uint256 amount = getAmountOut(a, b, token.totalSupply(), baseTokenAmount);
        return amount;
    }

    function calculateSellReturn(address tokenAddress, uint256 tokenAmount) public view returns (uint256) {
        Token token = Token(tokenAddress);
        uint256 a = aConstants[tokenAddress];
        uint256 b = bConstants[tokenAddress];
        uint256 receivedBaseToken = getFundsNeeded(a, b, token.totalSupply(), tokenAmount);
        return receivedBaseToken;
    }

    function createLiquilityPool(address tokenAddress) internal returns (address) {
        IUniswapV2Factory factory = IUniswapV2Factory(UNISWAP_V2_FACTORY);
        address pair = factory.createPair(tokenAddress, address(baseToken));
        return pair;
    }

    function addLiquidity(address tokenAddress, uint256 tokenAmount, uint256 baseTokenAmount) internal returns (uint256) {
        Token token = Token(tokenAddress);
        IUniswapV2Router01 router = IUniswapV2Router01(UNISWAP_V2_ROUTER);
        token.approve(UNISWAP_V2_ROUTER, tokenAmount);
        baseToken.approve(UNISWAP_V2_ROUTER, baseTokenAmount);
        
        (, , uint256 liquidity) = router.addLiquidity(
            tokenAddress,
            address(baseToken),
            tokenAmount,
            baseTokenAmount,
            tokenAmount,
            baseTokenAmount,
            address(this),
            block.timestamp
        );
        return liquidity;
    }

    function burnLiquidityToken(address pair, uint256 liquidity) internal {
        IUniswapV2Pair pool = IUniswapV2Pair(pair);
        pool.transfer(address(0), liquidity);
    }
}