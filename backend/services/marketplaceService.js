const { ethers } = require("ethers");
const MarketplaceABI = require("../abi/Marketplace.json");

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const marketplaceContract = new ethers.Contract(
  process.env.MARKETPLACE_ADDRESS,
  MarketplaceABI,
  wallet
);

module.exports = {
  async listNFT(tokenId, price) {
    const tx = await marketplaceContract.listNFT(tokenId, price);
    return await tx.wait();
  },

  async listFraction(tokenId, fractionalToken, amount, pricePerToken) {
    const tx = await marketplaceContract.listFraction(
      tokenId,
      fractionalToken,
      amount,
      pricePerToken
    );
    return await tx.wait();
  },

  async buyNFT(tokenId, value) {
    const tx = await marketplaceContract.buyNFT(tokenId, { value });
    return await tx.wait();
  },

  async buyFraction(tokenId, amount, value) {
    const tx = await marketplaceContract.buyFraction(tokenId, amount, { value });
    return await tx.wait();
  },

  async cancelNFTListing(tokenId) {
    const tx = await marketplaceContract.cancelNFTListing(tokenId);
    return await tx.wait();
  },

  async cancelFractionalListing(tokenId) {
    const tx = await marketplaceContract.cancelFractionalListing(tokenId);
    return await tx.wait();
  },

  async getNFTListing(tokenId) {
    return await marketplaceContract.getNFTListing(tokenId);
  },

  async getFractionalListing(tokenId) {
    return await marketplaceContract.getFractionalListing(tokenId);
  },
};
