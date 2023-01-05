// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const HValue = await hre.ethers.getContractFactory("HValue");
  const hValue = await HValue.deploy("");

  await hValue.deployed();

  console.log(
    `hValue deployed to ${hValue.address}`
  );

  const HashPunk = await hre.ethers.getContractFactory("HashPunk");
  const hashPunk = await HashPunk.deploy("", hValue.address, 50, 5);
  await hashPunk.deployed();
  console.log(`HashPunk deployed to ${hashPunk.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
