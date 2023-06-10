// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const contract = await hre.ethers.getContractAt("EthereumDataProtection", "0x84eA74d481Ee0A5332c457a4d796187F6Ba67fEB");
  //const contract = await EDP.attach()
  console.log("Address: ", contract.target)

  let members = await hre.ethers.getSigners() 
  members = members.slice(0,9)
  console.log("members ", members)

  for (const member of members) {
    let tx = await contract.addSeat(member.address)
    const receipt = await tx.wait(5)
    console.log(receipt.logs)
  }
}

  

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});