// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RWANFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => address) public fractionalTokens;

    constructor() ERC721("RWA NFT", "RWA") Ownable(msg.sender){}

    function mintAsset(address to, string memory metadataURI) external onlyOwner returns (uint256) {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, metadataURI);
        nextTokenId++;
        return tokenId;
    }

    function setFractionalToken(uint256 tokenId, address fractionalToken) external onlyOwner {
        fractionalTokens[tokenId] = fractionalToken;
    }

    function getAssetDetails(uint256 tokenId) external view returns (string memory, address) {
        return (tokenURI(tokenId), fractionalTokens[tokenId]);
    }
}
