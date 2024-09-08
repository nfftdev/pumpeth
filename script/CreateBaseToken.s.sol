// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BaseToken.sol";

contract CreateBaseToken is Script {

    function run() external {
        address initialOwner = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        uint256 initialNewTokenLiquidity = 100 ether;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        uint256 gasPrice = 30 gwei;
        vm.txGasPrice(gasPrice);

        BaseToken baseToken = new BaseToken();

        baseToken.initialize('Cryptickles','TICKLE');
        baseToken.mint(initialOwner, initialNewTokenLiquidity);
        
        console.log("Base Token deployed at:", address(baseToken));

        vm.stopBroadcast();
    }
}
// POLYGON
// forge script script/CreateBaseToken.s.sol:CreateBaseToken --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// TICKLE: 0xf985a23edd3982c759AA7a027e70275Ae003ECEc

// AMOY
// forge script script/CreateBaseToken.s.sol:CreateBaseToken --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// TICKLE: 0xbBE4a0773d1B0d099881c7875d1e79046a5401Cd

// ETHEREUM
// forge script script/CreateBaseToken.s.sol:CreateBaseToken --rpc-url $ETHEREUM_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// TICKLE: 

// SEPOLIA
// forge script script/CreateBaseToken.s.sol:CreateBaseToken --rpc-url $SEPOLIA_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// TICKLE: 0xEDd85881AD7D3CaF438c27Bc07E9af20010AaADe