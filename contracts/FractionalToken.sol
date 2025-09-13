// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FractionalToken is ERC20, Ownable {
    // Events
    event FractionMinted(address to, uint256 amount);
    event FractionBurned(address from, uint256 amount);

    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply, 
        address owner
    ) ERC20(name, symbol) Ownable(owner) {
        _mint(owner, initialSupply);
        transferOwnership(owner);
    }

    function mintFraction(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit FractionMinted(to, amount);
    }

    function burnFraction(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
        emit FractionBurned(from, amount);
    }
}
