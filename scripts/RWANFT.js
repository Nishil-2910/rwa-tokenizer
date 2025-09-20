const hre = require("hardhat");

async function main() {
  const RWA = await hre.ethers.getContractFactory("RWANFT");
  const rwa = await RWA.deploy();

  await rwa.deployed();
  console.log("RWANFT deployed to:", rwa.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
