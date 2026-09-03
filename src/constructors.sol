// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract enums {
    // enum: a user-defined data type used to represent a fixed set of constant, named options
    bool isPopoolaTall = true; // true or false

    enum order {
        sharwarma, // 0
        pizza, // 1
        bread, // 2
        peanut // 3
    }

    enum status {
        electionClosed, // 0
        electionStarted, // 1
        electionCanceled // 2
    }

    order public s_currentOrder;
    uint256 height;

    function changeToSharwama(order _order) public {
        s_currentOrder = order.sharwarma;
        s_currentOrder = _order;
    }

    function getOrder() public view returns (order) {
        return s_currentOrder;
    }
}

contract contructors {
    address owner;

    constructor(address _newOwner) {
        owner = _newOwner;
    }
}
