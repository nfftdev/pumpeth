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

contract TokenFactory is BondingCurve, ReentrancyGuard {
    enum TokenState {
        NOT_CREATED,
        FUNDING,
        TRADING
    }

    uint256 public constant MAX_SUPPLY = 10 ** 9 * 10 ** 18;
    uint256 public constant INITIAL_SUPPLY = (MAX_SUPPLY * 1) / 5;
    uint256 public constant FUNDING_SUPPLY = (MAX_SUPPLY * 4) / 5;
    uint256 public constant FUNDING_GOAL = 10000 * 10 ** 18; // Adjusted for base token decimals

    uint256 public a = 10000000000000;
    uint256 public b = 100000000;

    mapping(address => TokenState) public tokens;
    mapping(address => uint256) public collateral;
    address public immutable tokenImplementation;
    IERC20 public baseToken;

    address public constant UNISWAP_V2_FACTORY = 0xeD04530614eA831d407bD916aF0625FC0B17f062;
    address public constant UNISWAP_V2_ROUTER = 0x6a4e354aFa1075fE98771a72fa85F4F003006242;

    constructor(address _tokenImplementation, address _baseToken) {
        tokenImplementation = _tokenImplementation;
        baseToken = IERC20(_baseToken);
    }

    function createToken(string memory name, string memory symbol) public returns (address) {
        address tokenAddress = Clones.clone(tokenImplementation);
        Token token = Token(tokenAddress);
        token.initialize(name, symbol);
        tokens[tokenAddress] = TokenState.FUNDING;
        return tokenAddress;
    }

    function buy(address tokenAddress, uint256 baseTokenAmount) external nonReentrant {
        require(tokens[tokenAddress] == TokenState.FUNDING, "Token not found");
        require(baseTokenAmount > 0, "Base token amount not enough");
        Token token = Token(tokenAddress);
        uint256 valueToBuy = baseTokenAmount;

        if (collateral[tokenAddress] + valueToBuy > FUNDING_GOAL) {
            valueToBuy = FUNDING_GOAL - collateral[tokenAddress];
        }

        uint256 amount = getAmountOut(a, b, token.totalSupply(), valueToBuy);
        uint256 availableSupply = FUNDING_SUPPLY - token.totalSupply();
        require(amount <= availableSupply, "Token not enough");

        require(baseToken.transferFrom(msg.sender, address(this), valueToBuy), "Base token transfer failed");

        collateral[tokenAddress] += valueToBuy;
        token.mint(msg.sender, amount);

        if (collateral[tokenAddress] >= FUNDING_GOAL) {
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
        uint256 receivedBaseToken = getFundsNeeded(a, b, token.totalSupply(), amount);
        collateral[tokenAddress] -= receivedBaseToken;
        require(baseToken.transfer(msg.sender, receivedBaseToken), "Base token transfer failed");
    }

    function calculateBuyReturn(address tokenAddress, uint256 baseTokenAmount) public view returns (uint256) {
        Token token = Token(tokenAddress);
        uint256 amount = getAmountOut(a, b, token.totalSupply(), baseTokenAmount);
        return amount;
    }

    function calculateSellReturn(address tokenAddress, uint256 tokenAmount) public view returns (uint256) {
        Token token = Token(tokenAddress);
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