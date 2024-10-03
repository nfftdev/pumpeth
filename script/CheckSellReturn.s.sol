// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CheckSellReturn is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x1C7d9FBd1d20656520FD914E420E3bc2d25Ed747;
        address tokenAddress = 0x73C93c29946A9c6AEA2332445a45ca4271ace636;
        uint256 amountToSpend =  157600000 ether;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        uint256 estimate = tokenFactory.calculateSellReturn(tokenAddress, amountToSpend); 
        
        vm.stopBroadcast();

        console.log("ESTIMATE", estimate, " tokens for ", amountToSpend);
    }
}
//forge script script/CheckSellReturn.s.sol:CheckSellReturn --rpc-url $POLYGON_RPC_URL --broadcast -vvvv
//forge script script/CheckSellReturn.s.sol:CheckSellReturn --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv

//181,821 123460042085249785
//157,000,000 000000000000000000

//157600000000000000000000000
//182661875283521046476724