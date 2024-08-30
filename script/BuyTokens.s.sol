// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract BuyTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // address tokenFactoryAddress = 0x183dfbd4e3880457Bed73D143fBeaFa24d234531;
        // address tokenAddress = 0x714df05138bF7189865601FFdbfaabD7EB24eD1D;
        address tokenFactoryAddress = 0x123F263A89AcbB9a16a2fbBC0Cc4c5dDdE7D826f;
        address tokenAddress = 0x83DaCCDF45796D69DeDdD58eA1CD96395456c661;
        // address recipient = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        uint256 amountToSpend = 0.004 * 10**18; // 0.1 MATIC

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        tokenFactory.buy{value: amountToSpend}(tokenAddress); 
        // tokenFactory.calculateBuyReturn(1 ether); 

        vm.stopBroadcast();

        console.log("Bought", amountToSpend, "worth of tokens from", tokenAddress);
    }
}
//forge script script/BuyTokens.s.sol:BuyTokens --rpc-url $POLYGON_RPC_URL --broadcast -vvvv
//forge script script/BuyTokens.s.sol:BuyTokens --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv