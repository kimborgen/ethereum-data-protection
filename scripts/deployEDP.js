// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  
  const rfd = await hre.ethers.deployContract("RequestsForDeletion");
  await rfd.waitForDeployment();

  console.log(
    `RFD deployed to ${rfd.target}`
  );

  let maxSeats = 10;
    const edp = await hre.ethers.deployContract("EthereumDataProtection", [10, rfd.target]);
    await edp.waitForDeployment()
    console.log(`EDP deployed to ${edp.target} with ${maxSeats} maxSeats`)

    // change ownership

    await rfd.transferOwnership(edp.target)
    console.log("Changed RFD contract ownership to EDP")


}

  

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});