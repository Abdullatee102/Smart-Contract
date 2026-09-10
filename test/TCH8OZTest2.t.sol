// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {TCH8OZ} from "../src/TCH8OZ.sol";
import {Test} from "../lib/forge-std/src/Test.sol";
import {if_else} from "../src/if_else.sol";

/// TCH8OZ Test Suite (for testing)
/// Comprehensive unit tests for verifying token properties, minting, transfers, allowances, and burning logic
contract TCH80ZTest is Test {
    string public name = "TECHCRUSH8";
    string public symbol = "TCH8";
    uint256 public height = 100;
    TCH8OZ public newTCH08;
    if_else public newifOrElse;

    // Mock test actors
    address public protocol = makeAddr("protocol");
    address public ade = makeAddr("ade");
    address public musa = makeAddr("musa");

    uint256 amountToMint = 1_000_000e18;

    /// Setup function to run before every test execution to deploy fresh contract instances
    function setUp() public {
        newTCH08 = new TCH8OZ(name, symbol, protocol);
        newifOrElse = new if_else();
    }

    /// Tests that the token name is correctly set and retrieved
    function testName() public {
        string memory expectedName = "TECHCRUSH8";
        assertEq(newTCH08.name(), expectedName);
    }

    /// Tests that the token symbol is correctly set and retrieved
    function testSymbol() public {
        string memory expectedSymbol = "TCH8";
        assertEq(newTCH08.symbol(), expectedSymbol);
    }

    /// Tests that the token decimals are configured to 6
    function testDecimal() public {
        uint8 expectedDecimal = 6;
        assertEq(newTCH08.decimals(), expectedDecimal);
    }

    /// Tests minting logic when called by the authorized protocol address
    function testMint() public {
        uint256 expectedAmountToMint = 1_000_000e18;
        vm.prank(protocol); // Simulates call originating from the protocol address
        newTCH08.mint(address(newTCH08), amountToMint);
        uint256 balanceAfterMint = newTCH08.balanceOf(address(newTCH08));

        assertEq(balanceAfterMint, expectedAmountToMint);
    }

    /// Tests standard ERC20 token transfer from protocol to another user
    function testTransfer() public {
        vm.startPrank(protocol);
        newTCH08.mint(protocol, amountToMint);
        newTCH08.transfer(ade, 1000);
        vm.stopPrank();

        assertEq(newTCH08.balanceOf(ade), 1000);
    }

    /// Tests approved spending via transferFrom between accounts
    function testTransferFrom() public {
        vm.startPrank(protocol);
        newTCH08.mint(protocol, amountToMint);
        
        // Protocol approves 'ade' to spend tokens on its behalf
        newTCH08.approve(ade, 5000);
        vm.stopPrank();

        // 'ade' executes transferFrom moving tokens from protocol to musa using the allowance
        vm.prank(ade);
        newTCH08.transferFrom(protocol, musa, 2000);

        assertEq(newTCH08.balanceOf(musa), 2000);
    }

    /// Tests token burning logic to reduce total circulating balance
    function testBurn() public {
        vm.startPrank(protocol);
        newTCH08.mint(protocol, amountToMint);
        uint256 balanceBefore = newTCH08.balanceOf(protocol);
        
        // Protocol burns tokens from its own balance
        newTCH08.burn(1000);
        vm.stopPrank();

        assertEq(newTCH08.balanceOf(protocol), balanceBefore - 1000);
    }
}