require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
// set proxy
const { ProxyAgent, setGlobalDispatcher } = require("undici");
const proxyAgent = new ProxyAgent('http://localhost:33210'); // change to yours
setGlobalDispatcher(proxyAgent);

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
  },
  networks: {
    goerli: {
      url: process.env.URL,
      accounts: { mnemonic: process.env.mnemonic },
      allowUnlimitedContractSize: true,
      gas: 2100000
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  etherscan: {
    apiKey: {
      goerli: process.env.etherscan_api_key,
      rinkeby: process.env.etherscan_api_key,
    }
  },
};
