// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./RWANFT.sol";
import "./FractionalToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is Ownable {
    struct Listing {
        address seller;
        uint256 price; // in wei
        bool isFractional;
        address fractionalToken; // if fractional
        uint256 fractionAmount; // if fractional
    }

    mapping(uint256 => Listing) public listings;

    // Events
    event AssetListed(uint256 tokenId, uint256 price, address seller);
    event AssetSold(uint256 tokenId, uint256 price, address buyer);
    event ListingCancelled(uint256 tokenId, address seller);

    RWANFT public nftContract;

    constructor(address _nftContract) Ownable(msg.sender) {
        nftContract = RWANFT(_nftContract);
    }

    // List NFT or fraction for sale
    function listForSale(uint256 tokenId, uint256 price) external {
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

        emit AssetListed(tokenId, price, msg.sender);
    }

    // Buy NFT
    function buyAsset(uint256 tokenId) external payable {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "Not listed");
        require(msg.value >= listing.price, "Insufficient ETH");

        // Transfer ETH to seller
        payable(listing.seller).transfer(listing.price);

        // Transfer NFT to buyer
        nftContract.transferFrom(listing.seller, msg.sender, tokenId);

        delete listings[tokenId];

        emit AssetSold(tokenId, listing.price, msg.sender);
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
