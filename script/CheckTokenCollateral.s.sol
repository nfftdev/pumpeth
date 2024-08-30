// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CheckTokenCollateral is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x123F263A89AcbB9a16a2fbBC0Cc4c5dDdE7D826f;
        address tokenAddress = 0x83DaCCDF45796D69DeDdD58eA1CD96395456c661;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        uint256 collateral = tokenFactory.collateral(tokenAddress);
        console.log("Token collateral:", uint(collateral));

        vm.stopBroadcast();
    }
}
//forge script script/CheckTokenCollateral.s.sol:CheckTokenCollateral --rpc-url $POLYGON_RPC_URL --broadcast -vvvv

// AMOY TESTING
// forge script script/CheckTokenCollateral.s.sol:CheckTokenCollateral --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv
//.008000000000000000