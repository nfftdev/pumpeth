// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CheckTokenCollateral is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0xE885723dC412704F69bC4014f893046E5ff1481f;
        address tokenAddress = 0xB5BcC87Ead5c6f7C1c1e323B6120AEc3C7d65f7c;

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