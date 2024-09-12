// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BaseToken.sol";  // Import your Token contract

contract AllowFactoryToSpendBase is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x1C7d9FBd1d20656520FD914E420E3bc2d25Ed747;
        address baseTokenAddress = 0xf985a23edd3982c759AA7a027e70275Ae003ECEc;
        uint256 amountToSpend = 100000 ether;

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
//10000000000000000000000n