Read [Chainlink_Automation.md](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/Chainlink_Automation.md) for Description about chainlink automation.  

---
# Demonstrations

## Time Based Automation
Deploy the contract [TimeBased.sol](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/TimeBased.sol) using *Remix* on *sepolia testnet* and *verify* the contract on [Etherscan](https://sepolia.etherscan.io/).  

![image](https://github.com/user-attachments/assets/3f1a017e-f26c-4fd1-9f27-5a7901d81f11)  
With these specification:  
![image](https://github.com/user-attachments/assets/597ec097-e2c3-48d0-99bd-dafa1890f97a)  
* On the next screen, paste in the code for the contract and leave the rest of the options default/blank. Click **Verify and Publish**.  
When you return to the contract on Etherscan, you should now see a green checkmark next to the **Contract** tab. Now, you can view the source code on Etherscan and easily interact with the contract from the **Read contract** and **Write contract** tabs.
![image](https://github.com/user-attachments/assets/1ecc8865-bfce-49de-a43d-4ef1e97f86ab)

## Automating this contract using chainlink time based automation

* Head to the Chainlink [Automation app](https://automation.chain.link/)

* Click **Register new Upkeep** and then **Connect wallet** to connect MetaMask to the Automation app.

* Check that you’re connected to Sepolia by clicking the network dropdown in the app's top-right corner.

* For the trigger mechanism, select **Time-based trigger** and click **Next**.
  
![image](https://github.com/user-attachments/assets/006bc0ac-48e6-469a-a967-3a899f7d9fb0)

* Enter the `TimeBased` contract address and click **Next**. Our contract has been verified in this example, meaning Chainlink Automation can fetch the ABI. If you have a contract that has yet to be verified, you can provide the ABI.
![image](https://github.com/user-attachments/assets/e34ce9ac-24e3-4009-8755-22784f67b099)
* For the **Target function**, select the `count` function; this is the function we want Automation to execute, and click **Next**.

* Now, we must decide _when_ we want the function to run. In this example, we’ll have it run every five minutes or as a **Cron expression**: `*/5 * * * *`

Cron schedules are based on five values: minute, hour, day of the month, and day of the week.

Each field is represented by a number (or a special character):

Time (in UTC):

1. Minute: `0 - 59`
2. Hour: `0 - 23` (`0` = midnight)
3. Day of month: `1 - 31`
4. Month: `1 - 12` (or names, like `Jan`, `Feb`)
5. Day of week: `0 - 6` (`0` = Sunday, or names like `Sun`, `Mon`)

Special characters:

* `*` means “every” (every minute, every hour, etc.)

* `,` lets you list multiple values (e.g., `1,3,5`)

* `-` specifies a range (e.g., `1-5`)

* `/` allows you to specify step values (e.g., `*/5` for “every 5 units”)

Examples:

* `30 2 * * *`: Run at 2:30 AM every day

* `0 */2 * * *`: Run every 2 hours

* `0 9-17 * * 1-5`: Run every hour from 9 AM to 5 PM, Monday to Friday

* `*/15 * * * *`: Run every 15 minutes

* `0 0 1,15 * *`: Run at midnight on the 1st and 15th of each month

* Select your **Cron expression**, `*/5 * * * *`, and click **Next**.

* Fill in the **Upkeep details**:

  * **Upkeep name**: A name for the upkeep visible on the Automation dashboard, e.g. **"TimeBased Counter"**

  * **Admin Address**: This will be your connected wallet by default, but you can change which address will be the admin for the upkeep here.

  * **Gas limit**: The maximum amount of gas your selected function for upkeep will need to perform. This is `500_000` by default.

  * **Starting balance**: A starting balance of LINK is used to pay for Chainlink Automation. In this example, `5` LINK will be sufficient.

  * The **Project information** is optional; we will leave it blank.  

![image](https://github.com/user-attachments/assets/75b03a72-8aac-4daa-b690-252bde5a47b2)  

* Click **Register Upkeep** and approve the transactions to deploy the CRON job contract, request time-based upkeep registration, receive registration confirmation, and finally sign the message.
![image](https://github.com/user-attachments/assets/92143463-9bfd-4443-ad4b-c9937fc48796)
* Once this is complete, you should see that your registration request was successful, and you can then view your upkeep.

The **upkeep page** provides a quick overview of the upkeep status, such as when it was last run, the current balance of LINK, and how much LINK has been spent.  
![image](https://github.com/user-attachments/assets/745a5c8f-cf31-4c18-95b0-7b3fff4ebfb9)

The **details section** will give you all the information about the upkeep, including when it will run next and what function it will call.    
![image](https://github.com/user-attachments/assets/1b2604d7-c9bb-4695-97d9-0f6c5bde92ce)  
The **history section** shows the history of the upkeep. It is a useful tool for verifying whether an upkeep has been completed. Once five minutes have passed, you should be able to refresh the page and see that the upkeep has been completed.

![image](https://github.com/user-attachments/assets/68f4d537-e1e5-48cb-9fa2-48dd455c9d17)  
If you head back to Etherscan, you can see the value of `counter` has increased. The upkeep will continue until it either runs out of LINK or the upkeep is paused.

![image](https://github.com/user-attachments/assets/a80420e5-6ea9-458e-aa56-130a8ddab0fd)  
**Note**: You can pause your automation from the Automation app UI or withdraw your LINK funds from it if you want it to stop running. You can always resume it later if necessary or create a new one for future projects.









