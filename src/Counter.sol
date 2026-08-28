// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    enum DeliveryStatus {
        Created,
        Processing,
        Ready,
        Completed
    }

    DeliveryStatus public currentStatus;

    error AlreadyCompleted();

    function advanceStatus() public {
        if (currentStatus == DeliveryStatus.Completed) {
            revert AlreadyCompleted();
        }

        currentStatus = DeliveryStatus(uint256(currentStatus) + 1);
    }

    function getStatus() public view returns (DeliveryStatus) {
        return currentStatus;
    }
}