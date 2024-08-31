// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract CheckBuyReturn is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        address tokenAddress = 0xC02756E624412FB231082fd015a559363919cf73;
        // address tokenFactoryAddress = 0x72Bb5e8c5FE4aAbE11F4f80014DE36C1129c53b2;
        // address tokenAddress = 0xDF42294380B76723697BB691F8ac12b2Ca047Ee6;
        // address tokenFactoryAddress = 0x183dfbd4e3880457Bed73D143fBeaFa24d234531;
        // address tokenAddress = 0x714df05138bF7189865601FFdbfaabD7EB24eD1D;
        // address recipient = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        uint256 amountToSpend =  2 ether;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        uint256 estimate = tokenFactory.calculateBuyReturn(tokenAddress, amountToSpend); 
        
        vm.stopBroadcast();

        console.log("ESTIMATE", estimate, " tokens for ", amountToSpend);
    }
}
//forge script script/CheckBuyReturn.s.sol:CheckBuyReturn --rpc-url $POLYGON_RPC_URL --broadcast -vvvv
//forge script script/CheckBuyReturn.s.sol:CheckBuyReturn --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv
//199998 000026660000000000
//     2 000000000000000000