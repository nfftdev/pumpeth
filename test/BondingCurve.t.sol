// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BondingCurve} from "../src/BondingCurve.sol";

contract TokenFactoryTest is Test {
    BondingCurve bondingCurve;

    function setUp() public {
        bondingCurve = new BondingCurve();
    }

    function test_getFundsNeeded() public view {
        uint256 a = 16319324419;
        uint256 b = 1000000000;
        uint256 x0 = 0;
        uint256 deltaX = 800_000_000 ether;

        uint256 factor = 80000000 ether;

        uint256 expectedFundsNeeded = 20 ether;
        uint256 amount;
        for (uint256 i = 1; i <= 10; i++) {
            amount = bondingCurve.getFundsNeeded(a, b, 0, i * factor);
            console.logUint(amount);
        }

        uint256 fundsNeeded = bondingCurve.getFundsNeeded(a, b, x0, deltaX);
        assertGe(
            fundsNeeded,
            expectedFundsNeeded,
            "Funds needed calculation is incorrect"
        );
    }

    function test_GetAmountOut() public view {
        uint256 a = 16319324419;
        uint256 b = 1000000000;
        uint256 x0 = 0;
        uint256 deltaY = 20e18;

        uint256 expectedAmountOut = 800000000 ether;

        uint256 amountOut = bondingCurve.getAmountOut(a, b, x0, deltaY);

        assertLe(
            amountOut,
            expectedAmountOut,
            "Amount out calculation is incorrect"
        );
    }

    function test_GetAmountOut2() public view {
        uint256 a = 163193244190;
        uint256 b = 10000000000;
        uint256 x0 = 0;
        // uint256 deltaY = 3.5945*1e5*1e18; // Gets you to 1B out
        uint256 deltaY = 4.864*1e4*1e18; // Gets you to 800M out so assuming a complete buyout to complete the curve is about $10k value in, then baseToken = $0.20

        uint256 amountOut = bondingCurve.getAmountOut(a, b, x0, deltaY);

        console.log('a:', a);
        console.log('b:', b);
        console.log('x0 (totalSupply):', x0);
        console.log('---------');
        console.log('deltaY (amountSpent)', deltaY);
        console.log('amountOut', amountOut);
        console.log('---------');
        console.log('deltaY (amountSpent in ETH)', deltaY/1e18);
        console.log('amountOut in ETH', amountOut/1e18);
    }

    function test_GetAmountOut3() public view {
        // TEST 5 (*** GOOD Test Factor 7 ***)
        uint256 a = 1_956_470_534_371;
        uint256 b = 2_500_000_000;
        // WHEN baseToken at about $2 value
        // STEP 1
        uint256 x0 = 0;
        uint256 deltaY = 1e18; 
        // This means when the supply is just starting out, one baseToken will get you about 510,798 of the new token
        // STEP 2
        // uint256 x0 = 0;
        // uint256 deltaY = 5*1e3*1e18; 
        // This means if you put in the $10k worth of baseTokens you get 800M new tokens giving us an estimate of the tokenSupply near the end
        // STEP 3
        // uint256 x0 = 8*1e8*1e18; 
        // uint256 deltaY = 1e18; 
        // This means at the end of the curve 1 baseToken gets you 69167 new tokens (down by less than a factor of 7)

        uint256 amountOut = bondingCurve.getAmountOut(a, b, x0, deltaY);

        console.log('a:', a);
        console.log('b:', b);
        console.log('x0 (totalSupply):', x0);
        console.log('---------');
        console.log('deltaY (amountSpent)', deltaY);
        console.log('amountOut', amountOut);
        console.log('---------');
        console.log('deltaY (amountSpent in ETH)', deltaY/1e18);
        console.log('amountOut in ETH', amountOut/1e18);
    }
}

