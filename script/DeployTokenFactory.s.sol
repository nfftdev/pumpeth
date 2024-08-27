// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";
import "../src/Token.sol";

contract DeployTokenFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        uint256 gasPrice = 30 gwei;
        vm.txGasPrice(gasPrice);

        // Deploy the Token implementation
        Token tokenImplementation = new Token();

        // Deploy TokenFactory with the address of the Token implementation
        TokenFactory factory = new TokenFactory(address(tokenImplementation));

        console.log("Token implementation deployed at:", address(tokenImplementation));
        console.log("TokenFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}