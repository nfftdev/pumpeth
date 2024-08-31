// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract BuyTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        address tokenAddress = 0xC02756E624412FB231082fd015a559363919cf73;
        uint256 amountToSpend = 2 ether; // 2 * 10**18; // 0.1 MATIC + .012000000000000001

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        tokenFactory.buy(tokenAddress, amountToSpend); 
        // tokenFactory.buy{value: amountToSpend}(tokenAddress); 
        // tokenFactory.calculateBuyReturn(1 ether); 

        vm.stopBroadcast();

        console.log("Bought", amountToSpend, "worth of tokens from", tokenAddress);
    }
}
//forge script script/BuyTokens.s.sol:BuyTokens --rpc-url $POLYGON_RPC_URL --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --broadcast -vvvv
//forge script script/BuyTokens.s.sol:BuyTokens --rpc-url $POLYGON_AMOY_RPC_URL --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --broadcast -vvvv
