// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CreateAToken is Script {
    function run() external {
        address factoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        TokenFactory factory = TokenFactory(factoryAddress);
        uint256 fundingGoal = 6e25;
        uint256 a = 195_647_053_437_083;
        uint256 b = 2_500_000_000;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Interact with your contract
        address newToken = factory.createToken("BaseHIT", "BASEHIT", fundingGoal, a, b);
        console.log("New token created at:", newToken);

        vm.stopBroadcast();
    }
}
////forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
//forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
//forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --gas-price -vvvv
// CLAUDE TEST1: 0xFFd7025BBDa884f960EbDe73b963Ccb18DC5Ce36
// CLAUDE TEST2: 0x92e62e1A6005dF37438333755bB8E9B74fC57dD7
// CLAUDE TEST2: 0x88D95f11fDC3Ced7EBff7D1ada53De26d3202E9A
// From Param Finder: 0x7d9BD2FFF3C6be43F86fc9B434D2f07816DC1776


// AMOY TESTING
// forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv

// AMOY TESTING WITH BANCOR
// forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv

// AMOY TESTING WITH BASE TOKEN
// forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv