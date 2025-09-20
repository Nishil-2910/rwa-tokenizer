// scripts/deployFractionalToken.js
const hre = require("hardhat");

async function main() {
  // Replace these values as needed
  const NAME = "Fractional RWA Token";
  const SYMBOL = "FRWA";
  const INITIAL_SUPPLY = hre.ethers.utils.parseUnits("1000000", 18); // 1,000,000 tokens
  const OWNER = "0x128276A302DbAfbF51B112D8043Eee92FFa89be1"; // Replace with deployer or intended owner

  const FractionalToken = await hre.ethers.getContractFactory("FractionalToken");
  const token = await FractionalToken.deploy(NAME, SYMBOL, INITIAL_SUPPLY, OWNER);

  await token.deployed();

  console.log("FractionalToken deployed to:", token.address);
  console.log("Owner:", OWNER);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
