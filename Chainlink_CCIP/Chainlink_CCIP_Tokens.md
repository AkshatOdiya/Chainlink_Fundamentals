# Chainlink CCIP
## Blockchain Interoperability

Blockchain interoperability represents the critical capability for separate blockchain networks to communicate and interact with each other. At its core, this functionality is enabled by cross-chain messaging protocols—specialized infrastructure that allows one blockchain to read data from and write data to other blockchains.

This capability enables the development of [cross-chain decentralized applications (dApps)](https://blog.chain.link/cross-chain-smart-contracts/) that function cohesively across multiple blockchains. Unlike multi-chain applications that deploy isolated, identical versions across different networks, cross-chain dApps maintain state awareness and functional connectivity between their various blockchain components.
## Token Bridging

Token bridges allow assets to be moved across blockchains, increasing token utility by making cross-chain liquidity possible. Token bridges involve locking or burning tokens via a smart contract on a source chain and unlocking or minting tokens via a separate smart contract on the destination chain.  
### Token Bridging Mechanisms

There are three main token-bridging mechanisms:

1. **Lock and mint**:

   * **Source Chain -> Destination Chain**: Tokens are sent to and held in a secure smart contract on the source chain. This is known as "locking" the tokens. Equivalent "wrapped" tokens are minted as representations on the destination chain. Wrapped tokens are 1:1 backed representations of the original asset that allow it to be used on a blockchain different from its native one. You can think of it like an IOU.

   * **Destination Chain -> Source Chain**: Wrapped tokens are burned on the destination chain to release the original tokens by unlocking them on the source chain.

2. **Burn and mint**:

   * **Source chain**: Tokens are permanently destroyed (burned).

   * **Destination chain**: Equivalent tokens are newly minted.

   * This process is the same for the return journey.

   * This approach is particularly suitable for native tokens with minting authority.

3. **Lock and unlock**:

   * **Source chain**: Tokens are locked in a smart contract.

   * **Destination chain**: Equivalent tokens are released from an existing liquidity pool

   * This process is the same for the return journey.

   * This mechanism requires sufficient liquidity on both sides; typically, liquidity providers are incentivized through revenue sharing or yield opportunities.
4. **Burn and Unlock**:

   * **Source chain**: Tokens are permanently burned

   * **Destination chain**: Equivalent tokens are unlocked from a reserve pool, requiring liquidity providers.

   * This approach combines the finality of burning with the need for pre-existing liquidity on the destination chain.
## Cross-chain Messaging

Cross-chain messaging allows blockchains to communicate by sending data between chains. This enables more complex interactions beyond simple token transfers, such as:

* Synchronizing protocol states (like interest rates or governance decisions).

* Triggering functions on destination chains based on source chain events.

Cross-chain messaging protocols typically handle message verification, delivery confirmation, and proper execution on destination chains. This infrastructure is essential for building truly interconnected blockchain applications that can leverage the unique strengths of different networks while maintaining coherent application logic.
## Security Considerations

Cross-chain operations introduce fundamental security challenges not present in single-chain environments. Cross-chain systems must make tradeoffs between three critical properties:

* **Security**: Resistance to attacks and manipulation.

* **Trust assumptions**: The degree of trust required in external validators or oracles (when using Chainlink, this is minimized).

* **Configuration flexibility**: Adaptability to different blockchain architectures.

Unlike single-chain systems, cross-chain systems must carefully navigate these tradeoffs. This means that security models for cross-chain applications require more rigorous design considerations and often involve different assumptions than their single-chain counterparts.

## Chainlink CCIP
Chainlink CCIP is a cross-chain messaging solution that enables developers to build secure cross-chain applications capable of transferring tokens, sending arbitrary messages (data), or executing programmable token transfers between different blockchains.
Given the inherent security challenges of cross-chain operations, CCIP implements a [defense-in-depth security](https://blog.chain.link/ccip-risk-management-network/).  

CCIP offers three primary capabilities that form the foundation of cross-chain development:
### Arbitrary Messaging

* Send **custom data** between smart contracts across chains.
* Use to:

  * Encode parameters/instructions.
  * Trigger actions (e.g., mint NFTs, rebalance indices).
  * **Bundle** multiple instructions into one message for complex workflows.

### Token Transfers

* Move tokens **safely across chains**.
* Supports:

  * Transfers to **smart contracts** or **EOAs**.
  * **Rate-limiting** for better security/risk management.
  * Standard interface → better **dApp/bridge composability**.

### Programmable Token Transfers

* Send **tokens + instructions** together.
* Enables:

  * Context-aware transfers (tokens with usage logic).
  * Cross-chain DeFi (swap, lend, stake).
  * Unified, atomic execution of complex financial operations.

## CCIP – Core Security Features

* **Independent Nodes**: Multiple nodes operated by separate key holders.
* **Decentralized Oracle Networks (DONs)**: 3 DONs for commit, execute, verify.
* **Separation of Roles**: Different node sets for DONs and [Risk Management Network (RMN)](https://docs.chain.link/ccip/concepts#risk-management-network).
* **Client Diversity**: Two codebases in different languages → more decentralization.
* **Adaptive Risk Management**: [Level-5 security](https://blog.chain.link/five-levels-cross-chain-security/#level_5__defense-in-depth) to detect and respond to new threats.

## CCIP Architecture

CCIP enables a sender on a source blockchain to send a message to a receiver on a destination blockchain.

CCIP consists of the following components to facilitate cross-chain communication:

* **Router**: The primary user-facing smart contract deployed on each blockchain. The Router:

  * Initiates cross-chain interactions.

  * Manages token approvals for transfers.

  * Routes instructions to the appropriate destination-specific [OnRamp](https://docs.chain.link/ccip/architecture#onramp).

  * Delivers tokens to user accounts or messages to the receiver contracts on destination chains.

* **Sender**: An EOA (externally owned account) or smart contract that initiates the CCIP transaction. Both initiators can send tokens, messages, or tokens and messages.

* **Receiver**: An EOA or smart contract that receives the cross-chain transaction. The receiver may differ from the sender depending on the specific use case, such as sending assets to another user on a different chain. Only smart contracts can receive data.

## Fee-Handling

When using CCIP, there is an associated fee when sending a cross-chain message (either data, tokens, or both). The CCIP billing model uses a `feeToken` specified in the cross-chain message that users will send. This fee token can be either the blockchain's native token (including wrapped versions) or LINK. This fee is a **single fee on the source chain**, where CCIP takes care of the execution on the destination chain.

The fee is calculated using the following formula:

```Solidity
fee = blockchain fee + network fee
```
### Fee

The `fee` is the total CCIP fee for sending the message. This fee amount is accessible on the Router contract via the `getFee` function.
### Blockchain Fee

The `blockchain fee` represents an estimation of the gas cost the Chainlink node operators will pay to deliver the CCIP message to the destination blockchain. It is calculated using the following formula:

```Solidity
blockchain fee = execution cost + data availability cost
```
**Execution Cost**: The `execution cost` directly correlates with the estimated gas usage to execute the transaction on the destination blockchain. It is calculated using the following formula:

```Solidity
execution cost = gas price * gas usage * gas multiplier
```
Where:

* `gas price`: This is the gas on the destination chain.

* `gas usage`: This is calculated using the following formula:

```Solidity
gas usage = gas limit + destination gas overhead + destination gas per payload + gas for token transfers
```
Where:

* `gas limit`: The maximum amount of gas CCIP can consume to execute `ccipReceive` on the receiver contract, located on the destination blockchain. Users set the gas limit in the extra argument field of the CCIP message. Any unspent gas from this user-set limit is _not_ refunded.
  \- **Warning**: unspent gas is NOT refunded, so be sure to carefully estimate the `gasLimit` that you set for your destination contract so CCIP can have sufficient gas to execute `ccipReceive`.

* `destination gas overhead`: Fixed gas cost incurred on the destination blockchain by CCIP DONs.

* `destination gas per payload`: This depends on the length of the data being sent cross-chain in the CCIP message. If there is no payload (CCIP is used to transfer tokens and no data), the value is `0`.
  `gas for token transfers`: Cost for transferring tokens to the destination blockchain. If there are no token transfers, the value is `0`.

* `gas multiplier`: Scaling factor for _Smart Execution_. _Smart Execution_ is a multiplier that ensures the reliable execution of transactions regardless of gas spikes on the destination chain. This means you can simply pay on the source blockchain and CCIP will take care of execution on the destination blockchain.

**Data Availability Cost**: Relevant if the destination chain is an L2 rollup. Some L2s charge fees for data availability. This is because many rollups process the transactions off-chain and post the transaction data to the L1 as `calldata`, which costs additional gas.
## CCIP transaction lifecycle

**Message Initiation**: A sender, either a smart contract or an Externally Owned Account (EOA), initiates a CCIP message on the source blockchain. This message can include arbitrary data, tokens, or both.​ For token transfers, the corresponding token pool contracts handle the burning or locking of tokens on the source chain. ​

**Source Chain Finality**: The transaction must achieve finality on the source blockchain after initiation. Finality refers to the point at which a transaction is considered irreversible and permanently on the blockchain. The time to reach finality varies among blockchains; for instance, some may have deterministic finality, while others might require waiting for a certain number of block confirmations to mitigate the risk of reorganization. ​

**Committing DON Actions**: Once finality is achieved, the Decentralized Oracle Network (DON) responsible for committing transactions (Committing DON) observes the finalized transaction. It then aggregates multiple finalized CCIP transactions into a batch, computes a Merkle root for this batch, and records it onto the `CommitStore` contract on the destination blockchain. ​

**Risk Management Network Blessing**: The Risk Management Network reviews the committed Merkle root to ensure the integrity and security of the batched transactions. It "blesses" the Merkle root upon verification, signaling that the transactions are authenticated and can proceed. ​

**Execution on Destination Chain**: Following the blessing, the Executing DON initiates the transaction's execution on the destination blockchain. This involves delivering the message to the intended receiver. For token transfers, the corresponding token pool contracts handle the minting or unlocking of tokens on the destination chain. ​

**Smart Execution and Gas Management**: CCIP incorporates a Smart Execution mechanism to ensure reliable transaction delivery. This system monitors network conditions and adjusts gas prices as needed to facilitate successful execution within a specified time window, typically around 8 hours. [Manual execution](https://docs.chain.link/ccip/concepts/manual-execution) may be required to complete the process if the transaction cannot be executed within this window due to network congestion or insufficient gas limits. ​

Visit the [Chainlink Documentation](https://docs.chain.link/ccip/concepts/ccip-execution-latency#overview) for more information on the CCIP transaction lifecycle and how the DON determines finality.
### The Token Pool Contracts

Chainlink CCIP introduces the concept of a **Token Pool** contract.  

* In the context of CCIP, Token Pool contracts are responsible for **managing token supply** across the source and destination chains. Token Pool is the term used by Chainlink to refer to the smart contract responsible for controlling the transfer of tokens, regardless of the bridging mechanism.

* Each token on each chain has its own associated Token Pool contract, regardless of whether the bridging mechanism involves **minting and burning** or **locking and unlocking**.

* Traditionally, token pools serve as vaults—used to lock tokens from liquidity providers or to store tokens that have been bridged.

* In Chainlink’s terminology, a Token Pool is the contract that either calls `mint`/`burn` on the token contract or manages token custody for lock/unlock-style bridging.
### Importance of Finality in CCIP

Finality is a critical aspect of the CCIP transaction lifecycle, as it determines the point at which a transaction is considered irreversible and permanently recorded on the blockchain. Different blockchains have varying notions of finality. For instance, some blockchains achieve deterministic finality quickly, while others may require waiting for multiple block confirmations to ensure the transaction is unlikely to be reverted. CCIP considers these differences by waiting for the appropriate finality on the source blockchain before proceeding with cross-chain transactions, thereby ensuring the integrity and reliability of the protocol. ​View the [Chainlink Documentation](https://docs.chain.link/ccip/concepts/ccip-execution-latency#finality-on-l2s) to see the finality times on different blockchains.

## Transpoter
Transporter is an application designed to facilitate bridging tokens and messages across blockchains. Transporter is powered by Chainlink’s Cross-Chain Interoperability Protocol (CCIP). Transporter was built in association with the Chainlink Foundation and with support from Chainlink Labs to simplify access to the cross-chain economy. Features include an intuitive UI, 24/7 global support, and a [visual tracker](https://ccip.chain.link/) that allows users to continuously monitor the state of their assets and messages through every step of a transaction.

CCIP achieves the [highest level of cross-chain security](https://blog.chain.link/five-levels-cross-chain-security/) by utilizing Chainlink’s time-tested decentralized oracle networks, which has [enabled over \$15 trillion in transaction value](https://chain.link/), and a separate Risk Management Network. Leveraging CCIP’s [defense-in-depth](https://blog.chain.link/ccip-risk-management-network/) security model, Transporter enables secure and decentralized token transfers across a wide range of blockchains.
## Using Transporter  
Using Transported to bridge USDC from Sepolia to Base Sepolia. Note that when bridging USDC using CCIP, CCIP will also leverage Circle's Cross-chain transfer protocol (CCTP) under the hood. To understand more about how CCIP uses CCTP, visit the [CCIP documentation](https://docs.chain.link/ccip/tutorials/usdc).

> **_N0TE:_** See `README.md` of this folder to know the demonstrations and code.

## CCIP v1.5: The Cross-Chain Token Standard

Chainlink's Cross-Chain Interoperability Protocol (CCIP) version 1.5 introduces the Cross-Chain Token (CCT) standard, enabling a streamlined and decentralized approach to **enabling tokens** for CCIP. This allows developers to independently deploy and manage their own cross-chain tokens using CCIP without requiring Chainlink to manually integrate each token. Projects can now create composable cross-chain tokens with full autonomy and ownership, significantly accelerating the development of multi-chain applications.

The CCT standard addresses two primary challenges in the blockchain ecosystem:

1. **Liquidity Fragmentation**: With numerous blockchains operating independently, liquidity becomes siloed, making it difficult for users and developers to access assets across different ecosystems. This fragmentation poses challenges for token developers in choosing the optimal blockchain for deployment without compromising liquidity or facing trust issues on newer chains.

2. **Developer Autonomy**: Previously, enabling tokens for cross-chain required manual processes and reliance on third parties, leading to inefficiencies. The CCT standard empowers token developers with a **self-service model**, allowing them to autonomously deploy, configure, and manage their token pools within CCIP.

Sure! Here's a **clearer and more concise rephrasing** of your section **"CCT Benefits"**, while preserving all technical details:

## Benefits of the Cross-Chain Token (CCT) Standard

* **Self-Service Deployment**
  Developers can enable new or existing tokens for CCIP in just minutes using a streamlined, self-service process—no manual intervention from Chainlink required.

* **Full Developer Control**
  Developers maintain complete ownership of their contracts, including tokens, token pools, and custom logic. Key configurations like transfer rate limits are also fully customizable.

* **Robust, Layered Security**
  CCT is built on Chainlink’s battle-tested Oracle networks. Additional protections such as the Risk Management Network and configurable rate limits provide defense-in-depth security.

* **Programmable Transfers**
  CCT supports automatic transfers of both tokens and data in a single cross-chain transaction. This is enabled by customizable token pools that can pass messages alongside token transfers.

* **Audited TokenPool Contracts**
  Chainlink offers secure, audited `TokenPool` contracts to simplify cross-chain token management:

  * For **mint/burn**: Tokens are burned on the source chain and minted on the destination—no liquidity pool needed.
  * For **lock/unlock**: Tokens are locked on the source and unlocked on the destination, requiring pre-funded liquidity.
    In both cases, the contracts abstract away the complexity of cross-chain operations.

* **Zero Slippage Transfers**
  The exact amount of tokens sent from the source chain OnRamp is always the exact amount received on the destination chain OffRamp—ensuring predictability and precision.

* **Seamless ERC-20 Integration**
  Developers can enable existing ERC-20 tokens for CCIP, avoiding the technical challenges and risks of traditional bridging mechanisms.

## How the CCT Standard Works

The CCT standard facilitates cross-chain token transfers through the following components:

### Token Owner

The entity (contract or EOA) that owns the token contract. The token owner has the authority to manage the token contract, including upgrading the contract, changing the token administrator, or transferring ownership to another address.

### CCIP Admin

Like a token owner, the CCIP admin is the entity (contract or EOA) that can change the token administrator or transfer ownership to another address.

ERC-20 contracts are required to have _either_ a token owner or CCIP admin.

### Token Administrator

A role assigned to manage cross-chain operations of a token. The token administrator is responsible for mapping a token to a token pool in the `TokenAdminRegistry`. The token administrator can be the token owner, the CCIP amin (depending on the function implemented on the token contract), or another designated entity assigned by a token owner.

### Token Pools

Token pools are smart contracts that manage the minting, burning, locking, and releasing (depending on the implemented mechanism) of tokens across different blockchains. **They do not necessarily hold tokens** but ensure that the token supply remains consistent and prevent liquidity fragmentation. The CCT standard offers pre-audited token pool contracts, enabling zero-slippage cross-chain transfers. Developers can deploy these contracts to make any ERC20-compatible token cross-chain transferable or create custom token pool contracts for specific use cases.

**Note**: In Chainlink CCIP, the term "Token Pool" might be slightly confusing. Unlike traditional liquidity pools that hold tokens, a CCIP `TokenPool` is actually more like a coordinator contract that manages cross-chain token operations (minting, burning, locking, or unlocking). Even in mint/burn scenarios where no actual pooling of assets occurs, CCIP still requires a `TokenPool` contract for each token on each chain. This contract doesn't store tokens itself but instead orchestrates the token's cross-chain behavior.

#### CCIP Token Pool Mechanisms
The CCIP CCT Standard supports the following types of bridging mechanisms (remember, when using CCIP, all tokens need an associated Token Pool contract that is responsible for managing the token supply, regardless of the mechanism being used):

* Mint and burn
* Mint and unlock
* lock and burn
* lock and unlock

## How to Use the CCT Standard

To implement the CCT standard:

1. **Deploy the tokens**: Token developers either take an existing token or deploy one on every chain they want to enable their token. This token must implement with an `owner` function or `getCCIPAdmin` to return either the contract owner or CCIP admin respectively.

2. **Deploy Token Pools**: A token pool must be deployed on all enabled chains. These pools can be custom or Chainlink-written and audited.

3. **Configure Token Pools**: Set parameters such as rate limits to manage cross-chain token transfers.

4. **Register Tokens**: Register the token administrator (either a CCIP admin or owner, depending on which function the ERC-20 token implemented) using the `RegistryOwnerModuleCustom`. Link the deployed token pools with the token contracts on the `TokenAdminRegistry`.

Refer to the [Chainlink documentation](https://docs.chain.link/ccip/concepts/cross-chain-tokens) for detailed tutorials on deploying and registering cross-chain tokens.
