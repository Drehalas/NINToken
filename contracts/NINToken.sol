// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NinToken
 * @dev Implementation of the NinToken
 */
contract NinToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("NinToken", "NIN") {
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     * Only the contract owner can call this function.
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Function to burn tokens
     * @param from The address from which to burn tokens.
     * @param amount The amount of tokens to burn.
     * Only the contract owner can call this function.
     */
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}