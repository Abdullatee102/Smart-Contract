// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/// TCH8OZ Token Contract (Source code)
/// An ERC20 compliant token featuring restricted minting and burning via a designated protocol address.
contract TCH8OZ is ERC20 {
    // Custom error for gas efficiency when unauthorized accounts try to call protocol functions
    error onlyProtocolAddressError();

    string public T_name;
    string public T_symbol;
    uint256 public T_totalSupply;
    address public protocol;

    /// Modifier to restrict access strictly to the designated protocol address
    modifier onlyProtocol() {
        if (msg.sender != protocol) {
            revert onlyProtocolAddressError();
        }
        _;
    }

    /// Initializes the token with a name, symbol, and sets the authorized protocol address
    constructor(string memory _name, string memory _symbol, address _protocol) ERC20(_name, _symbol) {
        T_name = _name;
        T_symbol = _symbol;
        protocol = _protocol;
    }

    /// Mints new tokens to a specified address; restricted to the protocol
    function mint(address minter, uint256 amountToMint) public onlyProtocol {
        _mint(minter, amountToMint);
        T_totalSupply = T_totalSupply + amountToMint;
    }

    /// Burns tokens from the caller's balance; restricted to the protocol
    function burn(uint256 amountToBurn) public onlyProtocol {
        _burn(msg.sender, amountToBurn);
        T_totalSupply = T_totalSupply - amountToBurn;
    }

    /// Overrides default decimals to return 6 (standard for stablecoins)
    function decimals() public view override returns (uint8) {
        return 6;
    }

    /// Returns the custom token name
    function name() public view override returns (string memory) {
        return T_name;
    }

    /// Returns the custom token symbol
    function symbol() public view override returns (string memory) {
        return T_symbol;
    }
}
