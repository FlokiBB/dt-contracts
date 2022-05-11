import { ethers, upgrades } from "hardhat";

async function main() {
  const DAOTreasury = await ethers.getContractFactory("DAOTreasury");
  const daoTreasury = await upgrades.deployProxy(DAOTreasury, [42]); // initializer should be added in this line
  await daoTreasury.deployed();
  console.log("Box deployed to:", daoTreasury.address);
}

main();