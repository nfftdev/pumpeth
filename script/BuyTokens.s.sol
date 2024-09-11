// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract BuyTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x1C7d9FBd1d20656520FD914E420E3bc2d25Ed747;
        address tokenAddress = 0x0A4E502b3E5FA98DC43E5Dd1bb94e3bbbaA6F468;
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
