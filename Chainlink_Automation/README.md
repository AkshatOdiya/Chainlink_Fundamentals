Read [Chainlink_Automation.md](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/Chainlink_Automation.md) for Description about chainlink automation.  

---
# Demonstrations

## Time Based Automation
Deploy the contract [TimeBased.sol](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/TimeBased.sol) using *Remix* on *sepolia testnet* and *verify* the contract on [Etherscan](https://sepolia.etherscan.io/).   
Remeber to pin the contract in *Remix* 

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

---

## Custom Logic Automation
Instead of a standard time-based upkeep trigger, like we used for the `TimeBased` contract, we'll implement it using custom logic trigger to demonstrate this approach's flexibility in a contract called `CustomLogic`.

At the heart of custom logic automation is a simple boolean return value. Your contract will include a function called `checkUpkeep` that evaluates conditions and returns either `true` or `false`. When this function returns `true`, Chainlink Automation executes your designated upkeep function called `performUpkeep`. These functions form the required `AutomationCompatibleInterface` custom logic compatible contracts must implement.

While we're using time as our trigger condition in this example for simplicity, custom logic can evaluate any on-chain condition or combination of conditions you can express in Solidity.  

To deploy the contract [CustomLogic.sol](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/CustomLogic.sol) to Sepolia using *Remix*:  
* Set the `_updateInterval` constructor parameter to `300` (this equals 5 minutes), and click the **Deploy** button.
![image](https://github.com/user-attachments/assets/83cbd490-b1b7-45df-b697-d980604ad2da)
* Once the contract is deployed, you can **verify it on** **[Etherscan](https://sepolia.etherscan.io/)**. While verifying past the flattened code on etherscan.
  
### Flattening files
As we have imported external contracts, we'll need to first flatten the file and then paste that code instead of just the `CustomLogic` code into the verification process. You can do this in the File Explorer by right-clicking the `CustomLogic.sol` file and clicking **Flatten**.  

![image](https://github.com/user-attachments/assets/ece8a3cc-8c1f-4c7d-88c7-61c393b00773)  
* Now you can copy the flattened code in `CustomLogic_flattened.sol` and use it for verification.
![image](https://github.com/user-attachments/assets/ede62967-0c85-4d06-a029-f1908b832c7d)

### checkUpkeep

* Once five minutes have passed, `checkUpkeep` will return `true`. This indicates that the automation system will run `performUpkeep` once we have setup a custom logic upkeep.
![image](https://github.com/user-attachments/assets/2b84b631-0dae-4eec-8908-30a98f7e5df8)


### Register Custom Logic Upkeep

With the contract deployed, we can head to the [Chainlink Automation app](https://automation.chain.link/) and create the automation job to enable automatic counting.

* This time, we’ll select **Custom Logic** and enter the address of our deployed contract, then click **Next**.
![image](https://github.com/user-attachments/assets/c3743025-d68f-4efc-b062-2b941608aaa0)
* Fill in the **Upkeep details**:

  * **Upkeep name**: A name for the upkeep visible on the Automation dashboard, e.g. **"TimeBased Counter"**

  * **Admin Address**: This will be your connected wallet by default, but you can change which address will be the admin for the upkeep here.

  * **Gas limit**: The maximum amount of gas your selected function for upkeep will need to use. By default, this is `500_000`.

  * **Starting balance**: A starting balance of LINK is used to pay for Chainlink Automation. In this example, `5` LINK will be sufficient.

  * The **Project information** is optional; we will leave it blank.
    

![image](https://github.com/user-attachments/assets/01b8bf94-c864-464a-8c74-ee3f02d57bb6)  
* Confirm the registration request and sign the message to verify your ownership of the upkeep.

* The **upkeep page** provides a quick overview that shows the upkeep status, such as when it was last run, the current balance of LINK, and how much LINK has been spent.

![image](https://github.com/user-attachments/assets/940ef0d4-377f-482e-b453-35b2b617dace)  
* The **details section** gives you all the information about the upkeep, such as when it will run next and what function it will call.
  
![image](https://github.com/user-attachments/assets/712bce41-cb60-4363-abf1-2964f1f71412)  
The **history section** shows the history of the upkeep, including every time it’s run. Once five minutes have passed, you should be able to refresh the page and see that the upkeep has been completed.  
![image](https://github.com/user-attachments/assets/d3c67758-173a-49ed-8a43-acffcdeec1d8)  
If you head back to Remix, you can see the value of `counter` has increased after 5 minutes has passed. The upkeep will continue until it runs out of LINK or is paused.  
![image](https://github.com/user-attachments/assets/32beeb92-69e8-43fd-952d-4ad2812476da)

---

## Log Trigger Automation
Here, we'll build a two-contract system to demonstrate log-triggered automation:

* **EventEmitter Contract**: This contract will emit a specific event when a certain function is called. This event will serve as the trigger for our automation.

* **LogTrigger Contract**: This contract will contain a function that tracks how often it has been called through automation. Chainlink Automation will trigger this counter function whenever the `EventEmitter` contract emits our target event.

This architecture demonstrates a powerful pattern in blockchain development - event-driven automation.
### Deploy and verify:  
[**EventEmitter.sol**](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/EvenEmitter.sol), a simple contract that emits the event `WantsToCount` when the `emitCountLog` function is called.
* Deploy this contract to Sepolia.    
* Once the contract is deployed, we can interact with it. If we click `emitCountLog` and confirm the transaction, it will emit an event `WantsToCount`.  
* Verify the contract on Etherscan.
![image](https://github.com/user-attachments/assets/6210ab98-844e-4bb9-9f91-142c5dd78658)  

When you return to the contract on Etherscan, you should see a green checkmark next to the **Contract** tab.  
If we go to the **Events** tab, we should see the log from our earlier `emitCountLog` call.  
[**LogTrigger.sol**](https://github.com/AkshatOdiya/Chainlink_Fundamentals/blob/main/Chainlink_Automation/LogTrigger.sol), this smart contract needs to:  

* Inherit the `ILogAutomation` interface so it is compatible with log trigger automation. This requires we implement two functions:

  * `checkLog`: simulated by Automation to see if any work needs to be performed. This function returns `performData`, which is passed to the `performUpkeep` when it is executed. We will return the function caller in the `performData` so that we can emit a log containing who triggered/sent the event.

  * `performUpkeep`: executed by Automation when performing the upkeep. The `performData` can be used inside the function implementation. In this function, we will increment `counter` and emit a log containing who triggered the event (to demonstrate how the `performData` can be used).
    
Deploy this contract to Sepolia.

### Register a Log Trigger Upkeep:  
Select **Register new Upkeep** and  select the trigger mechanism as **Log trigger**.  
![image](https://github.com/user-attachments/assets/29c4802f-b30f-4dc4-9b95-ab6505a9e201)  
Enter the address of the `LogTrigger` contract as the **Contract to automate**.

Enter the `EventEmitter` contract address for the **Contract emitting logs**, and select the `WantsToCount` event as the emitted log.

Leave the **Log index topic filters** blank and click **Next**  
![image](https://github.com/user-attachments/assets/02c501ff-d66f-4296-850c-7a9eaf319673)  

Fill in the **Upkeep details**:  
![image](https://github.com/user-attachments/assets/bca2a2fc-29e3-404c-aee5-5fae22bb2d94)  
Click **Register Upkeep** and submit the registration request. Once confirmation has been recived, sign the message to verify ownership. Your automation is now created!

![image](https://github.com/user-attachments/assets/2f07219c-a541-44c1-9bb6-614ceff033ca)  
You can click **View Upkeep** to see the upkeep details as the previous two lessons.

Return to Remix, head to the **Deploy & run transactions** tabs, and call the `emitCountLog` function in the `EventEmitter` contract to emit a log and trigger an upkeep.  
![image](https://github.com/user-attachments/assets/9e07585e-40fd-49cd-b577-3b97f7d043be)  
Once this transaction is complete, you should see the upkeep in the history section of your upkeep.  


![image](https://github.com/user-attachments/assets/ce3cc443-a9b1-41bf-8a0f-3fd43af20145)  

If you check the counted value in the `LogTrigger` contract, you’ll find that it has increased by `1`.  

And we're Done!

---



















