// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {

    string public P_name;
    string public P_symbol;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        P_name = _name;
        P_symbol = _symbol;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount); // creates new tokens and adds them to the balance
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount); // destroys tokens and removes them from the balance
    }

    function decimals() public view virtual override returns (uint8) {
        return 18; // altcoins
    }

    // function decimals() public view virtual override returns (uint8) {
    //     return 6; // stablecoins
    // }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        uint256 currentAllowance = allowance(from, _msgSender());

        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );

        unchecked {
            _approve(
                from,
                _msgSender(),
                currentAllowance - amount
            );
        }

        _transfer(from, to, amount);
        return true;
    }

    function withdraw(address to, uint256 amount) public {
        _transfer(_msgSender(), to, amount);
    }
}