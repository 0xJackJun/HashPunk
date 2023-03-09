const { ethers } = require("hardhat");
const hre = require("hardhat");
async function main() {
    proxy = await deployments.get("ExternalHashPunkProxy")
    console.log("proxy address",proxy.address)
    logic = await deployments.get("HashPunk")
    console.log("logic address",logic.address)
    const abi = [
        {
          "inputs": [
            {
              "internalType": "address",
              "name": "_logic",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "admin_",
              "type": "address"
            },
            {
              "internalType": "bytes",
              "name": "_data",
              "type": "bytes"
            }
          ],
          "stateMutability": "payable",
          "type": "constructor"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": false,
              "internalType": "address",
              "name": "previousAdmin",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "address",
              "name": "newAdmin",
              "type": "address"
            }
          ],
          "name": "AdminChanged",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "beacon",
              "type": "address"
            }
          ],
          "name": "BeaconUpgraded",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "implementation",
              "type": "address"
            }
          ],
          "name": "Upgraded",
          "type": "event"
        },
        {
          "stateMutability": "payable",
          "type": "fallback"
        },
        {
          "inputs": [],
          "name": "admin",
          "outputs": [
            {
              "internalType": "address",
              "name": "admin_",
              "type": "address"
            }
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "address",
              "name": "newAdmin",
              "type": "address"
            }
          ],
          "name": "changeAdmin",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "implementation",
          "outputs": [
            {
              "internalType": "address",
              "name": "implementation_",
              "type": "address"
            }
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "address",
              "name": "newImplementation",
              "type": "address"
            }
          ],
          "name": "upgradeTo",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "address",
              "name": "newImplementation",
              "type": "address"
            },
            {
              "internalType": "bytes",
              "name": "data",
              "type": "bytes"
            }
          ],
          "name": "upgradeToAndCall",
          "outputs": [],
          "stateMutability": "payable",
          "type": "function"
        },
        {
          "stateMutability": "payable",
          "type": "receive"
        }
      ];
    const HDNode = ethers.utils.HDNode.fromMnemonic(process.env.admin);
    const pri = HDNode.derivePath(`m/44'/60'/0'/0/0`).privateKey;
    const provider = new ethers.providers.JsonRpcProvider(hre.network.config.url)
    const wallet = new ethers.Wallet(pri,provider)
    const did = new ethers.Contract(proxy.address, abi, wallet);
    const tx = await did.upgradeTo(logic.address, { gasLimit: 1 * 10 ** 6 })
    const receipt = await tx.wait()
    if (receipt && receipt.status == 1) {
        console.log(hre.network.name, "upgrade success")
    } else {
        console.log(receipt)
        console.log(hre.network.name, "upgrade failed")
    }
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});