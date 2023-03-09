require('dotenv').config();
module.exports = async function (taskArgs, hre) {
    const proxy = await ethers.getContract("ExternalHValueProxy");
    const DidIssuerImpl = await ethers.getContract("HValue");
    const contract = await DidIssuerImpl.attach(proxy.address)
    console.log(`[source] contract.address: ${contract.address}`);
    // the network name is abc_def, we need to get the last part
    try {
        const {deployer} = await getNamedAccounts();
        console.log("owner:",deployer)
        let tx_init = await contract.initialize("For test");
        let init_receipt = await tx_init.wait();
        console.log("init_receipt:",init_receipt)
    } catch (e) {
        console.log(e);
      }
  };