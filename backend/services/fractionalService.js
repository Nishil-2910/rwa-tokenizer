const { ethers } = require("ethers");
const FractionalTokenABI = require("../abi/FractionalToken.json");

const provider = new ethers.JsonRpcProvider(process.env.AVALANCHE_RPC);
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const fractionalTokenAddress = process.env.FRACTIONAL_TOKEN_ADDRESS;

const fractionalContract = new ethers.Contract(
    fractionalTokenAddress,
    FractionalTokenABI,
    signer
);

// Mint fractional tokens
exports.mintFraction = async (to, amount) => {
    const tx = await fractionalContract.mintFraction(to, ethers.parseUnits(amount.toString(), 18));
    await tx.wait();
    return tx;
};

// Burn fractional tokens (owner)
exports.burnFraction = async (from, amount) => {
    const tx = await fractionalContract.burnFraction(from, ethers.parseUnits(amount.toString(), 18));
    await tx.wait();
    return tx;
};

// Burn own tokens
exports.burnOwnTokens = async (amount) => {
    const tx = await fractionalContract.burn(ethers.parseUnits(amount.toString(), 18));
    await tx.wait();
    return tx;
};

// Get token info
exports.getTokenInfo = async () => {
    const [name, symbol, totalSupply, decimals, owner] = await fractionalContract.getTokenInfo();
    return { name, symbol, totalSupply: totalSupply.toString(), decimals, owner };
};
