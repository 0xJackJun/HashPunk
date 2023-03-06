module.exports = async ({
    getNamedAccounts,
    deployments,
  }) => {
    let networkName;
    const HValue_CONTRACT = "HValue";
    const {deploy} = deployments;
    const {deployer,admin} = await getNamedAccounts();
    logic = await deployments.get(HValue_CONTRACT)

    await deploy('EternalHValueProxy', {
      from: deployer,
      args: [logic.address,admin,"0x"],
      log: true,
      waitConfirmations:1,
    });
  };

  module.exports.tags = ["EXTERNAL_HValue"];