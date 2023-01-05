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
      url: "https://goerli.infura.io/v3/34c589330dc4487aad79d68d75d780c9",
      accounts: { mnemonic: process.env.mnemonic },
      allowUnlimitedContractSize: true,
      gas: 2100000
    },
    platon_dev: {
        url: "https://devnet2openapi.platon.network/rpc",
        accounts: [process.env.platon_pri],
        gas: 2100000,
        gasPrice: 8000000000
    },
    platon_qa: {
        url: "https://devnet2openapi.platon.network/rpc",
        accounts: [process.env.platon_pri],
        gas: 2100000,
        gasPrice: 8000000000
    },
    platon_stg: {
        url: "https://devnet2openapi.platon.network/rpc",
        accounts: [process.env.platon_pri],
        gas: 2100000,
        gasPrice: 8000000000
    },
    baobab_qa: {
      url : "https://api.baobab.klaytn.net:8651",
      accounts: [process.env.baobab_pri],
      gas: 2100000,
      gasPrice: 50000000000,
    },
    baobab_stg: {
      url : "https://api.baobab.klaytn.net:8651",
      accounts: [process.env.baobab_pri],
      gas: 2100000,
      gasPrice: 50000000000,
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
  mocha: {
    timeout: 40000
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    admin: {
      default:"0xb734178FF124957aB4933AC750C0dBf455A08cbC",
    }
  },
};
