// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BancorFormula} from "../src/BancorFormula.sol";

contract TokenFactoryTest is Test {
    BancorFormula bancorFormula;

    function setUp() public {
        bancorFormula = new BancorFormula();
    }
//2456724512833 081434275324385550
//99999999999943750
    function test_calculatePurchaseReturn() public view {
        uint256 supply = 10 * 1e18;
        uint256 connectorBalance = 800_000_000_000;
        uint32 connectorWeight = 100000;
        uint256 depositAmount = 1e18;

        console.log("Supply:", supply);
        console.log("Connector Balance:", connectorBalance);
        console.log("Connector Weight:", connectorWeight);
        console.log("Deposit Amount:", depositAmount);

        try bancorFormula.calculatePurchaseReturn(supply, connectorBalance, connectorWeight, depositAmount) returns (uint256 amountOut) {
            console.log("Amount Out:", amountOut);
            console.log("Amount Out (in ether):", amountOut / 1e18);
        } catch Error(string memory reason) {
            console.log("Revert reason:", reason);
        } catch (bytes memory lowLevelData) {
            console.log("Low level revert:");
            console.logBytes(lowLevelData);
        }

        // // Test with non-zero supply
        // supply = 1000000 * 1e18; // 1 million tokens
        // console.log("\nTesting with non-zero supply:");
        // console.log("Supply:", supply);

        // try bancorFormula.calculatePurchaseReturn(supply, connectorBalance, connectorWeight, depositAmount) returns (uint256 amountOut) {
        //     console.log("Amount Out:", amountOut);
        //     console.log("Amount Out (in ether):", amountOut / 1e18);
        // } catch Error(string memory reason) {
        //     console.log("Revert reason:", reason);
        // } catch (bytes memory lowLevelData) {
        //     console.log("Low level revert:");
        //     console.logBytes(lowLevelData);
        // }

        // // Test with maximum weight
        // connectorWeight = 1000000; // MAX_WEIGHT
        // console.log("\nTesting with maximum weight:");
        // console.log("Connector Weight:", connectorWeight);

        // try bancorFormula.calculatePurchaseReturn(supply, connectorBalance, connectorWeight, depositAmount) returns (uint256 amountOut) {
        //     console.log("Amount Out:", amountOut);
        //     console.log("Amount Out (in ether):", amountOut / 1e18);
        // } catch Error(string memory reason) {
        //     console.log("Revert reason:", reason);
        // } catch (bytes memory lowLevelData) {
        //     console.log("Low level revert:");
        //     console.logBytes(lowLevelData);
        // }
    }
}