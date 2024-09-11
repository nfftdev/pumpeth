// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "forge-std/Script.sol";
// import "../src/TokenFactory.sol";  // Import your Token contract

// contract BuyTester is Script {
//     function run() external {
//         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
//         address tokenFactoryAddress = 0xC76Ce18B4bfcCeC0dA5F9126C0F823ef672161A6;
//         address tokenAddress = 0xf985a23edd3982c759AA7a027e70275Ae003ECEc;
//         uint256 amountToSpend = 2 ether; // 2 * 10**18; // 0.1 MATIC + .012000000000000001

//         vm.startBroadcast(deployerPrivateKey);

//         TokenFactory tokenFactory = TokenFactory(tokenFactoryAddress);
        
//         Token token = Token(tokenAddress);
        
//         uint256 valueToBuy = amountToSpend;

//         uint256 collateral = tokenFactory.collateral(tokenAddress);
//         console.log("Token collateral:", uint(collateral));
        
//         if (collateral + valueToBuy > tokenFactory.FUNDING_GOAL()) {
//             valueToBuy = tokenFactory.FUNDING_GOAL() - collateral;
//             console.log("valueToBuy:", uint(valueToBuy));
//         }

//         uint256 amount = tokenFactory.getAmountOut(tokenFactory.a(), tokenFactory.b(), token.totalSupply(), valueToBuy);
//         console.log("amount:", uint(amount));
//         uint256 availableSupply = tokenFactory.FUNDING_SUPPLY() - token.totalSupply();
//         require(amount <= availableSupply, "Token not enough");
//         console.log("availableSupply:", uint(availableSupply));

//         require(tokenFactory.baseToken().transferFrom(msg.sender, address(this), valueToBuy), "Base token transfer failed");
//         console.log("COMPLETED");
//         // tokenFactory.collateral[tokenAddress] += valueToBuy;
//         // token.mint(msg.sender, amount);

//         // if (collateral[tokenAddress] >= FUNDING_GOAL) {
//         //     token.mint(address(this), INITIAL_SUPPLY);
//         //     address pair = createLiquilityPool(tokenAddress);
//         //     uint256 liquidity = addLiquidity(tokenAddress, INITIAL_SUPPLY, collateral[tokenAddress]);
//         //     burnLiquidityToken(pair, liquidity);
//         //     collateral[tokenAddress] = 0;
//         //     tokens[tokenAddress] = TokenState.TRADING;
//         // }

//         // if (valueToBuy < baseTokenAmount) {
//         //     require(baseToken.transfer(msg.sender, baseTokenAmount - valueToBuy), "Base token refund failed");
//         // }

//         vm.stopBroadcast();

//         console.log("Bought", amountToSpend, "worth of tokens from", tokenAddress);
//     }
// }
// //forge script script/BuyTester.s.sol:BuyTester --rpc-url $POLYGON_RPC_URL --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --broadcast -vvvv
// //forge script script/BuyTester.s.sol:BuyTester --rpc-url $POLYGON_AMOY_RPC_URL --sender 0xF51F97A20C4e00fd4d8F85462cf344Bb152B10a3 --broadcast -vvvv
