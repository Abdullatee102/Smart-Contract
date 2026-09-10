// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {TCH8OZ} from "../src/TCH8OZ.sol";
import {console} from "../lib/forge-std/src/console.sol";

/// TCH80Z Deployment Script (for deployment)
/// Handles deploying the TCH8OZ token and initial token distribution on target networks (like Sepolia)
contract TCH80ZScript is Script {
    string public _name = "TECHCRUSH8";
    string public _symbol = "TCH8";
    
    // Designated protocol/owner address mapped to the newly created MetaMask wallet
    address private protocol = 0x50981497B3644f3a7fbebD1d20c6952cAc0d6c69;
    uint256 public AmountToMint = 1_000_000e18;

    TCH8OZ public tokenTCH;

    function run() public {
        // Starts broadcasting transactions using the private key passed via command line
        vm.startBroadcast();

        // Deploy the token contract onto the live network
        tokenTCH = new TCH8OZ(_name, _symbol, protocol);

        // Mint initial supply to the contract itself
        tokenTCH.mint(address(tokenTCH), AmountToMint);

        // Mint initial tokens directly to the MetaMask personal wallet address
        tokenTCH.mint(protocol, 100_000e18);
        
        // Output contract address to terminal for verification and Etherscan viewing
        console.log("this is the address of my ERC80Z contract", address(tokenTCH));
        
        vm.stopBroadcast();
    }
}