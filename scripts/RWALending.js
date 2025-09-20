const hre = require("hardhat");
require("dotenv").config();

async function main() {
const nftAddress = "0x5Ada6672E193a1E88226EE2948351d4d2a2ef410"; // RWANFT deployed address
const usdcAddress = "0x5425890298aed601595a70AB815c96711a31Bc65"; // test USDC on Fuji

  const Lending = await hre.ethers.getContractFactory("RWALending");
  const lending = await Lending.deploy(nftAddress, usdcAddress);

  await lending.deployed();
  console.log("RWALending deployed to:", lending.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
