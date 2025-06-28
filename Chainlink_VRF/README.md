# Chainlink VRF
Blockchains are deterministic systems, meaning that given the same input, they will always produce the same output. This deterministic nature is essential for consensus and security but creates a significant challenge when generating randomness. True randomness cannot exist in a fully deterministic environment, yet many blockchain applications require unpredictable outcomes for fairness.  

[Chainlink Verifiable Random Function (VRF)](https://docs.chain.link/vrf/) provides a cryptographically secure source of randomness for smart contracts. It enables developers to access verifiably random values while maintaining blockchain applications' security and integrity requirements.

### How Chainlink VRF Works

For each request, Chainlink VRF:

1. Generates one or more random values (referred to as random "words").
2. Creates a cryptographic proof demonstrating how those values were determined.
3. Publishes this proof on-chain.
4. Verifies the proof before any consuming contracts use the random values.

This verification process ensures that results cannot be manipulated by any party, including oracle operators, miners, users, or smart contract developers, thus maintaining a provably fair and tamper-proof system.  
## Key Use Cases for Chainlink VRF

* **Gaming & NFTs**: Creating fair distribution of traits, rewards, or outcomes

* **Random Assignment**: Allocating tasks, duties, or resources randomly.

* **Sampling**: Selecting unbiased samples for governance committees or airdrops.

* **Fair Selection**: Choosing winners for contests, lotteries, or giveaways.

* **Dynamic NFTs**: Enabling NFTs to "evolve" based on random characteristics.
## Two Methods for Implementing VRF

Chainlink VRF offers two primary implementation methods to suit different needs:

### 1. Subscription Method

The subscription-based approach allows you to create and fund a subscription account with either LINK or native tokens. Multiple consumer contracts can connect to a single subscription, with transaction costs deducted after fulfillment.

**Advantages**:

* **Efficiency**: Support for multiple consumer contracts under one subscription.

* **Cost Management**: Fees deducted _after_ request fulfillment.

* **Gas Optimization**: Better control over gas prices with reduced overhead.

* **Higher Capacity**: More random values per request than direct funding.

**Best For**: Applications requiring regular or frequent randomness, such as gaming platforms, NFT projects with ongoing mints, or DeFi protocols needing consistent random inputs.

### 2. Direct Funding Method

With direct funding, each consuming contract _directly_ pays for its randomness requests using LINK or native tokens. The contract must have sufficient funds available before making a request.

**Advantages**:

* **Simplicity**: No subscription setup is required.

* **Transparent Allocation**: Easier tracking of costs per contract.

* **User Cost Transfer**: Ability to pass VRF costs directly to end users.

**Best For**: Applications with infrequent or one-off randomness needs, such as NFT distributions, contest selections, or token airdrops.

## Security Considerations
By leveraging Chainlink VRF, developers can incorporate secure, verifiable randomness into their blockchain applications, enhancing fairness and unpredictability while maintaining the integrity of the decentralized ecosystem.
visit the [Chainlink VRF documentation](https://docs.chain.link/vrf/v2-5/security) to learn the security considerations for implementing VRF.

---

# Creating a VRF Subscription

## Prerequisites

* You have some [Sepolia ETH funds](https://faucets.chain.link/).

* You have some [Sepolia LINK](https://faucets.chain.link/).
 Steps to create a subscription:
1. * Navigate to the [VRF App](https://vrf.chain.link/) and connect your wallet. Click the **Create Subscription** button.
![image](https://github.com/user-attachments/assets/9a0aa0af-5917-4f4c-9c2f-8f76ddadd1da)
* Optionally,

  * Give your subscription a name.

  * Enter your email address.

2. Click **Create Subscription**:
![image](https://github.com/user-attachments/assets/04f2203c-1a19-4d12-bf10-4a2bf89bba65)
3. Confirm the transaction to approve the subscription creation:
![image](https://github.com/user-attachments/assets/b97493fe-f797-4e00-9c27-1b0a2550b6a0)
4. Wait until the transaction has been confirmed, and sign the message to ensure you are the owner of the subscription:
![image](https://github.com/user-attachments/assets/367c1a6f-341c-4694-8cbc-0e2d76e313e6)
5. Your subscription will have been created! Now, you need to add LINK to the subscription to fund requests for randomness. Click **Add funds**:
![image](https://github.com/user-attachments/assets/ec133994-003e-4b42-aff2-15f8d0ff1094)  
6. Enter the **Amount to fund** as `10` LINK, click **Fund subscription**, and confirm the transaction to send the LINK to the subscription.
![image](https://github.com/user-attachments/assets/f5d5a284-625c-4fd5-a509-92644804e896)
7. You are now ready to add consumer smart contracts to your subscription to make requests for randomness. Click **Add consumers**:
![image](https://github.com/user-attachments/assets/bcf05a17-eee9-4fe8-817a-2fd2eace5c17)
8. Copy the **Subscription ID**.

## Writing a VRF consumer smart contract

Let's write a smart contract that gets a random number, uses that to mimic rolling a 4 sided die, and then assigns the roll to a Hogwarts House for the roller.

Open [Remix](remix.ethereum.org) and create a new workspace called "VRF", create a folder called `contracts` and a file called `HousePicker.sol` inside this folder. In this file, paste the code from the `HousePicker.sol` file in the [course code repo](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_VRF/HousePicker.sol).  

* Compile and Paste the as the `subscriptionId` constructor parameter and click **Deploy** on `sepolia`.
![image](https://github.com/user-attachments/assets/74b0727f-c431-4b0b-89c5-1d7359e3acd2)
1. Pin this deployed contract and Copy the contract address!
2. Paste the contract address of the `HousePicker` contract as the **Consumer address** and click **Add consumer**:
![image](https://github.com/user-attachments/assets/3f6e4665-cb85-4d73-a75d-24375a0c506f)
3. Sign the transaction to approve adding the consumer to the subscription.  
Once the transaction has confirmed, you will be able to view your subscription by clicking the **View subscription** button:
![image](https://github.com/user-attachments/assets/dd59e841-9bc0-4fde-8b28-b086dd2af02b)

* This will take you to an overview of your active subscriptions; click on the ID of your active subscription to open it:
![image](https://github.com/user-attachments/assets/9994b913-2c03-440e-a509-5969f527bcee)
* You will be able to see how many fulfillments have occurred on your subscription and the balance:
![image](https://github.com/user-attachments/assets/419bf840-c758-4211-a35d-783c5346ce7e)
### Requesting a random number

To send a request for a random number and get a Hogwarts house, we need to call `rollDice`.
This function will return the `requestId` to see when our request has been fulfilled:  
![image](https://github.com/user-attachments/assets/203b25ec-ba0f-48ac-870c-721a8cffb0da)  
Once you have signed the transaction, you can view the pending request in the Subscription Overview page. This will happen if you do not have enough LINK in the subscription (which I didn't) - you can click the **Fund subscription** button to add extra funds at any time.  
![image](https://github.com/user-attachments/assets/21e21592-aff5-46d2-8fd6-7fecd21b18a6)  
Once your request has been fulfilled, it will be visible in the **History** tab:
![image](https://github.com/user-attachments/assets/b2217522-dc42-4255-82a2-7166db4cadde)  
Now, you can go back to your contract in Remix and call `house`, passing your address as an argument, to see which Hogwarts house you were selected for:  
![image](https://github.com/user-attachments/assets/249bc456-bccd-4c8f-98c5-c3445870ab16)

---

And Done!










   







