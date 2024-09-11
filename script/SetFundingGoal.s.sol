// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "forge-std/Script.sol";
// import "../src/TokenFactory.sol";

// contract SetFundingGoal is Script {
//     function run() external {
//         uint256 newFundingGoal = 10000;
//         address factoryAddress = 0xBE27aadB0e1907A83D9b94b38b5cc7fC7B08fdC7;
//         TokenFactory factory = TokenFactory(factoryAddress);

//         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(deployerPrivateKey);

//         // Interact with your contract
//         factory.setFundingGoal(newFundingGoal);
//         console.log("New funding goal set:", newFundingGoal);

//         vm.stopBroadcast();
//     }
// }
// //forge script script/SetFundingGoal.s.sol:SetFundingGoal --rpc-url $POLYGON_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv
// //forge script script/SetFundingGoal.s.sol:SetFundingGoal --rpc-url $POLYGON_AMOY_RPC_URL --broadcast --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 -vvvv