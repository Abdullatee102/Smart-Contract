// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.33;

import {MyToken} from "../src/erc20.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract ERC20OZDeployment is Script {
    // new: is used for creating/ deploying a new smart contract
    string public _name = "techcrush8";

    string public _symbol = "TCH8";

    // totalsupply: 10000000 ether
    uint256 public totalSupply = 10000000 ether;

    MyToken public _MyToken;

    function run() external {
        vm.startBroadcast();

        _MyToken = new MyToken(_name, _symbol);

        console.log("MyToken deployed at:", address(_MyToken));

        // mint total supply to the first address
        _MyToken.mint(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65, totalSupply);

        console.log("Total supply minted:", totalSupply);

        _MyToken.transfer(0x545DF19a98CD6E243AbBc7C41Ae5b940F0325223, 1e16);

        console.log("Transferred:", 1e16);

        vm.stopBroadcast();
    }
}
