// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {FixedPointMathLib} from "solady/src/utils/FixedPointMathLib.sol";

contract BondingCurve {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    // calculate the funds needed to buy deltaX tokens
    function getFundsNeeded(
        uint256 a,
        uint256 b,
        uint256 x0,
        uint256 deltaX
    ) public pure returns (uint256 deltaY) {
        // calculate exp(b*x0), exp(b*x1)
        int256 exp_b_x0 = (int256(b.mulWad(x0))).expWad();
        int256 exp_b_x1 = (int256(b.mulWad(x0 + deltaX))).expWad();

        // calculate deltaY = (a/b)*(exp(b*x1) - exp(b*x0))
        uint256 delta = uint256(exp_b_x1 - exp_b_x0);
        deltaY = a.fullMulDiv(delta, b);
    }

    // calculte the number of tokens that can be purchased for a given amount of funds
    function getAmountOut(
        uint256 a,
        uint256 b,
        uint256 x0,
        uint256 deltaY
    ) public pure returns (uint256 deltaX) {
        // calculate exp(b*x0)
        uint256 exp_b_x0 = uint256((int256(b.mulWad(x0))).expWad());

        // calculate exp(b*x0) + (dy*b/a)
        uint256 exp_b_x1 = exp_b_x0 + deltaY.fullMulDiv(b, a);

        // calculate ln(x1)/b-x0
        deltaX = uint256(int256(exp_b_x1).lnWad()).divWad(b) - x0;
    }
}
