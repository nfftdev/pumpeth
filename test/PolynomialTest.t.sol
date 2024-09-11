// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenBondingCurve} from "../src/PolynomialCurve.sol";

contract TokenFactoryTest is Test {
    TokenBondingCurve polynomialSigmoidBondingCurve;

    function setUp() public {
        polynomialSigmoidBondingCurve = new TokenBondingCurve();
    }

    function test_calculatePolyPurchaseReturn() public view {
        uint256[] memory supplies = new uint256[](5);
        supplies[0] = 0;
        supplies[1] = 40000 * 1e18;      // 40,000 tokens
        supplies[2] = 1000000 * 1e18;    // 1,000,000 tokens
        supplies[3] = 40000000 * 1e18;   // 40,000,000 tokens
        supplies[4] = 800000000 * 1e18;  // 800,000,000 tokens

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 1e18;         // 1 token
        amounts[1] = 1000 * 1e18;  // 1,000 tokens
        amounts[2] = 1000000 * 1e18; // 1,000,000 tokens

        for (uint i = 0; i < supplies.length; i++) {
            for (uint j = 0; j < amounts.length; j++) {
                uint256 tokensMinted = polynomialSigmoidBondingCurve.calculatePurchaseReturn(supplies[i], amounts[j]);
                console.log('Supply:', supplies[i] / 1e18);
                console.log('Amount:', amounts[j] / 1e18);
                console.log('Tokens Minted:', tokensMinted / 1e18);
                console.log('---');
            }
        }
    }
}