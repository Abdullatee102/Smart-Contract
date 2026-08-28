// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Counter} from "../src/Counter.sol";

contract CounterTest {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function testInitialStatus() public {
        assert(uint256(counter.getStatus()) == 0);
    }

    function testAdvanceStatus() public {
        counter.advanceStatus();

        assert(uint256(counter.getStatus()) == 1);
    }

    function testAdvanceMultipleTimes() public {
        counter.advanceStatus();
        counter.advanceStatus();
        counter.advanceStatus();

        assert(uint256(counter.getStatus()) == 3);
    }

    function testCannotAdvanceAfterCompleted() public {
        counter.advanceStatus();
        counter.advanceStatus();
        counter.advanceStatus();

        try counter.advanceStatus() {
            assert(false);
        } catch {
            assert(true);
        }
    }
}