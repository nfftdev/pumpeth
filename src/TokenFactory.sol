// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Token} from "./Token.sol";

import "@uniswap-v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap-v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap-v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {BondingCurve} from "./BondingCurve.sol";


contract TokenFactory is BondingCurve, ReentrancyGuard {
    enum TokenState {
        NOT_CREATED,
        FUNDING,
        TRADING
    }
    uint256 public constant MAX_SUPPLY = 10 ** 9 * 10 ** 18;
    uint256 public constant INITIAL_SUPPLY = (MAX_SUPPLY * 1) / 5;
    uint256 public constant FUNDING_SUPPLY = (MAX_SUPPLY * 4) / 5;
    uint256 public constant FUNDING_GOAL = 20 ether;
    uint256 public constant a = 16319324419;
    uint256 public constant b = 1000000000;
    mapping(address => TokenState) public tokens;
    mapping(address => uint256) public collateral;
    address public immutable tokenImplementation;

    // ETHEREUM
    // address public constant UNISWAP_V2_FACTORY =
    //     0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    // address public constant UNISWAP_V2_ROUTER =
    //     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // POLYGON MAINNET
    address public constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address public constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    constructor(address _tokenImplementation) {
        tokenImplementation = _tokenImplementation;
    }

    function createToken(
        string memory name,
        string memory symbol
    ) public returns (address) {
        address tokenAddress = Clones.clone(tokenImplementation);
        Token token = Token(tokenAddress);
        token.initialize(name, symbol);
        tokens[tokenAddress] = TokenState.FUNDING;
        return tokenAddress;
    }

    function buy(address tokenAddress) external payable nonReentrant{
        require(tokens[tokenAddress] == TokenState.FUNDING, "Token not found");
        require(msg.value > 0, "ETH not enough");
        Token token = Token(tokenAddress);
        uint256 valueToBuy = msg.value;
        // TODO: convert collateral[tokenAddress] to memory

        if(collateral[tokenAddress] + valueToBuy > FUNDING_GOAL) {
            valueToBuy = FUNDING_GOAL - collateral[tokenAddress];
        }
        uint256 amount = getAmountOut(a, b, token.totalSupply(), valueToBuy);
        uint256 availableSupply = FUNDING_SUPPLY - token.totalSupply();
        require(amount <= availableSupply, "Token not enough");
        collateral[tokenAddress] += valueToBuy;
        token.mint(msg.sender, amount);
        // when reach FUNDING_GOAL
        if (collateral[tokenAddress] >= FUNDING_GOAL) {
            token.mint(address(this), INITIAL_SUPPLY);
            address pair = createLiquilityPool(tokenAddress);
            uint256 liquidity = addLiquidity(
                tokenAddress,
                INITIAL_SUPPLY,
                collateral[tokenAddress]
            );
            burnLiquidityToken(pair, liquidity);
            collateral[tokenAddress] = 0;
            tokens[tokenAddress] = TokenState.TRADING;
        }
        if (valueToBuy < msg.value) {
            (bool success, ) = msg.sender.call{value: msg.value-valueToBuy}(new bytes(0));
            require(success, "ETH send failed");
        }
    }

    function sell(address tokenAddress, uint256 amount) external {
        require(tokens[tokenAddress] == TokenState.FUNDING, "Token not found");
        require(amount > 0, "Token not enough");
        Token token = Token(tokenAddress);
        token.burn(msg.sender, amount);
        uint256 receivedETH = getFundsNeeded(a, b, token.totalSupply(), amount);
        collateral[tokenAddress] -= receivedETH;
        // send ether
        (bool success, ) = msg.sender.call{value: receivedETH}(new bytes(0));
        require(success, "ETH send failed");
    }

    function calculateBuyReturn(
        address tokenAddress,
        uint256 ethAmount
    ) public view returns (uint256) {
        Token token = Token(tokenAddress);
        uint256 amount = getAmountOut(a, b, token.totalSupply(), ethAmount);
        return amount;
    }

    function calculateSellReturn(
        address tokenAddress,
        uint256 tokenAmount
    ) public view returns (uint256) {
        Token token = Token(tokenAddress);
        uint256 receivedETH = getFundsNeeded(a, b, token.totalSupply(), tokenAmount);
        return receivedETH;
    }

    function createLiquilityPool(
        address tokenAddress
    ) internal returns (address) {
        IUniswapV2Factory factory = IUniswapV2Factory(UNISWAP_V2_FACTORY);
        IUniswapV2Router01 router = IUniswapV2Router01(UNISWAP_V2_ROUTER);

        address pair = factory.createPair(tokenAddress, router.WETH());
        return pair;
    }

    function addLiquidity(
        address tokenAddress,
        uint256 tokenAmount,
        uint256 ethAmount
    ) internal returns (uint256) {
        Token token = Token(tokenAddress);
        IUniswapV2Router01 router = IUniswapV2Router01(UNISWAP_V2_ROUTER);
        token.approve(UNISWAP_V2_ROUTER, tokenAmount);
        (, , uint256 liquidity) = router.addLiquidityETH{value: ethAmount}(
            tokenAddress,
            tokenAmount,
            tokenAmount,
            ethAmount,
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
