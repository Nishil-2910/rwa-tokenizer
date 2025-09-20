// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./RWANFT.sol";
import "./FractionalToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is Ownable, ReentrancyGuard {
    struct Listing {
        address seller;
        uint256 price; // in wei
        bool isFractional;
        address fractionalToken; // fractional token address if fractional
        uint256 fractionAmount; // amount of fractional tokens
    }

    mapping(uint256 => Listing) public listings;

    // Events
    event AssetListed(uint256 tokenId, uint256 price, address seller, bool isFractional);
    event AssetSold(uint256 tokenId, uint256 price, address buyer, bool isFractional);
    event ListingCancelled(uint256 tokenId, address seller);

    RWANFT public nftContract;

    constructor(address _nftContract) Ownable() {
        nftContract = RWANFT(_nftContract);
    }

    // List NFT for sale
    function listNFT(uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be > 0");
        address owner = nftContract.ownerOf(tokenId);
        require(msg.sender == owner, "Not NFT owner");

        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            isFractional: false,
            fractionalToken: address(0),
            fractionAmount: 0
        });

        emit AssetListed(tokenId, price, msg.sender, false);
    }

    // List fractional NFT for sale
    function listFraction(uint256 tokenId, address fractionalToken, uint256 amount, uint256 pricePerToken) external {
        require(amount > 0 && pricePerToken > 0, "Amount & price must be > 0");

        FractionalToken ft = FractionalToken(fractionalToken);
        require(ft.balanceOf(msg.sender) >= amount, "Insufficient fractional tokens");

        listings[tokenId] = Listing({
            seller: msg.sender,
            price: pricePerToken,
            isFractional: true,
            fractionalToken: fractionalToken,
            fractionAmount: amount
        });

        emit AssetListed(tokenId, pricePerToken, msg.sender, true);
    }

    // Buy full NFT
    function buyNFT(uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[tokenId];
        require(!listing.isFractional, "Not a full NFT listing");
        require(listing.price > 0, "Not listed");
        require(msg.value >= listing.price, "Insufficient ETH");

        // Transfer ETH
        payable(listing.seller).transfer(listing.price);

        // Transfer NFT
        nftContract.transferFrom(listing.seller, msg.sender, tokenId);

        delete listings[tokenId];
        emit AssetSold(tokenId, listing.price, msg.sender, false);
    }

    // Buy fractional NFT
    function buyFraction(uint256 tokenId, uint256 amount) external payable nonReentrant {
        Listing storage listing = listings[tokenId];
        require(listing.isFractional, "Not a fractional listing");
        require(amount <= listing.fractionAmount, "Not enough fraction available");
        uint256 totalPrice = amount * listing.price;
        require(msg.value >= totalPrice, "Insufficient ETH");

        FractionalToken ft = FractionalToken(listing.fractionalToken);
        ft.transferFrom(listing.seller, msg.sender, amount);

        // Transfer ETH
        payable(listing.seller).transfer(totalPrice);

        listing.fractionAmount -= amount;
        if (listing.fractionAmount == 0) {
            delete listings[tokenId];
        }

        emit AssetSold(tokenId, totalPrice, msg.sender, true);
    }

    // Cancel listing
    function cancelListing(uint256 tokenId) external {
        Listing memory listing = listings[tokenId];
        require(listing.seller == msg.sender, "Not seller");
        delete listings[tokenId];

        emit ListingCancelled(tokenId, msg.sender);
    }

    // View listing
    function getListing(uint256 tokenId) external view returns (Listing memory) {
        return listings[tokenId];
    }
}
