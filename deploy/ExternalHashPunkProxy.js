module.exports = async ({
    getNamedAccounts,
    deployments,
  }) => {
    let networkName;
    const HashPunk_CONTRACT = "HashPunk";
    const {deploy} = deployments;
    const {deployer,admin} = await getNamedAccounts();
    logic = await deployments.get(HashPunk_CONTRACT)

    await deploy('ExternalHashPunkProxy', {
      from: deployer,
      args: [logic.address,admin,"0x"],
      log: true,
      waitConfirmations:1,
    });
  };

  module.exports.tags = ["EXTERNAL_HashPunk"];