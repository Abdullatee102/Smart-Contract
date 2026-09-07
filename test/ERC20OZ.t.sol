// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import {Test} from "../lib/forge-std/src/Test.sol";
import {ERC20OZ} from "../src/ERC20OZ.sol";

contract ERC20OZTest is Test {
    ERC20OZ public token;

    address public deployer = address(this);
    address public alice = address(0x1);
    address public bob = address(0x2);

    string public constant NAME = "techcrush8";
    string public constant SYMBOL = "TCH8";

    function setUp() public {
        token = new ERC20OZ(NAME, SYMBOL);
    }

    function test_Name() public view {
        assertEq(token.name(), NAME);
    }

    function test_Symbol() public view {
        assertEq(token.symbol(), SYMBOL);
    }

    function test_Mint() public {
        token.mint(100, alice);
        assertEq(token.balanceOf(alice), 100);
    }

    function test_Transfer() public {
        token.mint(100, deployer);
        token.transfer(alice, 40);

        assertEq(token.balanceOf(deployer), 60);
        assertEq(token.balanceOf(alice), 40);
    }

    function test_TransferFrom() public {
        token.mint(100, alice);

        vm.prank(alice);
        token.approve(deployer, 50);

        token.transferFrom(alice, bob, 50);

        assertEq(token.balanceOf(alice), 50);
        assertEq(token.balanceOf(bob), 50);
    }

    function test_BalanceOf() public {
        token.mint(75, bob);
        assertEq(token.balanceOf(bob), 75);
    }
}