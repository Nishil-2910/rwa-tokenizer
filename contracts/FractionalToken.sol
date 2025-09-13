// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FractionalToken is ERC20, Ownable {
    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply, 
        address owner
    ) ERC20(name, symbol) Ownable(owner) {
        // Mint initial supply to owner
        _mint(owner, initialSupply);
    }

    // Mint more tokens (only owner)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Burn tokens (only owner)
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
