// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FractionalToken is ERC20, Ownable {
    // Events
    event FractionMinted(address indexed to, uint256 amount);
    event FractionBurned(address indexed from, uint256 amount);

    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply, 
        address owner
    ) ERC20(name, symbol) Ownable(owner) {
        // Owner is already set by Ownable(owner) - no need for transferOwnership
        _mint(owner, initialSupply);
    }

    function mintFraction(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Amount must be > 0");
        _mint(to, amount);
        emit FractionMinted(to, amount);
    }

    function burnFraction(address from, uint256 amount) external onlyOwner {
        require(from != address(0), "Cannot burn from zero address");
        require(amount > 0, "Amount must be > 0");
        require(balanceOf(from) >= amount, "Insufficient balance to burn");
        _burn(from, amount);
        emit FractionBurned(from, amount);
    }

    // Optional: Allow token holders to burn their own tokens
    function burn(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        _burn(msg.sender, amount);
        emit FractionBurned(msg.sender, amount);
    }

    // View function to get token info - FIXED NAMING CONFLICT
    function getTokenInfo() external view returns (
        string memory tokenName,
        string memory tokenSymbol,
        uint256 tokenTotalSupply, 
        uint8 tokenDecimals,       
        address tokenOwner
    ) {
        return (name(), symbol(), totalSupply(), decimals(), owner());
    }
}