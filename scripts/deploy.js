const {ethers} = require("hardhat");


const main = async() => {

const  tokenContract =  await ethers.getContractFactory("SecureEstate");
const tokenDeployedContract = await tokenContract.deploy();

await tokenDeployedContract.waitForDeployment();

console.log("Token Contract deployed to", tokenDeployedContract.target);


const  rsContract =  await ethers.getContractFactory("RealTok");
const rsDeployedContract = await rsContract.deploy(tokenDeployedContract.target);

await rsDeployedContract.waitForDeployment();

console.log("RS Contract deployed to", rsDeployedContract.target);

}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });