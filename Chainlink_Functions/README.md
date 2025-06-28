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
In Remix, create a new workspace named "Functions," create a folder called `contracts` and a file called `FunctionsConsumer.sol`. Paste the `FunctionsConsumer.sol` code from the [course code repo](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Functions/FunctionsConsumer.sol)
Compile and deploy the contract on Sepolia testnet.  
Now we need subscriptionID  
## Creating a chainlink functions subscription
Chainlink Functions subscriptions are used to pay for, manage, and track Chainlink Functions requests.
steps:
1. Open functions.chain.link, connect your wallet (make sure you are still connected to Sepolia) and click Create Subscription:
![image](https://github.com/user-attachments/assets/026c74e2-99a8-48e3-83d0-64f4dea764fa)
2. Enter your email and, optionally, a subscription name.
![image](https://github.com/user-attachments/assets/dd1b07ee-91c6-44b0-b30a-1b776b6a11a2)
3. The first time you interact with the Subscription Manager using your wallet, you must accept the Terms of Service (ToS). A MetaMask popup will prompt you to sign a message to accept the TOS.
![image](https://github.com/user-attachments/assets/00d8ce14-4551-44b7-bdfb-b77ef8cadff8)
4. MetaMask will then pop up again and ask you to sign a message to approve the subscription creation:
![image](https://github.com/user-attachments/assets/f0a735cb-853f-44be-8bdd-9e9304443afd)  

5. After the subscription has been approved, MetaMask will pop up a third time and prompt you to sign a message that links the subscription name and email address you provided and ensure you are the subscription owner:
![image](https://github.com/user-attachments/assets/6535e50f-e500-4ddd-91dd-f4742e096582)  
6. After the subscription has been created, add funds(4 are enough, if transaction error occurs in remix when you are creating a request you can add more funds to subscription) by clicking the **Add funds** button:
![image](https://github.com/user-attachments/assets/ed08e266-2f22-43ac-ab26-53d2ef3cd01b)
Sign the transaction and send the LINK tokens to your subscription. Once the transaction has gone through, your subscription will have been successfully created and funded. It is now ready to add consumer contracts to make Chainlink Functions requests.  
7. Add consumer which is the address of the `FunctionsConsumer` contract we deployed on sepolia.   
Sign the message in MetaMask to send the transaction to add the consumer contract to the subscription. Once the transaction has gone through, the subscription configuration is complete, and you will be ready to make your first request!
8. Copy the subscriptionID.

### Sending request
Back in Remix, expand the `FunctionsConsumer` contract dropdown in the **Deployed Contracts** section. Find the `getTemperature` function and enter the following parameters:

* `_city`: `London`

* `subscriptionId`: the ID you just copied.
  Click **transact** and then sign the transaction in MetaMask to make the Chainlink Functions request
![image](https://github.com/user-attachments/assets/98221682-e609-4a33-b0c7-d79cb0a8feb5)  
On your subscription overview page, you can see your pending Chainlink Functions request:
![image](https://github.com/user-attachments/assets/d11aa75f-68b2-4020-ab29-f79ec243a6bc)
Now, in Remix, if we interact with our `FunctionsConsumer` contract and call the `s_lastTemperature` and `s_lastCity` functions, we can see the returned result
![image](https://github.com/user-attachments/assets/9ebf34dd-dd17-465d-ad24-279ec54a5e1b)


And We are done




