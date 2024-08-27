// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";

contract CreateAToken is Script {
    function run() external {
        address factoryAddress = 0x183dfbd4e3880457Bed73D143fBeaFa24d234531;
        TokenFactory factory = TokenFactory(factoryAddress);

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Interact with your contract
        address newToken = factory.createToken("GSecond", "GSCND");
        console.log("New token created at:", newToken);

        vm.stopBroadcast();
    }
}

//forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
//forge script script/CreateAToken.s.sol:CreateAToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --gas-report -vvvv