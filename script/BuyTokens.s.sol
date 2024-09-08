// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract BuyTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x0Db0f5F0A855F70406e9644Ab004A161BF19f29C;
        address tokenAddress = 0xCc07043DB3192A0910f093A344F639B384594a55;
        uint256 amountToSpend = 1 ether; // 2 * 10**18; // 0.1 MATIC + .012000000000000001

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
