// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./RWANFT.sol";
import "./FractionalToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Marketplace is Ownable, ReentrancyGuard {
    struct NFTListing {
        address seller;
        uint256 price; // in wei
        bool active;
    }

    struct FractionalListing {
        address seller;
        uint256 pricePerToken; // in wei
        address fractionalToken;
        uint256 amount;
        bool active;
    }

    mapping(uint256 => NFTListing) public nftListings;
    mapping(uint256 => FractionalListing) public fractionalListings;

    // Events
    event NFTListed(uint256 indexed tokenId, uint256 price, address indexed seller);
    event FractionalListed(uint256 indexed tokenId, address indexed fractionalToken, uint256 amount, uint256 pricePerToken, address indexed seller);
    event NFTSold(uint256 indexed tokenId, uint256 price, address indexed buyer, address indexed seller);
    event FractionalSold(uint256 indexed tokenId, uint256 amount, uint256 totalPrice, address indexed buyer, address indexed seller);
    event NFTListingCancelled(uint256 indexed tokenId, address indexed seller);
    event FractionalListingCancelled(uint256 indexed tokenId, address indexed seller);

    RWANFT public nftContract;
    uint256 public platformFee = 250; // 2.5% in basis points
    address public feeRecipient;

    constructor(address _nftContract) Ownable(msg.sender) {
        nftContract = RWANFT(_nftContract);
        feeRecipient = msg.sender;
    }

    // List NFT for sale
    function listNFT(uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be > 0");
        address owner = nftContract.ownerOf(tokenId);
        require(msg.sender == owner, "Not NFT owner");
        require(!nftListings[tokenId].active, "NFT already listed");
        
        // Check if marketplace is approved to transfer NFT
        require(nftContract.getApproved(tokenId) == address(this) || 
                nftContract.isApprovedForAll(owner, address(this)), 
                "Marketplace not approved to transfer NFT");

        nftListings[tokenId] = NFTListing({
            seller: msg.sender,
            price: price,
            active: true
        });

        emit NFTListed(tokenId, price, msg.sender);
    }

    // List fractional tokens for sale
    function listFraction(uint256 tokenId, address fractionalToken, uint256 amount, uint256 pricePerToken) external {
        require(amount > 0 && pricePerToken > 0, "Amount & price must be > 0");
        require(!fractionalListings[tokenId].active, "Fractional tokens already listed for this NFT");

        FractionalToken ft = FractionalToken(fractionalToken);
        require(ft.balanceOf(msg.sender) >= amount, "Insufficient fractional tokens");
        require(ft.allowance(msg.sender, address(this)) >= amount, "Insufficient fractional token allowance");

        fractionalListings[tokenId] = FractionalListing({
            seller: msg.sender,
            pricePerToken: pricePerToken,
            fractionalToken: fractionalToken,
            amount: amount,
            active: true
        });

        emit FractionalListed(tokenId, fractionalToken, amount, pricePerToken, msg.sender);
    }

    // Buy full NFT
    function buyNFT(uint256 tokenId) external payable nonReentrant {
        NFTListing storage listing = nftListings[tokenId];
        require(listing.active, "NFT not listed");
        require(msg.value >= listing.price, "Insufficient ETH");

        address seller = listing.seller;
        uint256 price = listing.price;

        // Calculate platform fee
        uint256 fee = (price * platformFee) / 10000;
        uint256 sellerAmount = price - fee;

        // Mark as inactive before transfers
        listing.active = false;

        // Transfer NFT to buyer
        nftContract.safeTransferFrom(seller, msg.sender, tokenId);

        // Transfer payments
        if (fee > 0) {
            payable(feeRecipient).transfer(fee);
        }
        payable(seller).transfer(sellerAmount);

        // Refund excess ETH
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }

        emit NFTSold(tokenId, price, msg.sender, seller);
    }

    // Buy fractional tokens
    function buyFraction(uint256 tokenId, uint256 amount) external payable nonReentrant {
        FractionalListing storage listing = fractionalListings[tokenId];
        require(listing.active, "Fractional tokens not listed");
        require(amount <= listing.amount, "Not enough fractional tokens available");

        uint256 totalPrice = amount * listing.pricePerToken;
        require(msg.value >= totalPrice, "Insufficient ETH");

        address seller = listing.seller;

        // Calculate platform fee
        uint256 fee = (totalPrice * platformFee) / 10000;
        uint256 sellerAmount = totalPrice - fee;

        // Update listing
        listing.amount -= amount;
        if (listing.amount == 0) {
            listing.active = false;
        }

        // Transfer fractional tokens
        FractionalToken ft = FractionalToken(listing.fractionalToken);
        ft.transferFrom(seller, msg.sender, amount);

        // Transfer payments
        if (fee > 0) {
            payable(feeRecipient).transfer(fee);
        }
        payable(seller).transfer(sellerAmount);

        // Refund excess ETH
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }

        emit FractionalSold(tokenId, amount, totalPrice, msg.sender, seller);
    }

    // Cancel NFT listing
    function cancelNFTListing(uint256 tokenId) external {
        NFTListing storage listing = nftListings[tokenId];
        require(listing.active, "NFT not listed");
        require(listing.seller == msg.sender, "Not seller");
        
        listing.active = false;
        emit NFTListingCancelled(tokenId, msg.sender);
    }

    // Cancel fractional listing
    function cancelFractionalListing(uint256 tokenId) external {
        FractionalListing storage listing = fractionalListings[tokenId];
        require(listing.active, "Fractional tokens not listed");
        require(listing.seller == msg.sender, "Not seller");
        
        listing.active = false;
        emit FractionalListingCancelled(tokenId, msg.sender);
    }

    // View NFT listing
    function getNFTListing(uint256 tokenId) external view returns (NFTListing memory) {
        return nftListings[tokenId];
    }

    // View fractional listing
    function getFractionalListing(uint256 tokenId) external view returns (FractionalListing memory) {
        return fractionalListings[tokenId];
    }

    // Admin functions
    function setPlatformFee(uint256 _platformFee) external onlyOwner {
        require(_platformFee <= 1000, "Fee too high"); // Max 10%
        platformFee = _platformFee;
    }

    function setFeeRecipient(address _feeRecipient) external onlyOwner {
        require(_feeRecipient != address(0), "Invalid address");
        feeRecipient = _feeRecipient;
    }

    // Emergency withdraw (only if no active listings)
    function emergencyWithdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}