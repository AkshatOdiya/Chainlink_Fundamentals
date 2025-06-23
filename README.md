# Chainlink Fundamentals
Covering all major Chainlink services:

* Chainlink Data and Price Feeds

* Chainlink Automation

* Chainlink CCIP

* Chainlink Functions

* Chainlink VRF

* Chainlink Data Feeds

* Chainlink Proof of Reserve

## Chainlink Services

### Data and Price Feeds
**What they do:** Provide data on-chain, such as price information for cryptocurrencies, commodities, foreign exchange rates, etc.  
**How they work:** Networks of nodes collect price data from multiple exchanges and data providers, then aggregate them to determine the most accurate price at a certain time interval or when certain conditions are met.  
**Real-world use:** When you use a DeFi platform that needs to know the current ETH/USD price, it's likely using Chainlink Price Feeds.

### Automation (formerly Keepers)
**What it does:** Allows smart contracts to be automatically triggered when certain conditions are met.  
**How it works:** Chainlink nodes monitor conditions and execute functions when predefined criteria are satisfied.
**Real-world use:** Automatically liquidating collateral in lending platforms when values drop below required thresholds.

### Cross-Chain Interoperability Protocol (CCIP)
**What it does**: Enables secure communication between different blockchains.  
**How it works**: Creates a way for smart contracts on one blockchain to send messages and tokens to another blockchain in a secure and decentralized way.  
**Real-world use**: Send tokens from Ethereum to Polygon or have a smart contract on one chain trigger an action on another chain.

### Chainlink Functions

**What it does**: Allows developers to run custom computations off-chain and bring the results onto the blockchain.  
**How it works**: Executes custom code in a secure environment and delivers verified results to smart contracts.  
**Real-world use**: Complex calculations that would be too expensive to run directly on the blockchain.

**Note**: This is _completely_ separate from the functions on a smart contract. Chainlink Functions is a Chainlink service

### Verifiable Random Function (VRF)

**What it does**: Generates provably fair and verifiable random numbers that cannot be manipulated or predicted.  
**How it works**: Uses cryptographic techniques to create random numbers that come with proof they were generated fairly.  
**Real-world use**: NFT projects use VRF to fairly distribute random traits or select winners for giveaways.

### Data Streams

**What it does**: Provide on-demand access to high-frequency, low-latency market data, delivered off-chain and verifiable on-chain.  
**How it works**: Data streams use a pull-based design that supports sub-second data resolution for latency-sensitive use cases by retrieving data only when needed.  
**Real-world use**: High-frequency price updates for apps like predictions markets that enable participants to react quickly to events and provide accurate settlements.

### Proof of Reserve

**What it does**: Verifies that tokenized assets (like stablecoins) are actually backed by real-world reserves.  
**How it works**: Regularly checks and confirms that the claimed backing assets exist in the reported amounts.  
**Real-world use**: Stablecoin issuers can prove they have the money backing their tokens.  

### DeFi (Decentralized Finance)

**Price Feeds**: Most major lending and trading platforms use Chainlink to get accurate price information for cryptocurrencies and other assets.  
**Example**: When you take out a crypto loan on Aave or trade on Uniswap, Chainlink price feeds help determine fair values and prevent exploitation.  

### Gaming

**Verifiable Randomness**: Chainlink provides unpredictable, tamper-proof random numbers for fair gameplay and NFT distribution.  
**Example**: When a game needs to randomly select a winner or distribute random traits to NFT characters, Chainlink ensures no one can manipulate the outcome.

---

## The LINK Token: Fueling the Network
The LINK token is Chainlink's cryptocurrency that serves several important functions:
**Payment**: Chainlink node operators receive LINK tokens as payment for providing data services.  
**Security Deposit**: Nodes often need to stake LINK tokens as collateral, giving them skin in the game to be honest.



