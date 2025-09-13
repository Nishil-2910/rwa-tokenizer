// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RWANFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => address) public fractionalTokens;

    // Events
    event AssetMinted(uint256 tokenId, address owner);
    event AssetBurned(uint256 tokenId);

    constructor() ERC721("RWA NFT", "RWA") Ownable(msg.sender) {}

    // Mint NFT for an asset
    function mintAsset(address to, string memory metadataURI) external onlyOwner returns (uint256) {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, metadataURI);
        nextTokenId++;
        emit AssetMinted(tokenId, to);
        return tokenId;
    }

    // Burn NFT when asset is removed
    function burnAsset(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
        delete fractionalTokens[tokenId];
        emit AssetBurned(tokenId);
    }

    // Link fractional ERC20 token to NFT
    function setFractionalToken(uint256 tokenId, address fractionalToken) external onlyOwner {
        fractionalTokens[tokenId] = fractionalToken;
    }

    // Get NFT details
    function getAssetDetails(uint256 tokenId) external view returns (string memory, address) {
        return (tokenURI(tokenId), fractionalTokens[tokenId]);
    }
}
