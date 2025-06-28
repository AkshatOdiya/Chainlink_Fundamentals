# Chainlink Functions

Chainlink Functions provides smart contracts access to trust-minimized off-chain compute infrastructure, enabling them to fetch data from external APIs and perform custom computation off-chain.

This service bridges the gap between blockchain applications and external data sources, expanding the capabilities of smart contracts beyond the blockchain environment.

## Chainlink Functions – Key Benefits

### API Connectivity

* Allows smart contracts to fetch data from **any public Web API**.
* Enables **data aggregation** and transformation **off-chain**, then delivers results on-chain.
* Without this, smart contracts are isolated from real-world data, **limiting their utility**.

### Custom Computation

* Supports execution of **custom JavaScript code** off-chain.
* Shifts heavy or expensive operations from the blockchain to a **serverless compute environment**.
* Results in **lower gas costs** and **better performance**.
* Developers can focus on **business logic**, not infrastructure.

### Decentralized Infrastructure

* Runs on **Chainlink-powered DONs** [(Decentralized Oracle Networks)](https://chain.link/education/blockchain-oracles).
* DONs are composed of **independent, secure nodes**.
* Brings **blockchain-grade trust** to off-chain computation.
* **Reduces reliance on centralized servers**, increasing security and resilience.

### Off-chain Computation via OCR

* User-provided JavaScript is executed by DON nodes in a **serverless environment**.
* Results are combined using Chainlink’s [**Offchain Reporting (OCR) Protocol**](https://docs.chain.link/architecture-overview/off-chain-reporting).
* Final output is **consensus-driven**, **secure**, and **trust-minimized**—all **without on-chain computation costs**.

## How Chainlink Functions Works

The process follows a request-and-receive pattern:

1. **Request Initiation**: Your smart contract sends JavaScript source code (either computation or an API request) in a request.
2. **Distributed Execution**: Each node in the DON independently executes the code in a secure serverless environment.
3. **Result Aggregation**: The DON aggregates all the independent return values from each execution.
4. **Response Delivery**: The final consensus result is returned to your smart contract.

This decentralized approach ensures that a minority of nodes cannot manipulate the response, providing robust security for your applications.

## Key Features

### Decentralized Computation

The service provides decentralized off-chain computation and consensus, securing the integrity of returned data using the DON.

### Threshold Encryption for Secrets

The service allows you to include secret values (such as API keys) in your request using threshold encryption. These secrets can only be decrypted through a multi-party computation decryption process requiring participation from multiple DON nodes, protecting sensitive information while enabling access to authenticated APIs.

### Subscription-Based Payment Model

You fund a Chainlink Functions subscription with LINK tokens to pay for Chainlink Functions requests. Your subscription is billed only when the DON fulfills your requests, providing a straightforward payment mechanism.

## When to Use Chainlink Functions

Chainlink Functions enables a variety of use cases:

* **Public Data Access**: Connect smart contracts to external public data, e.g., weather statistics for parametric insurance or real-time sports results for dynamic NFTs.

* **Data Transformation**: Perform calculations on data, e.g., to calculate sentiment analysis from social media data or derive asset prices from Chainlink Price Feeds.

* **Authenticated API Access**: Connect to password-protected data sources, from IoT devices like smartwatches to enterprise resource planning systems.

* **Decentralized Storage Integration**: Access data from IPFS or other decentralized databases for off-chain processes or low-cost governance systems.

* **Web2-Web3 Integration**: Build complex hybrid smart contracts that interface with traditional web applications.

* **Cloud Services Connection**: Fetch data from Web2 systems like AWS S3, Firebase, or Google Cloud Storage.


## Important Considerations

* **Self-Service Solution**: Users are responsible for independently reviewing any code and API dependencies submitted in requests.

* **User Responsibility**: Neither Chainlink Labs, the Chainlink Foundation, nor Chainlink node operators are responsible for unintended outputs due to issues in your code or API dependencies.

* **Data Quality**: Users must ensure that data sources specified in requests are of sufficient quality and are available for their use case.

* **Licensing Compliance**: Users are responsible for complying with licensing agreements for all data providers accessed through Chainlink Functions.

---

# Chainlink Function Playground
Chainlink Functions allows us to run JavaScript code off-chain and bring the result on-chain in a decentralized and secure way.  
The Chainlink Functions Playground, a tool that helps you learn how to use Chainlink Functions and test your JavaScript code.  
## What is the Chainlink Functions Playground?

[The Chainlink Functions Playground](https://functions.chain.link/playground/60f46de7-d42a-45d6-aade-e41a15160dbe) is an easy, overhead-free way to test the custom JavaScript code you want Chainlink Functions to execute. With the Functions Playground, you can even call third-party public APIs! This sandbox environment is the best way to experiment with Chainlink Functions without deploying a smart contract to a test network.

Key features of the Chainlink Functions Playground include:

* **Simulating Chainlink Functions**: Execute custom JavaScript code using Chainlink Functions directly in your web browser.

* **Real-Time Execution**: Run JavaScript source code and its provided arguments and see the output within seconds.

* **Calling APIs**: Quickly test API integrations, including HTTP requests to external data sources, and inspect the returned data.

* **Output Visualization**: Get results from your Chainlink Functions request in real-time, with a user-friendly interface showcasing both console logs and the final returned output.

The Chainlink Functions Playground is a useful tool for developers to get hands-on experience with Chainlink Functions and test out different use cases before going on-chain. This significantly lowers the barrier to testing externally connected smart contracts.

## How to use the Chainlink Functions Playground

Navigate to the [Chainlink Functions Playground](https://functions.chain.link/playground) where you will see an **Input** window:  
![image](https://github.com/user-attachments/assets/32e2188d-f789-4607-bf1d-45da2b92cd71)  
The playground has the following fields:

* **Source code**: This is where you put the JavaScript source code you want to test to send in your Chainlink Functions request.

* **Argument(s)**: Argument(s) to your JavaScript code. Arguments are variables in your JavaScript code, the values in your code you want to change, e.g., the city to retrieve a temperature for or some on-chain data.

* **Secret(s)**: private arguments, e.g., API keys, credentials, etc. This is the sensitive data you don't want to be publically visible. Chainlink Functions "injects" these values into your JavaScript at "runtime" (when the JavaScript is run).

To run the code:

* Click the **Run code** button

* The **Output** window will be populated with the returned data.

* If there are any logs, they will be visible in the **Console log** section.

## Using an external API in the Chainlink Functions Playground

Let's use the Chainlink Functions Playground to call an API to get a Star Wars character associated with a character ID.

Click the **Fill with example code** dropdown button and click the **Star Wars characters** example:

The following JavaScript source code will populate the **Source code** window:
![image](https://github.com/user-attachments/assets/4d2834ad-1291-4a0a-bd08-5f541d850e60)
You can run the code and see the outputs as it make the api call. You can also change the characterid by passing the numbers like 1,2,3.... in the argument column below the the code.  
That argument represents this `const characterId = args[0]`  
`args` is the array of variables that get injected into your JavaScript code at runtime.
This code has one argument–`characterId`: a unique ID to identify a Star Wars character.

---
# Building a Chainlink Functions Consumer Smart Contract
We will write a smart contract that requests data from an external API using Chainlink Functions.
Specifically, a Chainlink Functions consumer smart contract that fetches the weather for a specific city.
## Prerequisites

* You have Sepolia ETH and LINK testnet funds.

* You have imported the LINK token on Sepolia to MetaMask.



