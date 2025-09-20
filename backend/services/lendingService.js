const { ethers } = require("ethers");
const RWALendingABI = require("../abi/RWALending.json");

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const lendingContract = new ethers.Contract(
  process.env.LENDING_ADDRESS,
  RWALendingABI,
  wallet
);

module.exports = {
  async depositNFTForLoan(tokenId, loanAmount) {
    const tx = await lendingContract.depositNFTForLoan(tokenId, loanAmount);
    return await tx.wait();
  },

  async repayLoan(tokenId, repayAmount) {
    const tx = await lendingContract.repayLoan(tokenId, repayAmount);
    return await tx.wait();
  },

  async liquidate(tokenId) {
    const tx = await lendingContract.liquidate(tokenId);
    return await tx.wait();
  },

  async viewLoan(tokenId) {
    return await lendingContract.viewLoan(tokenId);
  },

  async fundContract(amount) {
    const tx = await lendingContract.fundContract(amount);
    return await tx.wait();
  },

  async withdrawUSDC(amount) {
    const tx = await lendingContract.withdrawUSDC(amount);
    return await tx.wait();
  },
};
