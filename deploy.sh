#!/bin/sh

npx hardhat deploy --network goerli --tags HValue
npx hardhat deploy --network goerli --tags EXTERNAL_HValue
npx hardhat deploy --network goerli --tags HashPunk
npx hardhat deploy --network goerli --tags EXTERNAL_HashPunk