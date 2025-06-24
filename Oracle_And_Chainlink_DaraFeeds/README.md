## TokenShop Smart Contract

The **TokenShop** smart contract enables users to purchase tokens using ETH. It leverages **Chainlink Data Feeds** to determine the real-time ETH/USD exchange rate and calculate the number of tokens to issue based on the USD value of the ETH sent.

---

### **Functionality Overview**

When a user sends ETH to the contract:

1. The contract fetches the latest **ETH/USD price** from a Chainlink Data Feed.
2. It calculates the total **USD equivalent** of the ETH received.
3. Based on a **fixed USD price per token**, it determines how many tokens the user should receive.
4. The calculated amount of tokens is then **minted and transferred directly** to the buyer.

---

### **Token Integration**

This contract integrates with a **custom ERC-20 token** available in this repository:
🔗 [MyERC20.sol](https://github.com/AkshatOdiya/MyERC20/blob/main/MyERC20.sol)

---