// -----------------------------
// TEST 1
// uint256 a = 10_067_256_025_238;
// uint256 b = 2_500_000_000;
// WHEN baseToken starts at about $0.02 value
// STEP 1
// uint256 x0 = 0;
// uint256 deltaY = 1e18; 
// This means when the supply is just starting out, one baseToken will get you about 100k of the new token
// STEP 2
// uint256 x0 = 0;
// uint256 deltaY = 5*1e5*1e18; 
// This means if you put in the $10k worth of baseTokens you get 1,931,852,878 new tokens giving us an estimate of the tokenSupply near the end
// STEP 3
// uint256 x0 = 1.9*1e9*1e18; 
// uint256 deltaY = 1e18; 
// This means at the end of the curve 1 baseToken gets you 859 new tokens (down by a factor of 116)
// -----------------------------
// TEST 2
// uint256 a = 10_067_256_025_238;
// uint256 b = 1_000_000_000;
// WHEN baseToken starts at about $0.02 value
// STEP 1
// uint256 x0 = 0;
// uint256 deltaY = 1e18; 
// This means when the supply is just starting out, one baseToken will get you about 100k of the new token
// STEP 2
// uint256 x0 = 0;
// uint256 deltaY = 5*1e5*1e18; 
// This means if you put in the $10k worth of baseTokens you get 3,925,254,412 new tokens giving us an estimate of the tokenSupply near the end
// STEP 3
// uint256 x0 = 3.9*1e9*1e18; 
// uint256 deltaY = 1e18; 
// This means at the end of the curve 1 baseToken gets you 2010 new tokens (down by a factor of 50)
// -----------------------------
// TEST 3
// uint256 a = 606470203785182;
// uint256 b = 74866472;
// WHEN baseToken starts at about $0.02 value
// STEP 1
// uint256 x0 = 0;
// uint256 deltaY = 1e18; 
// This means when the supply is just starting out, one baseToken will get you about 1648 of the new token
// STEP 2
// uint256 x0 = 0;
// uint256 deltaY = 5*1e5*1e18; 
// This means if you put in the $10k worth of baseTokens you get 800M new tokens giving us an estimate of the tokenSupply near the end
// STEP 3
// uint256 x0 = 8*1e8*1e18; 
// uint256 deltaY = 1e18; 
// This means at the end of the curve 1 baseToken gets you 1553 new tokens (down by less than a factor of 2)
// -----------------------------
// TEST 4 (**** GOOD TEST FACTOR 7 ****)
// uint256 a = 195_647_053_437_083;
// uint256 b = 2_500_000_000;
// WHEN baseToken starts at about $0.02 value
// STEP 1
// uint256 x0 = 0;
// uint256 deltaY = 1e18; 
// This means when the supply is just starting out, one baseToken will get you about 5111 of the new token
// STEP 2
// uint256 x0 = 0;
// uint256 deltaY = 5*1e5*1e18; 
// This means if you put in the $10k worth of baseTokens you get 800M new tokens giving us an estimate of the tokenSupply near the end
// STEP 3
// uint256 x0 = 8*1e8*1e18; 
// uint256 deltaY = 1e18; 
// This means at the end of the curve 1 baseToken gets you 691 new tokens (down by less than a factor of 7)
// -----------------------------
// TEST 5 (*** GOOD Test Factor 7 ***)
// uint256 a = 1_956_470_534_371;
// uint256 b = 2_500_000_000;
// WHEN baseToken at about $2 value
// STEP 1
// uint256 x0 = 0;
// uint256 deltaY = 1e18; 
// This means when the supply is just starting out, one baseToken will get you about 510,798 of the new token
// STEP 2
// uint256 x0 = 0;
// uint256 deltaY = 5*1e3*1e18; 
// This means if you put in the $10k worth of baseTokens you get 800M new tokens giving us an estimate of the tokenSupply near the end
// STEP 3
// uint256 x0 = 8*1e8*1e18; 
// uint256 deltaY = 1e18; 
// This means at the end of the curve 1 baseToken gets you 69167 new tokens (down by less than a factor of 7)
// -----------------------------




// WOLFRAM ALPHA
// plot (Log[Exp[b*s] + (b*x)/a]/b - s) with s = 1e18, a = 1631932441900, b = 10000000000 for x = 0 to 8e26
// plot (Log[Exp[b*x] + (b*d)/a]/b - x) with d = 1e18, a = 1631932441900, b = 10000000000 for x = 0 to 8e26

//OLD NOTES
// uint256 a = 1_631_932_441_900;
// uint256 a = 10_067_256_025_238;
// uint256 b = 2_500_000_000;
// uint256 b = 2_500_000_000;

// uint256 x0 = 8e8*1e18; // at this supply with 1e18 spent you get 205
// uint256 x0 = 0; // at this supply with 1e18 spent you get 610,900
// uint256 deltaY = 1e18; 
// uint256 deltaY = 3.5945*1e6*1e18; // Gets you to 1B out
// uint256 deltaY = 4.864*1e5*1e18; // Gets you to 800M out so assuming a complete buyout to complete the curve is about $10k value in, then baseToken = $0.02
// uint256 deltaY = 3*1e6*1e18;

// uint256 x0 = 3.45e8*1e18; // at this supply with 1e18 spent you get 205
// uint256 x0 = 3.22e8*1e18; // at this supply with 1e18 spent you get 205
// uint256 x0 = 2*1e9*1e18; // at this supply with 1e18 spent you get 205
// uint256 deltaY = 5*1e5*1e18; //345,437,546 322,884,731 10,589,956,814 1,289,251,925 249,595,927 100k 1,931,852,878



// By the end of the bonding curve (about 3M baseTokens in) it will only get you about 13442 (a factor of 7.4)
// If the baseToken becomes worth $2 then with the same a and b (but a lower funding goal)
// one baseToken will get you about 100k of the new token
// By the end of the bonding curve (about 5K baseTokens in) it will only get you about 44.4K (a factor of 2.2)
// Therefore when baseToken = $2 change b to:




// a = 1631932441900;
// b = 10000000000;
// WHEN baseToken starts at about $0.02 value
// This means when the supply is just starting out, one baseToken will get you about 100k of the new token
// By the end of the bonding curve (about 3M baseTokens in) it will only get you about 33 (a factor of 3000)
// If the baseToken becomes worth $2 then with the same a and b (but a lower funding goal)
// one baseToken will get you about 600k of the new token
// By the end of the bonding curve (about 5K baseTokens in) it will only get you about 68M (a factor of 100)

// a = 10_067_256_025_238;
// b = 10000000000;
// WHEN baseToken starts at about $0.02 value
// This means when the supply is just starting out, one baseToken will get you about 100k of the new token
// By the end of the bonding curve (about 3M baseTokens in) it will only get you about 200 (a factor of 3000)
// If the baseToken becomes worth $2 then with the same a and b (but a lower funding goal)
// one baseToken will get you about 600k of the new token
// By the end of the bonding curve (about 5K baseTokens in) it will only get you about 68M (a factor of 100)