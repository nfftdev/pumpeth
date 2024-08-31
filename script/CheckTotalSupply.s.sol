// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract CheckTotalSupply is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // address tokenFactoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        address tokenAddress = 0x6b339d10Ee1dC7dD9c37A121a9b8aA57c61b5FC6;
        
        vm.startBroadcast(deployerPrivateKey);

        // TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        Token token = Token(tokenAddress);
        uint256 totalSupply = token.totalSupply(); 
        
        vm.stopBroadcast();

        console.log("totalSupply", totalSupply);
    }
}
//forge script script/CheckTotalSupply.s.sol:CheckTotalSupply --rpc-url $POLYGON_RPC_URL --broadcast -vvvv
//forge script script/CheckTotalSupply.s.sol:CheckTotalSupply --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv