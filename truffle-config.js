const path = require("path");
require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      port: 7545
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(`${process.env.MNEMONIC}`, `https://rinkeby.infura.io/v3/4c2aef8f0b8d4b19b85e3bef915da9ba`)
      },
      network_id: 4,
      from: "0xEe65245403761b44CCAeF4391bA4b830ADEa578f"
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(`${process.env.MNEMONIC}`, `https://ropsten.infura.io/v3/4c2aef8f0b8d4b19b85e3bef915da9ba`)
      },
      network_id: 3
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(`${process.env.MNEMONIC}`, `https://kovan.infura.io/v3/4c2aef8f0b8d4b19b85e3bef915da9ba`)
      },
      network_id: 42
    }
  },
  
  // Ajouter cette partie (ou décommenter directement dans le fichier):
  compilers: {
    solc: {
      version: "0.8.7", // Récupérer la version exacte de solc-bin (par défaut : la  version de truffle)
      settings: {  // Voir les documents de solidity pour des conseils sur l'optimisation et l'evmVersion
        optimizer: {
        enabled: false,
        runs: 200
        },
      }
    },
  },
};
