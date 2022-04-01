require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: `${process.env.ALCHEMY_RINKEBY_URL}`,
      accounts: [`0x${process.env.RINKEBY_PRIVATE_KEY}`],
    }
  },
  etherscan: {
    apiKey: `${process.env.ETHERSCAN_KEY}`
  }
};