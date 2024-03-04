
# NIN Token Project

The NIN Token Project is a Solidity-based smart contract for creating a TRC20-compatible token on the Avalanche blockchain. This project includes features such as token transfer, wallet freezing for a specified period, and ownership management.

## Features

- **TRC20 Token Implementation**: A fully compatible TRC20 token with standard token functionalities.
- **Ownership Management**: Only the contract owner can perform certain administrative tasks such as freezing wallets and transferring ownership.
- **Wallet Freezing**: Ability to freeze and unfreeze wallets, preventing transfers from frozen wallets.
- **Time-based Token Locking**: Tokens in specified wallets can be locked for a period, making them non-transferable until the lock expires.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Node.js](https://nodejs.org/) (version 12 or higher)
- [Truffle Suite](https://www.trufflesuite.com/truffle)
- An Avalanche wallet with AVAX for deploying contracts

### Installing

1. **Clone the repository**

```bash
   git clone https://github.com/Drehalas/avax-token-project.git
   cd nin-token-project
```

1. **Install dependencies**
```bash
  npm install
```

2. **Compile the contracts**
```bash
  truffle compile
```

2. **Deploy the contracts**
- First, ensure you have set up your truffle-config.js with your Avalanche network details. Then run:
```bash
  truffle migrate --network avalanche
```

2. **Running Tests**
- To run the predefined tests, use:
```bash
  truffle test
```

### Usage
After deploying your contracts, interact with them through Truffle's console or by integrating them into a frontend application using @truffle/contract or similar libraries.

### Contributing
Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us.

### License
- This project is licensed under the MIT License - see the LICENSE.md file for details

### Acknowledgments
- Avalanche Network for the blockchain platform.
- OpenZeppelin for secure smart contract libraries.
