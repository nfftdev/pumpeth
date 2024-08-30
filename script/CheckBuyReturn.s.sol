// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";  // Import your Token contract

contract CheckBuyReturn is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x2E470997CAc6cA04674C8C59E4c51BbEBcF22E83;
        address tokenAddress = 0x7d9BD2FFF3C6be43F86fc9B434D2f07816DC1776;
        // address tokenFactoryAddress = 0x72Bb5e8c5FE4aAbE11F4f80014DE36C1129c53b2;
        // address tokenAddress = 0xDF42294380B76723697BB691F8ac12b2Ca047Ee6;
        // address tokenFactoryAddress = 0x183dfbd4e3880457Bed73D143fBeaFa24d234531;
        // address tokenAddress = 0x714df05138bF7189865601FFdbfaabD7EB24eD1D;
        // address recipient = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        uint256 amountToSpend =  330 ether;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        uint256 estimate = tokenFactory.calculateBuyReturn(tokenAddress, amountToSpend); 
        
        vm.stopBroadcast();

        console.log("ESTIMATE", estimate, " tokens for ", amountToSpend);
    }
}
//forge script script/CheckBuyReturn.s.sol:CheckBuyReturn --rpc-url $POLYGON_RPC_URL --broadcast -vvvv