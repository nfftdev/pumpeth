// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BaseToken.sol";  // Import your Token contract

contract AllowFactoryToSpendBase is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        address baseTokenAddress = 0x6b339d10Ee1dC7dD9c37A121a9b8aA57c61b5FC6;
        uint256 amountToSpend = 2 ether; 

        vm.startBroadcast(deployerPrivateKey);

        BaseToken token = BaseToken(baseTokenAddress);
        uint256 allowanceBefore = token.allowance(0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3, tokenFactoryAddress);
        console.log("allowance before:", uint(allowanceBefore));
        token.approve(tokenFactoryAddress, amountToSpend);
        uint256 allowanceAfter = token.allowance(0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3, tokenFactoryAddress);
        console.log("allowance after:", uint(allowanceAfter));

        vm.stopBroadcast();
    }
}
//forge script script/AllowFactoryToSpendBase.s.sol:AllowFactoryToSpendBase --rpc-url $POLYGON_RPC_URL --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --broadcast -vvvv
//forge script script/AllowFactoryToSpendBase.s.sol:AllowFactoryToSpendBase --rpc-url $POLYGON_AMOY_RPC_URL --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --broadcast -vvvv
