# Chainlink Automation

Chainlink Automation is a decentralized service that automatically executes smart contract functions based on predefined conditions or at specific intervals.

### Why do we need Automation
Smart contracts have fundamental limitation: they cannot trigger their own functions. They need external stimuli to execute their code, which is where Chainlink Automation comes in.
Chainlink Automation act as a vigilant operator for your smart contracts. It constantly monitors for specific conditions or timeframes you've defined. When these triggers are met, Chainlink Automation automatically executes the designated functions in your contract. It operates 24/7, with reliability and precision that manual monitoring cannot achieve.

### The Concept of an “Upkeep”

In Chainlink Automation, an "upkeep" refers to a registered job that the network will monitor and execute on-chain when appropriate.

When you register an upkeep, you're essentially telling the Automation network: "Watch for these specific conditions, and when they occur, call this function in my contract."

These specific conditions are called "triggers".
### Types of Automation triggers

Chainlink Automation supports three distinct trigger mechanisms:

* **Time-based triggers**:
  These execute functions in your smart contract according to a schedule defined by a `cron expression`. For example, you could set a function to run every day at midnight or once per week.

* **Custom logic triggers**:
  These use custom logic defined within your smart contract through the `AutomationCompatibleInterface`. Your contract implements a `checkUpkeep` function that returns whether conditions are right for execution.

* **Log trigger**:
  These monitor blockchain events (logs) emitted by smart contracts. Chainlink Automation executes the associated function when a specified event occurs, allowing for event-driven automation.

### Automation Architecture

The Chainlink Automation Network consists of specialized Automation nodes coordinated by the Automation Registry smart contract. This Registry manages upkeep registrations and compensates nodes for successful executions.

Developers can register upkeeps, while node operators can register as Automation nodes. The network operates using a peer-to-peer system based on Chainlink’s [OCR3 protocol](https://docs.chain.link/architecture-overview/off-chain-reporting).

* Automation nodes continuously scan for upkeeps that are eligible for execution.

* Nodes reach consensus on which upkeeps to perform.

* They generate cryptographically signed reports.

* The Registry validates these reports before executing the upkeep functions.

This architecture provides several key benefits:

* Cryptographic guarantees of execution.

* Built-in redundancy across multiple nodes.

* Resistance to network congestion with sophisticated gas management.

* Reliable performance even during gas price spikes or blockchain reorganizations.

The system includes internal monitoring and alerting mechanisms to maintain network health and ensure high reliability and performance.

Chainlink Automation supports multiple blockchains, with details on the [supported networks page](https://docs.chain.link/chainlink-automation/overview/supported-networks). Information about the cost of using Chainlink Automation can be found on the [Automation economics page](https://docs.chain.link/chainlink-automation/overview/automation-economics).

## Time-Based Automation

Time-based automation enables you to automate any function in an existing smart contract that is externally callable.

## Custom Logic Automation
Custom logic upkeeps allow you to define specialized conditions directly within your smart contract to determine precisely when the upkeep should be executed. Unlike simpler trigger mechanisms, custom logic gives you complete control over when your functions run.

## Log Trigger Automation
Log triggers in Chainlink Automation allow you to execute smart contract functions in response to on-chain events. When a contract emits a specific event (log), Chainlink Automation can detect it and automatically call a designated function in your target contract.