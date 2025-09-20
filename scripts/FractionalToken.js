const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  // Replace this with the deployed RWANFT address
  const nftAddress = "0x5Ada6672E193a1E88226EE2948351d4d2a2ef410";

  const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy(nftAddress);
  await marketplace.deployed();

  console.log("Marketplace deployed at:", marketplace.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
