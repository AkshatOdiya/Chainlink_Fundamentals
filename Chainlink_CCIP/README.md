# Transpoter
Transporter is an application designed to facilitate bridging tokens and messages across blockchains. Transporter is powered by Chainlink’s Cross-Chain Interoperability Protocol (CCIP). Transporter was built in association with the Chainlink Foundation and with support from Chainlink Labs to simplify access to the cross-chain economy. Features include an intuitive UI, 24/7 global support, and a [visual tracker](https://ccip.chain.link/) that allows users to continuously monitor the state of their assets and messages through every step of a transaction. 

## Using *Transporter* to bridge USDC cross-chain from Sepolia to Base Sepolia.
### Prerequisites

* You have LINK funds on Sepolia.

* You've added the LINK token to MetaMask on Sepolia and Base Sepolia.

* You've added the USDC token to MetaMask on Sepolia and Base Sepolia. A list of the addresses on different chains can be found in the [Circle documentation](https://developers.circle.com/stablecoins/usdc-on-test-networks).

* You have test USDC on Sepolia., Use the [Circle USDC faucet](https://faucet.circle.com/) to do this.

### Steps:
1. Go to [test.transpoter.io](http://test.transporter.io/) specailly dedicated for testnets.
2. Connect your wallet.
3. Now configure like this
![image](https://github.com/user-attachments/assets/0a26bf40-4822-4498-afec-c6c5ad731d52)
4. Click on Approve USDC > Approve one-time only
5. Confirm the transaction
6. Once it is conformed on the sender side, you can click on **View transaction**.
7. The token to reach to destination will take approximately 20 minutes for ethereum sepolia **finality**. Other network may take different time for finality

--- 

# Transferring Tokens Cross-chain in a Smart Contract

Using Chainlink CCIP to transfer USDC tokens cross-chain from Sepolia to Base Sepolia:  
#### Prerequisites

* You have added the Base Sepolia testnet chain to MetaMask (if you need a reminder of how to add a chain to MetaMask, check out [this lesson in Blockchain Basics](https://updraft.cyfrin.io/courses/blockchain-basics/basics/making-your-first-transaction-on-zksync))

* You have testnet Sepolia ETH and Base Sepolia ETH.

* You have testnet LINK on Sepolia.

* You have added the LINK token to MetaMask on Sepolia and Base Sepolia.

* You have testnet USDC. You can obtain USDC on Sepolia from a Circle faucet.
### Project workflow

This is the workflow for sending a cross-chain transfer using the `CCIPTokenSender` contract that implements CCIP:

1. The `CCIPTokenSender` contract is deployed on the source blockchain (Sepolia in our case).
2. The `CCIPTokenSender` contract is funded with LINK to pay the CCIP fees.
3. The user creates an approval for `CCIPTokenSender` to spend their USDC (the amount equal to the amount to transfer cross-chain).
4. The user calls the `transferTokens` function on `CCIPTokenSender` to send the cross-chain message. This function will:

   * Check the users' USDC balance is sufficient.

   * Send the USDC from the user to the `CCIPTokenSender` contract. For this, we will use the `safeTransferFrom` function from the `SafeERC20` library, which is "safer" to use since it reverts if a transfer fails (e.g., if the receiver cannot be sent tokens for some reason).

   * Approve a Chainlink `Router` contract to be able to spend `CCIPTokenSender`'s tokens and transfer them cross-chain.

   * Get the fees for the message via the `getFees` function on the `Router` contract and approve the `Router` to spend the fees.

   * Sends the message via the `ccipSend` function on the `Router` contract.
### Important Notes

* **Token Approvals**: Before users can call `transferTokens`, they must approve `CCIPTokenSender` to spend their USDC tokens. 

* **Contract Funding**: `CCIPTokenSender` must be funded with LINK tokens to pay the CCIP fees.  
* **Chain Selectors**: The destination chain selector is a unique identifier for Base Sepolia. Different destinations require different selectors. Visit the CCIP directory to find the chain selector for [the available chains](https://docs.chain.link/ccip/directory/testnet).

* **Fee Management**: CCIP fees are paid in LINK tokens (or native tokens) and vary based on the destination chain and current network conditions.

## Steps:
In remix:
1. Compile and deploy the contract [CCIPTokenSender.sol](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_CCIP/CCIPTokenSender.sol) on sepolia testnet, take the view on [sepolia.etherscan.ion](https://sepolia.etherscan.io/).
2. Now send the **LINK Token** (1 is enough) to this deployed contract address using metamask.
   
![image](https://github.com/user-attachments/assets/d5da0e0d-3889-4389-a4e0-33653c24fcb9)  

![image](https://github.com/user-attachments/assets/112f0a17-c84c-4c0b-84b8-6a2eb10b993b)  

Enter the contract address  

![image](https://github.com/user-attachments/assets/ea57079f-789d-413b-a0ea-a83410cbdc6e)  

And confirm the transaction
#### Check the contract balance
Let's check the LINK tokens successfully transferred to the `CCIPTokenSender` contract by checking its LINK balance.

* Navigate to [Etherscan Sepolia](https://sepolia.etherscan.io/) and search the LINK token address on Sepolia: `0x779877A7B0D9E8603169DdbD7836e478b4624789`.

* Clic **Connect to Web3** and connect MetaMask to Etherscan.

* Click on the **Contract** tabs and then **Read Contract** and find the `balanceOf` function

* For the `account`, enter the `CCIPTokenSender` address
![image](https://github.com/user-attachments/assets/43751e31-d16a-44df-80bb-a76ab23e4fd9)
If the transfer is successful, it will produce an output of `100000000000000`, which is 1 LINK in WEI.
## Approve CCIPTokenSender to spend USDC

When calling `transferTokens`, the function transfers tokens from the user (represented by `msg.sender`) to the `CCIPTokenSender` contract using the `safeTransferFrom` function, enabling those tokens to be sent cross-chain.

Before this can work, the user must first grant permission to the `CCIPTokenSender` contract to transfer their USDC tokens. This permission is given through an "approval" transaction on the USDC contract, which authorizes the `CCIPTokenSender` contract to spend a specific amount of the user's tokens on their behalf.

To do this token approval, we are going to interact with the USDC contract on Etherscan Sepolia, as we did the LINK token.

* Navigate to [Etherscan Sepolia](https://sepolia.etherscan.io/) and search the USDC token address on Sepolia: `0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238`

* Click on the **Contract** tabs and then **Write as Proxy**, (**Write** since we want to send a transaction that modifies state and **as Proxy** since we want to be calling functions on the implementation contract, and this is a proxy. Don't worry about what this means - it's pretty advanced stuff).

* Connect your wallet by clicking the **Connect to Web3** button.

* Find the `approve` function and click on it to expand it.

* For the `spender`, enter the `CCIPTokenSender` address; for the `value`, enter the number of tokens you want to send cross-chain; we will be sending `1 USDC` or `1000000` since USDC has 6 decimal places:  
![image](https://github.com/user-attachments/assets/0d7feafc-fed9-4d7e-bae9-b5bd89a4e613)
* Click **Write** to initiate the transaction.

* Sign the transaction in MetaMask to send the transaction.

* To confirm the approval was successful, click the **Read as Proxy** tab and click the `allowance` function. Enter your address as the `owner` and the `CCIPTokenSender` contract address as the `spender`. Then, click **Query**:
![image](https://github.com/user-attachments/assets/c5908218-9be7-4c3a-990f-eca48d384c7f)
* If the approval was successful, you will see an output of `1000000`.

## Executing the Cross-chain Transfer of USDC

Let's FINALLY send some USDC from Sepolia to Base Sepolia using CCIP!

* Return to Remix and click the **Deploy and run transactions** tab.

* Click on the `transferTokens` function and fill out the following inputs:

  * `_receiver`: paste your wallet address since you will send yourself USDC on the destination chain. Note that, on some blockchains, you are not guaranteed to have the same address.

  * `_amount`: we are sending `1` USDC cross-chain, so put `1000000`(USDC has 6 decimal places).
![image](https://github.com/user-attachments/assets/b34641bd-3fed-440f-a6e0-63adfa00cb38)  
* Click **transact** to initiate the transaction.

* Sign the message in MetaMask by clicking **Confirm**.
* In Remix, we will see a log in the terminal confirming the transfer has been initiated on Sepolia.
![image](https://github.com/user-attachments/assets/438601f4-f94a-45da-84ea-39edf92de9f4)

Copy the Tx hash and you can view your Tx on [CCIP Explorer](https://ccip.chain.link/). It will take around 20 minutes(for sepolia, other chains may have different timing) for reaching finality and funds transfered to receiver.

## Doing for other tokens

use this same smart contract to transfer [CCIP-BnM](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) tokens to ZKsync Sepolia!

To do this you will need to:

1. Add the ZKsync Sepolia chain to MetaMask.
2. Add the CCIP-BnM token on Sepolia and ZKsync Sepolia to Metamask.
3. Modify and re-deploy the smart contract to Sepolia:

   * `DESTINATION_CHAIN_SELECTOR` to be the [selector for ZKsync Sepolia](https://docs.chain.link/ccip/directory/testnet/chain/ethereum-testnet-sepolia-zksync-1).

   * Change the token to be CCIP-BnM rather than USDC.

   * (devs-only): Can you modify the smart contracts to be adaptable for multiple chains by allowing the function caller to specify the token and destination chain?
4. Get some test CCIP tokens (CCIP-BnM) by [calling](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) [`drip()`](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract) [on the token contract using Etherscan](https://sepolia.etherscan.io/token/0xfd57b4ddbf88a4e07ff4e34c487b99af2fe82a05#writeContract).
5. Do `approve` and `allowance` for `CCIP-Bnm` (on `Sepolia` as this is the sorce chain) as we did same for `USDC` then Call `transferTokens` as before and check the CCIP explorer to check the status of your cross-chain transfer.
6. Check your balance of ZKsync Sepolia CCIP-BnM tokens has now increased!









