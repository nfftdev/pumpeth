// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol"; 

contract GetFactoryInfo is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address factoryAddress = 0x7C26472c955179972866d5200AF116E4A1f082d2;//0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
        // address tokenAddress = 0xfE5DC5E2ce30b90B0EaFDE2E0D1EdfD2FB0acf8C;
        address owner = 0x943906195923F5dC79a55Ea322E0E785d48f820D;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory factory = TokenFactory(factoryAddress);
        IERC20 baseToken = factory.baseToken();
        address baseTokenAddress = address(baseToken);
        // uint256 allowance = baseToken.allowance(owner, factoryAddress);
        console.log("baseTokenAddress:", baseTokenAddress);
        
        vm.stopBroadcast();
    }
}
//forge script script/GetFactoryInfo.s.sol:GetFactoryInfo --rpc-url $POLYGON_RPC_URL --broadcast -vvvv