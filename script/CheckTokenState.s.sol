// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";

contract CheckTokenState is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenFactoryAddress = 0x1C7d9FBd1d20656520FD914E420E3bc2d25Ed747;
        address tokenAddress = 0xdBe7a1C61EF4d1BA39B1CC56f89cB7F4D587Cefc;

        vm.startBroadcast(deployerPrivateKey);

        TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        TokenFactory.TokenState state = tokenFactory.tokens(tokenAddress);
        uint256 collateral = tokenFactory.collateral(tokenAddress);
        uint256 fundingGoal = tokenFactory.fundingGoals(tokenAddress);
        uint256 a = tokenFactory.aConstants(tokenAddress);
        uint256 b = tokenFactory.bConstants(tokenAddress);
        IERC20 baseToken = tokenFactory.baseToken();
        address baseTokenAddress = address(baseToken);
        console.log("BaseToken Address:", baseTokenAddress);
        console.log("Token State:", uint(state));
        console.log("collateral:", collateral);
        console.log("fundingGoal:", fundingGoal);
        console.log("a:", a);
        console.log("b:", b);
        
        vm.stopBroadcast();
    }
}
// forge script script/CheckTokenState.s.sol:CheckTokenState --rpc-url $POLYGON_RPC_URL --broadcast -vvvv

// AMOY TESTING
// forge script script/CheckTokenState.s.sol:CheckTokenState --rpc-url $POLYGON_AMOY_RPC_URL --broadcast -vvvv
// 42
// 50