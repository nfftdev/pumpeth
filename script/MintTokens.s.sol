// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract MintTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenAddress = 0xf985a23edd3982c759AA7a027e70275Ae003ECEc;
        address recipient = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        uint256 amountToMint = 1000000000 * 10**18; // 1000 tokens, adjust decimals as needed

        vm.startBroadcast(deployerPrivateKey);

        Token token = Token(tokenAddress);
        token.mint(recipient, amountToMint);

        vm.stopBroadcast();

        console.log("Minted", amountToMint, "tokens to", recipient);
    }
}
//forge script script/MintTokens.s.sol:MintTokens --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv


////forge script script/MintTokens.s.sol:MintTokens --rpc-url $POLYGON_RPC_URL --broadcast -vvvv
// CANT MINT FROM EOA ADDRESS SINCE THE TOKENFACTORY OWNS IT
//forge script script/MintTokens.s.sol:MintTokens --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv
//cast call 0x714df05138bF7189865601FFdbfaabD7EB24eD1D "owner()(address)" --rpc-url $POLYGON_AMOY_RPC_URL
// IN FACT THE TOKEN FACTORY DOES HAVE MINT, ONLY BUY
// OLD NOTES
// cast call 0x183dfbd4e3880457Bed73D143fBeaFa24d234531 "owner()(address)" --rpc-url $POLYGON_AMOY_RPC_URL
//cast send 0x714df05138bF7189865601FFdbfaabD7EB24eD1D "transferOwnership(address)" 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --rpc-url $POLYGON_AMOY_RPC_URL