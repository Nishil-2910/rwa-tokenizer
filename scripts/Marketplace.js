const hre = require("hardhat");
require("dotenv").config();

async function main() {
const nftAddress = "0x5Ada6672E193a1E88226EE2948351d4d2a2ef410"; // RWANFT deployed address

  const Market = await hre.ethers.getContractFactory("Marketplace");
  const market = await Market.deploy(nftAddress);

  await market.deployed();
  console.log("Marketplace deployed to:", market.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
