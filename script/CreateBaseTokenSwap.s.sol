// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BaseToken.sol";
import "@uniswap-v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap-v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap-v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";

contract CreateBaseTokenSwap is Script {
    address public constant UNISWAP_V2_FACTORY = 0xeD04530614eA831d407bD916aF0625FC0B17f062;
    address public constant UNISWAP_V2_ROUTER = 0x6a4e354aFa1075fE98771a72fa85F4F003006242;

    function run() external {
        // address initialOwner = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        address newToken = 0xbBE4a0773d1B0d099881c7875d1e79046a5401Cd;
        uint256 initialNewTokenLiquidity = 100 ether;
        uint256 initialNativeTokenLiquidity = 0.001 ether;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        // uint256 gasPrice = 30 gwei;
        // vm.txGasPrice(gasPrice);

        address pair = createLiquilityPool(newToken);
        uint256 liquidity = addLiquidity(newToken, initialNewTokenLiquidity, initialNativeTokenLiquidity);
        
        console.log("Swap created at:", address(pair));

        vm.stopBroadcast();
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
        BaseToken token = BaseToken(tokenAddress);
        IUniswapV2Router01 router = IUniswapV2Router01(UNISWAP_V2_ROUTER);
        token.approve(UNISWAP_V2_ROUTER, tokenAmount);
        uint256 deadline = block.timestamp + 15 minutes;
        (, , uint256 liquidity) = router.addLiquidityETH{value: ethAmount}(
            tokenAddress,
            tokenAmount,
            tokenAmount,
            ethAmount,
            address(this),
            deadline
        );
        return liquidity;
    }
}
//forge script script/CreateBaseTokenSwap.s.sol:CreateBaseTokenSwap --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv

// AMOY TICKLE
// forge script script/CreateBaseTokenSwap.s.sol:CreateBaseTokenSwap --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// SWAP: 0xaa652ee3DF27843aBa9a7f3EA237e28A40BFd7F1
