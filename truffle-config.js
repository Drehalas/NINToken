const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const path = require('path');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*", // Match any network id
        },
        testnet: {
            provider: () => new HDWalletProvider(mnemonic, `https://api.avax-test.network/ext/bc/C/rpc`),
            network_id: 43113, // Avalanche Fuji Testnet ID
            gas: 5500000,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true
        },
        mainnet: {
            provider: () => new HDWalletProvider(mnemonic, `https://api.avax.network/ext/bc/C/rpc`),
            network_id: 43114, // Avalanche Mainnet ID
            gas: 5500000,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true
        }
    },

    // Set default mocha options here, use special reporters etc.
    mocha: {
        // timeout: 100000
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.8.0", // Fetch exact version from solc-bin (default: truffle's version)
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                },
            }
        }
    },

    // Truffle DB is currently disabled by default; to enable it, set enabled: true
    db: {
        enabled: false
    }
};