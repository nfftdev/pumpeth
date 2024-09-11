// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract TokenBondingCurve {
    uint256 private constant PRECISION = 1e6;

    struct Point {
        uint256 x;
        uint256 y;
    }

    Point[] private curvePoints;

    constructor() {
        // Define the curve points (using PRECISION for better accuracy)
        curvePoints.push(Point(0, 3000000 * PRECISION));
        curvePoints.push(Point(40000 * PRECISION, 2000000 * PRECISION));
        curvePoints.push(Point(40000000 * PRECISION, 16000000 * PRECISION));
        curvePoints.push(Point(800000000 * PRECISION, 20000000 * PRECISION));
    }

    function calculatePurchaseReturn(uint256 totalSupply, uint256 baseTokenAmount) public view returns (uint256) {
        uint256 newSupply = totalSupply + baseTokenAmount;
        uint256 currentY = getY(totalSupply);
        uint256 newY = getY(newSupply);
        return newY > currentY ? newY - currentY : 0;
    }

    function calculateSellReturn(uint256 totalSupply, uint256 baseTokenAmount) public view returns (uint256) {
        if (totalSupply <= baseTokenAmount) {
            return 0;
        }
        uint256 newSupply = totalSupply - baseTokenAmount;
        uint256 currentY = getY(totalSupply);
        uint256 newY = getY(newSupply);
        return currentY > newY ? currentY - newY : 0;
    }

    function getY(uint256 x) private view returns (uint256) {
        for (uint i = 1; i < curvePoints.length; i++) {
            if (x <= curvePoints[i].x) {
                uint256 x0 = curvePoints[i-1].x;
                uint256 y0 = curvePoints[i-1].y;
                uint256 x1 = curvePoints[i].x;
                uint256 y1 = curvePoints[i].y;
                
                // Linear interpolation with higher precision
                return y0 + (x - x0) * (y1 - y0) / (x1 - x0);
            }
        }
        
        // If x is beyond the last point, use the last segment
        Point memory lastPoint = curvePoints[curvePoints.length - 1];
        Point memory secondLastPoint = curvePoints[curvePoints.length - 2];
        return lastPoint.y + 
            (x - lastPoint.x) * (lastPoint.y - secondLastPoint.y) / (lastPoint.x - secondLastPoint.x);
    }
}