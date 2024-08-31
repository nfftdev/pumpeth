// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CheckTokenState is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        address tokenAddress = 0xC02756E624412FB231082fd015a559363919cf73;

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