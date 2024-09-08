// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";
import "../src/Token.sol";

contract DeployTokenFactory is Script {
    function run() external {
        address oracle = 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3;
        address baseTokenAddress = 0xEDd85881AD7D3CaF438c27Bc07E9af20010AaADe;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        // uint256 gasPrice = 30 gwei;
        // vm.txGasPrice(gasPrice);

        // Deploy the Token implementation
        Token tokenImplementation = new Token();

        // Deploy TokenFactory with the address of the Token implementation
        TokenFactory factory = new TokenFactory(address(tokenImplementation), baseTokenAddress, oracle);

        console.log("Token implementation deployed at:", address(tokenImplementation));
        console.log("TokenFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
//forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// == Logs ==
//   Token implementation deployed at: 0xb123d9872fbBCd0a15ff63F78fD14e226183C4E6
//   TokenFactory deployed at: 0x72Bb5e8c5FE4aAbE11F4f80014DE36C1129c53b2
// TESTING CLAUDE MATIC SETTINGS1
// uint256 public constant a = 8970000000000000000;
// uint256 public constant b = 1000000000000000;
//   Token implementation deployed at: 0x7Eeb1CC50D80A1db5f215c60Dc59793D17cF4374
//   TokenFactory deployed at: 0xE9F04f0d22B239032C1C491F68a820fE620D911F
// TEST CLAUDE 2
// Token implementation deployed at: 0xD3Ec944a057FD25Bc5BEC45F86F791301cF7B4e9
//   TokenFactory deployed at: 0x81790689F668c4e87aCf65E7790e1e4d884D5bFD
// TEST CLAUDE 3
//   Token implementation deployed at: 0xA8BA3649fc8C96F72F62C77d59Cc1b2F443Db68d
//   TokenFactory deployed at: 0x28b9B7aab3aD05c2009B2Aca6C3532A4171bC2E3
// USING THE PARAM CURVE FINDER
//  Token implementation deployed at: 0xcc1fCBbD537e411154c61340E81B6C971805c499
//  TokenFactory deployed at: 0x2E470997CAc6cA04674C8C59E4c51BbEBcF22E83
// WITH ORACLE:
//   Token implementation deployed at: 0x1BB6a7786f8AC4D050F38F97303B0f3d1C101DcF
//   TokenFactory deployed at: 0x0Db0f5F0A855F70406e9644Ab004A161BF19f29C

// AMOY TESING
// forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// Token implementation deployed at: 0xb638314b89538E85A2ec01a02921F0598B22c7A3
// TokenFactory deployed at: 0x123F263A89AcbB9a16a2fbBC0Cc4c5dDdE7D826f

// AMOY BANCOR TEST
// forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
//   Token implementation deployed at: 0xb157Fe42959949d9b58B880dFa4ec3E399F396A2
//   TokenFactory deployed at: 0xa876aC551540d8c21F575ef2EBCe582c82d0E294

// AMOY BASE TOKEN TEST
// forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
//   Token implementation deployed at: 0x7ebcFD243999B4fFE76064e3FF052b49A784f3Bb
//   TokenFactory deployed at: 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6

// AMOY BASE TOKEN TICKLE
// forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
//   Token implementation deployed at: 0x4DE9aB09Dc05C84BC68c00221053F5E59aD523eb
//   TokenFactory deployed at: 0xd7E69A3C1B4AFf7E3CD070491845b913b11C632D

// SEPOLIA BASE TOKEN TICKLE
// forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $SEPOLIA_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// Token implementation deployed at: 0x959BAcb63BFc583Dac915c7E6ef3FC5DBd1FD635
// TokenFactory deployed at: 0xBE27aadB0e1907A83D9b94b38b5cc7fC7B08fdC7

// ETHEREUM BASE TOKEN TICKLE
// forge script script/DeployTokenFactory.s.sol:DeployTokenFactory --rpc-url $ETHEREUM_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
