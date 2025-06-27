# Chainlink Local – Develop & Test Chainlink Services Locally

## Overview

**Chainlink Local** is a local development toolkit that enables you to run and test Chainlink services directly on your machine, before moving to testnet or mainnet. It integrates smoothly with tools like **Foundry**, **Hardhat**, and **Remix**, offering a fast feedback loop for development.


## What is Chainlink Local?

Chainlink Local is a package that provides a local environment to simulate Chainlink services. You can use it to:

* Run Chainlink services such as **CCIP**, **VRF**, etc., without needing external testnet infrastructure.
* Develop and debug smart contracts using mock or forked Chainlink setups.

🔗 Supports integration with:

* [Foundry](https://getfoundry.sh/)
* [Hardhat](https://hardhat.org/)
* [Remix](https://remix.ethereum.org/)


## Key Features

* **Local Simulation**
  Simulate Chainlink services using local blockchain nodes (like Anvil or Hardhat).

* **Forked Networks**
  Use forked mainnet/testnet states to interact with real deployed Chainlink contracts.

* **Seamless Environment Support**
  Works out-of-the-box with Foundry, Hardhat, and Remix (limited fork support).

* **Production-Ready Testing**
  Contracts tested locally can be deployed to testnets with minimal to no changes.


## Development Modes

Chainlink Local provides two development/testing workflows:

### 1. Local Testing **Without Forking**

* Uses mock contracts.
* Deploy Chainlink mocks and your own contracts to a blank local blockchain (e.g., Anvil, Hardhat node, Remix VM).
* Useful for:

  * Early development
  * Unit tests
  * No reliance on live network data

### 2. Local Testing **With Forking**

* Forks a live blockchain (e.g., Ethereum mainnet, Polygon) using Hardhat or Foundry.
* Access real deployed Chainlink contracts (e.g., CCIP Router, VRF Coordinator).
* Enables realistic testing with actual Chainlink interfaces and token contracts.

Not supported in Remix.

Use cases:

* End-to-end CCIP simulations
* Cross-chain messaging (via multiple forks)
* Realistic contract behavior verification


## Developer Benefits

Using Chainlink Local, you can:

* Simulate **CCIP token transfers and messaging** locally.
* Perform **cross-chain testing** via multiple local forks.
* Rapidly iterate on **Chainlink-integrated contracts** without testnet delays.
* Validate and debug contract logic **in a controlled environment**.

---

# 1. Using Chainlink Local
Using CCIP to send a cross-chain message  
Testing CCIP using Chainlink Local in Remix.   
Sending simple message cross-chain for example `"Hey There!"`  

## The MessageSender and MessageReceiver contracts

1. [`MessageSender`](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/Chainlink_Local/MessageSender.sol): This contract would be deployed to the source chain. It will contain the logic to send the CCIP message, similar to the contract we wrote in Section 5.
2. [`MessageReceiver`](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/Chainlink_Local/MessageReceiver.sol): This contract will receive the cross-chain message. It will inherit the `CCIPReceiver` abstract contract needed to receive CCIP messages. This means it must implement the required `_ccipReceive` function to process the cross-chain message.
3. [`CCIPLocalSimulator.sol`](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/Chainlink_Local/CCIPLocalSimulator.sol): This is a helper contract to use Chainlink Local in Remix. Just imported `CCIPLocalSimulator` contract so we can deploy it locally and use it in our testing.

### Deploying Contracts
#### 1. Deploying CCIPLocalSimulator
1. Deploy this contract on **`Remix VM (Cancun)`** and pin it.
2. In the list of functions, click the `configuration` function to retrieve the configuration details for the pre-deployed contracts and services needed for local CCIP simulations. This data forms that on-chain infra and these values returned by this function will be used throughout for this demo (these are the values and addresses we would have looked up these values in the [Chainlink directory](https://docs.chain.link/ccip/directory/testnet) if we were working on a live blockchain).
3. Copy the **linkToken\_** address.
![image](https://github.com/user-attachments/assets/d8b7b729-e9e7-43d9-ade8-f194555a550e)

#### 2. Deploy the link token  
1. Deploy this contract on **`Remix VM (Cancun)`** and pin it.  
We need to, as before, fund our `Sender` contract with LINK tokens to pay for CCIP. The LINK token contract is pre-deployed in the local simulator configuration, so you can simply load the LINK token contract instance:
\- Back up in the **Contracts** dropdown, select the `LinkToken` contract.
\- Paste the  **linkToken\_** address in the **At Address** box.
\- Click the **At Address** button.  
![image](https://github.com/user-attachments/assets/b2e1ae60-b89a-4771-a0c4-fcb2aec797c2)  
Now, the `LinkToken` contract will show in the **Deployed Contracts** section. We will be able to fund contracts with LINK.  
#### 3. Deploying the MessageSender and MessageReceiver
1. Deploy MessageSender contract on **`Remix VM (Cancun)`** and pin it.
Use the following constructor parameters:

* `_router`: copy and paste the `sourceRouter_` from the `configuration` call on the `CCIPLocalSimulator` contract.
* `_LINK`: copy and paste the LINK token contract address you just deployed.
* Click **transact** to deploy the contract.

2. Deploy MessageReceiver contract on **`Remix VM (Cancun)`** and pin it.  
Use the following constructor parameter:
  * `router`: copy and paste the `destinationRouter_` from the `configuration` call on the `CCIPLocalSimulator` contract.

  * Click **transact** to deploy the contract.

#### Send a cross-chain message using Chainlink Local

Expand the `MessageSender` contract in the **Deployed Contracts** section and expand the `sendMessage` function. Use the following parameters:

* `destinationChainSelector`: copy-paste the `chainSelector_` from the `configuration` call on the `CCIPLocalSimulator` contract.

* `receiver`: copy the address of the `MessageReceiver` contract you just deployed.

**Note**: Remix will fail to estimate the gas properly for the `sendMessage` function.  
![image](https://github.com/user-attachments/assets/0162ca4f-288d-497a-863c-9a0018c81d66)  

To work around this, we need to set the gas limit manually to `3000000` by clicking the radio button at the top of the **Deploy and run transactions** tab:  

![image](https://github.com/user-attachments/assets/53822fe4-87f2-4721-bf23-d603d41f7df3)    
Click **transact** to call the function and test sending the CCIP message.  
To check if the message was received by `MessageReceiver`, call the `getLastReceivedMessageDetails` function. You'll see the message ID and the message we sent using Chainlink Local!    
![image](https://github.com/user-attachments/assets/5a79aeb4-931d-4139-b759-a59d18793a7b)   
And that's it! You have successfully used Chainlink Local in Remix to test sending a cross-chain message with CCIP.  

---
# 2. Use Chainlink CCIP to Interact with Smart Contracts on Other Blockchains

Previously, we learned how to bridge (or cross-chain transfer) tokens using CCIP. But what if, once we receive those tokens on the destination chain, we want to do something with them such as:

* Staking the tokens

* Buying an asset (another token, NFT, etc.)

here, we will learn how to send arbitrary messages cross-chain using Chainlink CCIP _along with_ the tokens. In this message, we will encode an action to perform with the tokens upon transfer.
## What are cross-chain messages?

Cross-chain messages are arbitrary data sent cross-chain as `bytes`. For example:

* A string message, e.g., `"Hey there"`

* An encoded function to call on a target contract on the detination chain, e.g., `abi.encodeWithSelector("mint(uint256)", 25)`.

* A `uint256` representing a balance or exchange rate.

## Architecture and the Vault

Let's create a cross-chain message that:

1. Sends USDC cross-chain from Sepolia to Base Sepolia.
2. Sends data cross-chain with the token. This data will be the encoded function call to deposit the tokens into a vault upon receiving them.

For this, we will need three smart contracts:

1. A `Sender` contract that will

   * Encode a function call

   * Send the cross-chain message
2. A `Receiver` contract that will

   * Receive the tokens.

   * Call the function and contract encoded in the data.
3. A `Vault` contract for the `Receiver` to call to deposit the tokens. In reality, this will probably be some protocol you are interacting with.

### The Vault Contract    
for this demo, we need a simple `Vault` contract to deposit our tokens into once we receive them cross-chain.  
This contract is a placeholder for any application you want to interact with. For now, we will focus on only two functions:   
* `deposit`: to send USDC to the contract.

* `withdraw`: to send the USDC back to your wallet.

* Whilst still in your "CCIP" workspace, create a new folder in your `contracts` folder called `interfaces` and create a file called `IVault.sol` here. [Source code for IVault.sol](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/interfaces/IVault.sol)
The `Sender` contract will use this interface to know the `Vault` ABI, and we can construct the data to send cross-chain to include a call to `deposit`.

* Create a new file in the `contracts` folder in your "CCIP" workspace called `Vault.sol` and copy-paste the `Vault.sol` contract code from the [course code repo](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/Vault.sol).
**Note**: this contract has been hard-coded to be deployed to Base Sepolia.
#### Deploying the vault

Compile and deploy this contract on the **destination chain** - Base Sepolia.
Once it has been deployed, pin the contract to your workspace.

### The Sender Contract  
Create a new file in the `contracts` folder in your "CCIP" workspace called `Sender.sol`. In this file, add the code from the `Sender.sol` contract in the [course code repo](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/Senders.sol).  
The gas limit that is used, for estimation of it read [Chainlink CCIP documentation](https://docs.chain.link/ccip/best-practices#setting-gaslimit)

Compile the `Sender` contract, and deploy it to Sepolia.

Remember to pin it to your workspace!

Switch the connected network to Base Sepolia inside MetaMask by clicking the network dropdown on the top left:  
![image](https://github.com/user-attachments/assets/bad8057d-85cf-480b-bbd8-dccd6e6692c2)  

Verify in Remix that you are connected to Base Sepolia by checking that the network has a chain ID of 84532.  

![image](https://github.com/user-attachments/assets/0f5a0c62-5c1a-4fe7-bd7d-6eda1f33cd6c)  
Now, deploy the `Vault` to Base Sepolia AND pin it to your workspace once it has deployed.  
### The Receiver Contract
For contracts to be able to receive CCIP messages, they need to inherit the [`CCIPReceiver`](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ccip/applications/CCIPReceiver.sol) contract. This is an abstract contract and enforces inheriting contracts to implement a function called `_ccipReceive`. This function is called by CCIP when sending the cross-chain message and will contain the logic to handle the data sent cross-chain.

In this example, we encoded a target contract and function call. This was the `deposit` function on the `Vault` contract, which automatically deposits our USDC into a vault after sending the tokens cross-chain.

Create a file inside the `contracts` folder called `Receiver.sol` and paste the `Receiver.sol` code from the [course code repo](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/Chainlink_CCIP_Messages/Receiver.sol).  
#### Compile and deploy the contract

Compile the `Receiver` contract and deploy it to Base Sepolia. Make sure you are still connected to Base Sepolia in MetaMask. And pin it.

#### Setting the sender
let's set the `s_sender` address.

* In the **Deployed Contracts** section, expand the `Receiver` contract instance.

* Next to the `setSender` function, paste the `Sender` address, click **setSender**, and confirm the transaction in MetaMask to allowlist the `Sender` contract to send the `Receiver` cross-chain messages.

This is now ready to send your cross-chain message to bridge USDC and automatically deposit it into a vault!

### Sending CCIP Messages
Till now three contracts are deployed:  
On the source chain (Sepolia):

1. `Sender`: To send the cross-chain message.

On the destination chain (base Sepolia):

1. `Receiver`: to receive the cross-chain message.
2. `Vault`: into which we call `deposit` to deposit the USDC we sent from the `Sender` .contract to the `Receiver` contract using CCIP.

#### Steps:
1. Fund the Sender with LINK
We first need to fund our `Sender` contract with some LINK on Sepolia to pay the fees.
Switch your network back to Sepolia in MetaMask. And Send some LINK token to `sender` contract (1 is enough).
2. Approve the Sender and Receiver contracts

We need to approve both `Sender` and `Receiver` contracts to spend USDC:

* `Sender`: so this contract can transfer the USDC from your wallet to itself, ready for the cross-chain transfer.

* `Vault`: so it can send USDC from your EOA to itself when calling `deposit`.

**Approving the Sender**

The `Sender` has been deployed to Sepolia, so we will use [Etherscan](https://sepolia.etherscan.io/) to perform this approval.

1. Head to the [USDC contract on Sepolia Etherscan](https://sepolia.etherscan.io/address/0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238)
2. Click on the **Contract** and then the **Write as Proxy** tabs.
3. Click **Connect to Web3** and connect your wallet:
![image](https://github.com/user-attachments/assets/4952a2f8-9689-46f3-97a6-06e09286b7af)
1. Click on the `approve` function:

   * Paste the `Sender` address as the `spender`

   * Set the `value` as `1000000` - 1 USDC

   * Click **Write**

   * Confirm the transaction in MetaMask.
![image](https://github.com/user-attachments/assets/4552c708-48c2-454e-9380-7faaff44912f)
2. Confirm the `Sender` has been added as a spender by:

   * Clicking the **Read as Proxy** tab.

   * Clicking **Connect to Web3** and connecting your wallet.

   * Clicking the `allowance` function .

   * Pasting your MetaMask address as the `owner`.

   * Pasting the `Sender` address as the `spender`.

   * Clicking **Query**.

   * `1000000` will be returned if the `Sender` was successfully added as a spender.
![image](https://github.com/user-attachments/assets/b1c9cf4a-8abf-4b08-a7a7-4c89872d941c)

**Approve the Vault**
The `Vault` has been deployed to Base Sepolia. So we will use [Basescan](https://sepolia.basescan.org/) to approve this contract.

1. Head to the [USDC contract on Base Sepolia](https://sepolia.basescan.org/address/0x036CbD53842c5426634e7929541eC2318f3dCF7e)
2. Click on the **Contract** and then the **Write as Proxy** tabs.
3. Click **Connect to Web3** and connect your wallet.
4. Click on the `approve` function:

   * Paste the `Vault` address as the `spender`.

   * Set the `value` as `1000000` - `1` USDC.

   * Click **Write**.

   * Confirm the transaction in MetaMask.

![image](https://github.com/user-attachments/assets/e17a2ae5-2cce-4c19-8e4c-99cab67500b3)  
1. Confirm the `Vault` has been added as a spender by:

   * Clicking the **Read as Proxy** tab.

   * Clicking **Connect to Web3** and connecting your wallet.

   * Clicking the `allowance` function .

   * Paste your MetaMask address as the `owner` .

   * Pasting the `Vault` address as the `spender`.

   * Clicking **Query**.

   * `1000000` will be returned if the `Vault` was successfully added as a spender.

![image](https://github.com/user-attachments/assets/9c554238-f001-4f31-b94f-be308cb0af7c)  

3. Sending the cross-chain message
Final step:  
* Head back to Remix.

* Switch back to Sepolia in MetaMask.

* Expand the `Sender` contract dropdown, click on the `transferTokens` function, and enter the following function parameters:

  * `_receiver`: the `Receiver` contract address.

  * `_amount`: `1000000`.

  * `_target`: the `Vault` contract address.

* Click **transact** and sign the transaction in MetaMask to send the message cross-chain:  

![image](https://github.com/user-attachments/assets/6c6f3b14-0902-494d-8b8b-64655b2051e3)    
Once your transaction has confirmed on Sepolia, copy the transaction hash:  
![image](https://github.com/user-attachments/assets/051e335a-edac-4460-84eb-b22600aedbc0)    
Head to the CCIP Explorer and paste the transaction hash to see the status of your CCIP message:
![image](https://github.com/user-attachments/assets/13fa9c35-5509-4b5f-a98d-4704897d3dfd)  
Once finality has been reached, you will see the status in the CCIP explorer:  
![image](https://github.com/user-attachments/assets/642d73e3-35a5-4f1e-847c-0f6a121dcba2)

#### Checking the data was executed

Let's check that the USDC was successfully automatically deposited into the vault.

* In MetaMask, connect to Base Sepolia.

* Expand the `Vault` contract dropdown in the **Deployed Contracts** section and find the `balances` function.

* Paste your MetaMask address as the `address` and click **balances**.

* If the data has been successfully executed, `1000000` will be returned:

![image](https://github.com/user-attachments/assets/c5a4ddec-3695-4b4a-9483-d6ca9c73b385)  

---

## Excercise
So now you know how to write a smart contract to bridge USDC tokens from Sepolia to Base Sepolia, the next challenge is to use this same smart contract to transfer [CCIP-BnM](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) tokens to ZKsync Sepolia and automatically send the tokens to a vault!

To do this you will need to:

1. Add the ZKsync Sepolia chain to MetaMask.
2. Add the CCIP-BnM token on Sepolia and ZKsync Sepolia to Metamask.
3. Modify and re-deploy the `Sender` smart contract:

   * `DESTINATION_CHAIN_SELECTOR` to be the [selector for ZKsync Sepolia](https://docs.chain.link/ccip/directory/testnet/chain/ethereum-testnet-sepolia-zksync-1).

   * Change the token to be [CCIP-BnM](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) rather than USDC.

   * (dev-only challenge): Can you modify the smart contracts to allow the function caller to specify the token and destination chain?
4. Modify the `Vault` smart contract

   * Change the token to be [CCIP-BnM](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) rather than USDC.

   * (dev-only challenge): Can you modify the `Vault` to allow an owner to be able to add allowed tokens?
5. Re-deploy the `Receiver` and `Vault` smart contracts:

   * To do this, you will need to use the Remix ZKsync plugin to compile and deploy your smart contract!

   * Simply click on the plugins tab on the bottom of the left sodebar, type "zksync" into the search bar and then click **Activate** on the plugin. It will now be available in the sidebar.

   * If you get stuck, [this lesson on Updraft](https://updraft.cyfrin.io/courses/solidity/simple-storage/zksync-plugin) will take you through using the ZKsync plugin step-by step.

   * You will also need to get some Zksync Sepolia ETH to pay for the gas. Watch [this Updraft lesson](https://updraft.devcyfrin.com/courses/blockchain-basics/basics/making-your-first-transaction-on-zksync) if you need a refresher of how to do this  

![image](https://github.com/user-attachments/assets/5dbe0734-23f4-4862-8a0f-abf5762fe21c)  
1. Get some test CCIP tokens (CCIP-BnM for Burn and Mint) by [calling](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) [`drip()`](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) [on the token contract using Etherscan](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract).
2. Call `transferTokens` as before and check the CCIP explorer to check the status of your cross-chain transfer.
3. Check your balance of ZKsync Sepolia CCIP-BnM tokens has now increased in the Vault!











