// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.33;

import {ERC20OZ} from "../src/ERC20OZ.sol";
// import the script contract std
import {Script} from "../lib/forge-std/src/Script.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract ERC20OZDeployment is Script {

    // new: is used for creating/ deploying a new smart contract
    // name:
    string public _name = "techcrush8";
    // symbol: TCH8
    string public _symbol = "TCH8";
    // totalsupply: 10000000 ether
    uint256 public totalSupply = 10000000 ether;

    ERC20OZ public _ERC20OZ;

    function run() external {
        vm.startBroadcast();
        _ERC20OZ = new ERC20OZ(_name, _symbol);
        _ERC20OZ.mint(1e18, 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
        _ERC20OZ.transfer(0x545DF19a98CD6E243AbBc7C41Ae5b940F0325223, 1e16);
        vm.stopBroadcast();
    }

}

// forge script script/ERC20OZDeployment.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key <private key>