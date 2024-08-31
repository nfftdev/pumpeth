// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CheckTokenState is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0xa876aC551540d8c21F575ef2EBCe582c82d0E294;
        address tokenAddress = 0xb487f7aA4d5DE24b217e73AE79d63B2066c15E6b;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        TokenFactory.TokenState state = tokenFactory.tokens(tokenAddress);
        console.log("Token State:", uint(state));

        vm.stopBroadcast();
    }
}
//forge script script/CheckTokenState.s.sol:CheckTokenState --rpc-url $POLYGON_RPC_URL --broadcast -vvvv

// AMOY TESTING
// forge script script/CheckTokenState.s.sol:CheckTokenState --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv