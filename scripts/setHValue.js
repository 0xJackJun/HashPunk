const { ethers } = require("hardhat");

async function main() {
    const {deployer} = await getNamedAccounts();
    const proxy = await ethers.getContract("ExternalHValueProxy");
    const did = await ethers.getContract("HValue");
    const contract = await did.attach(proxy.address);

    //mint DID
    // const tx = await contract.mint(deployer, "jack.key", "avatar");
    // await tx.wait();
    // console.log(await contract.owner());
    const tx = await contract.setController("0x3CB49528D7f141a329f0e259B5f6AE35f6cA70b7");
    const receipt = await tx.wait();
    console.log(receipt);
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});