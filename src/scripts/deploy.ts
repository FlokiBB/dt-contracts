// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // NepoleiaNFT Deployment
  const NepoleiaNFT = await ethers.getContractFactory("NepoleiaNFT");
  const nepoleiaNFT = await NepoleiaNFT.deploy();

  await nepoleiaNFT.deployed();

  console.log("Greeter deployed to:", nepoleiaNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
