IDE: RemixIDE
# Deploying the TokenShop contract

1. Go to the **Deploy & Run Transactions** tab within Remix.
2. Select the `TokenShop.sol` contract from the contract field in the deployment tab.
3. Make sure that your MetaMask browser wallet is connected to Sepolia and that you’ve connected to MetaMask as your Remix environment (the injected provider).
4. The TokenShop contract requires a `tokenAddress` as a constructor parameter. So, paste the `MyERC20.sol` contract address you deployed in the previous section.

![image](https://github.com/user-attachments/assets/a3052e50-48d7-4375-995c-f52418d8bf64)

1. Click on **Deploy**, and this will open MetaMask. Hit **Confirm** to sign the transaction on Sepolia. This will deploy the `TokenShop` contract to Sepolia testnet.

After it’s deployed to Sepolia, you will see the transaction details in Remix’s console sub-window.

1. Copy your `TokenShop` contract address from the **Deployed Contracts** section in Remix.
2. It’s a good idea to “pin” the `TokenShop` contract in this workspace so you can still access it if you end up closing Remix and returning later.

Ideally, at this point, both your `MyERC20` and `TokenShop` contracts should be pinned to your active Remix Workspace.  

![image](https://github.com/user-attachments/assets/353ad0a4-3036-4af7-9a92-e5d27167d3bb)    

Now let's give your `TokenShop` contract the ability to “mint” your tokens from the `MyERC20` contract! We need to give the `TokenShop` contract the `MINTER_ROLE`.

1. In the **Deployed contracts** section, find your `MyERC20` contract dropdown. Look for the `MINTER_ROLE` function. Since it is a public state variable, it will have an automatic getter function to "get" it's value.

![image](https://github.com/user-attachments/assets/ef396df6-5211-4242-a540-0597f28a849a)  
1. Click it to read the data from your smart contract. Its value is `“0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6”`. This is the [keccak256](https://www.cyfrin.io/glossary/keccak256) hash string representing the word “MINTER\_ROLE”.

2. Next, expand the `grantRole` function using the down arrow and paste that `MINTER_ROLE` hash `0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6` into the `grantRole` function along with the address of the `TokenShop` contract you just deployed  
![image](https://github.com/user-attachments/assets/e46a0b39-46f1-4e98-aa91-874bb676924d)  
1. Click `transact` to call the function and then sign the transaction in the MetaMask pop-up by clicking **Confirm**.

Doing this will authorize your `TokenShop` to mint your newly created token.

Before we continue, let’s double-check and confirm that your `TokenShop` has indeed been authorized:  

### Check roles

1. In your `Token` contract dropdown menu, find the `hasRole` function.
2. Expand the function and note that it requires two parameters:

   * `role`: We are interested in the `MINTER_ROLE`, which as a `bytes32` value is `0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6`. This is the **keccak256 hash** of the string `"MINTER_ROLE"`. We will refer to those bytes as the **hash** from now.

   * `account`: This function will tell us what role a given account has—in our case, the `account` we are checking the role for the `TokenShop` contract address.

The function will return a boolean (`true` or `false`) indicating whether that address has that particular role assigned to it.

1. Put in those two inputs and click on the `hasRole` button. It should return a boolean response of `true`  
![image](https://github.com/user-attachments/assets/b15a5bc5-1809-4d25-bba3-b1670cc4eea5)  
## Getting Price Data From Chainlink Price Feeds

We will now use the Chainlink USD/ETH Price Feed that we referenced inside our `TokenShop` contract.

* Go to your `TokenShop` contract dropdown and find the `getChainlinkDataFeedLatestAnswer` function. You can hover your mouse over the buttons to see the full function name.

* Click on the **transact** to call that function and send a transaction. It will return the price with 8 decimal places.  
![image](https://github.com/user-attachments/assets/885eda4b-5029-414a-b207-900ddfa77777)  
This is the price of `1 ETH` in terms of `USD` using 8 decimal precision. Note that different feeds may have different precisions.  

You can find the decimals for the different feeds in the [Price Feeds Documentation](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum\&page=1#sepolia-testnet) (make sure “Show More Details” is checked).

To convert the integer (with a certain level of precision) to a float, we need to divide the result by 10, raised to the power of the number of decimal points (`8` in this case).

Since the ETH/USD price feed’s data has `8` decimal places, we can see that the price, as per the screenshot, is \$1917.96 (divide the returned value by `10^8`).  

---

# Buying Tokens from TokenShop

Let's use the `TokenShop` contract to buy some `MyERC20` tokens. This is Contract delpoed in [MyERC20](https://github.com/AkshatOdiya/MyERC20) github repo.

1. Open your Metamask and click the **Send** button. Enter the `TokenShop` contract address as the **To** address and enter `0.001` as the amount to send `0.001 ETH` to your `TokenShop` address.  
![image](https://github.com/user-attachments/assets/a9485a65-0d77-44fc-9ca5-22c0917ce5d8)  
Click **Continue** and the **Confirm** to send the transaction.

This will send `0.001 ETH` to your `TokenShop` contract and trigger the `receive` function, which will mint tokens from the `MyERC20` contract to your wallet address.

1. Once MetaMask confirms the transaction on the blockchain, you can check whether your minted tokens show in your account in two ways:

* You can check your MetaMask wallet, under Tokens, to see if the Token you’ve previously added to your MetaMask has an updated balance.  
![image](https://github.com/user-attachments/assets/f90c73e1-89f0-40a1-9b21-a7cb96e482bc)  
You can also click on the `MyERC20` contract in Remix. Then, check how much of your token is held by your wallet address by calling `balanceOf` function and passing in your address.  
![image](https://github.com/user-attachments/assets/0df74093-4ee2-4a38-9a4f-c3440ab81245)  

Congratulations! You just bought and minted tokens from the `MyERC20` contract using the `TokenShop` contract using Chainlink Price Feeds to convert an ETH amount to a USD amount to calculate how many tokens to mint!


















