// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// IRouterClient: Interface for the CCIP Router that handles cross-chain messaging
import {IRouterClient} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/interfaces/IRouterClient.sol";
// Client: Library with data structures for CCIP messages
import {Client} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/libraries/Client.sol";
// IERC20: Standard interface for interacting with ERC20 tokens (USDC and LINK)
import {IERC20} from "@chainlink/contracts@1.3.0/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
// SafeERC20: Enhanced functions for safer ERC20 token handling
import {SafeERC20} from "@chainlink/contracts@1.3.0/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts@5.2.0/access/Ownable.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

 /*
  * Important Notes
  * Token Approvals: Before users can call `transferTokens`, they must approve `CCIPTokenSender` to spend their USDC tokens. We will be doing this in the _next lesson_.
  * Contract Funding: `CCIPTokenSender` must be funded with LINK tokens to pay the CCIP fees. Again, we will be doing this in the _next lesson_.
  * Chain Selectors: The destination chain selector is a unique identifier for Base Sepolia. Different destinations require different selectors. Visit the CCIP directory to find the chain selector for [the available chains](https://docs.chain.link/ccip/directory/testnet).
  * Fee Management: CCIP fees are paid in LINK tokens (or native tokens) and vary based on the destination chain and current network conditions.
  */


 /*
  * This contract inherits OpenZeppelin's `Ownable` smart contract.
  * This contract sets the `_owner` as the address passed in the `Ownable` constructor. 
  * We can access this owner address externally by calling the `owner` function
 */
contract CCIPTokenSender is Ownable {
    using SafeERC20 for IERC20;

    error CCIPTokenSender__InsufficientBalance(IERC20 token, uint256 currentBalance, uint256 requiredAmount);
    error CCIPTokenSender__NothingToWithdraw();

    // The `Router` on the source chain routes the CCIP transfer requests to the DON.
    // https://docs.chain.link/ccip/supported-networks/v1_2_0/testnet#ethereum-testnet-sepolia
    IRouterClient private constant CCIP_ROUTER = IRouterClient(0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59);

    // The LINK token on the source chain is used to pay the fees.
    // https://docs.chain.link/resources/link-token-contracts#ethereum-testnet-sepolia
    IERC20 private constant LINK_TOKEN = IERC20(0x779877A7B0D9E8603169DdbD7836e478b4624789);

    // The USDC token on the source chain is the token we are transferring cross-chain.
    // https://developers.circle.com/stablecoins/docs/usdc-on-test-networks
    IERC20 private constant USDC_TOKEN = IERC20(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);

    // The destination chain selector: This is the identifier so Chainlink knows what chain you want to send your tokens to.
    // This selector can be found in the [CCIP Directory](https://docs.chain.link/ccip/directory/testnet).
    // https://docs.chain.link/ccip/directory/testnet/chain/ethereum-testnet-sepolia-base-1
    uint64 private constant DESTINATION_CHAIN_SELECTOR = 10344971235874465080;

    event USDCTransferred(
        bytes32 messageId,
        uint64 indexed destinationChainSelector,
        address indexed receiver,
        uint256 amount,
        uint256 ccipFee
    );

    constructor() Ownable(msg.sender) {}


    /*
     * `_receiver`: The address that will receive tokens on Base Sepolia
     * `_amount`: How many USDC tokens to transfer
     * It returns `messageId`: A unique identifier for tracking the cross-chain transfer
    */
    function transferTokens(
        address _receiver,
        uint256 _amount
    )
        external
        returns (bytes32 messageId)
    {
        // Balance Verification of the sender
        if (_amount > USDC_TOKEN.balanceOf(msg.sender)) {
            revert CCIPTokenSender__InsufficientBalance(USDC_TOKEN, USDC_TOKEN.balanceOf(msg.sender), _amount);
        }
        
        // CCIP requires a specific format for specifying tokens to transfer. The token information must be a `Client.EVMTokenAmount` struct array.
        // Create an empty `Client.EVMTokenAmount` array with a single element.
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);

        // Create a `Client.EVMTokenAmount` variable and pass the USDC token address and the amount to send.
        // This tells Chainlink what token and how much is being sent cross-chain.
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: address(USDC_TOKEN), // token address on the local chain.
            amount: _amount // Amount of tokens
        });

        // Set the first element of the array to the Client.EVMTokenAmount variable
        tokenAmounts[0] = tokenAmount;

        // To send a token cross-chain we need to create a message object of type `Client::EVM2AnyMessage`.
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver), // abi.encode(receiver address) for dest EVM chains
            data: "", // Data that is being sent cross-chain with the tokens. (For this example, we won't be sending any data)
            tokenAmounts: tokenAmounts, // Token transfers
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 0}) // Populate this with _argsToBytes(EVMExtraArgsV2)
                // Setting gasLimit to 0 because:
                // 1. This is a token-only transfer to an EOA (external owned account)
                // 2. No contract execution is happening on the receiving end
                // 3. gasLimit is only needed when the receiver is a contract that needs
                // to execute code upon receiving the message
            ),
            feeToken: address(LINK_TOKEN) // Address of feeToken. address(0) means you will send msg.value.
        });

        /*
         * Handling fee:
         * Get the fees for the message via the `Router` contract, check if the contract has a sufficient LINK balance to pay the fees,
         * and approve the `Router` to spend some of the `CCIPTokenSender`'s LINK as fees:
        */
        uint256 ccipFee = CCIP_ROUTER.getFee(
            DESTINATION_CHAIN_SELECTOR,
            message
        );
        if (ccipFee > LINK_TOKEN.balanceOf(address(this))) {
            revert CCIPTokenSender__InsufficientBalance(LINK_TOKEN, LINK_TOKEN.balanceOf(address(this)), ccipFee);
        }
        LINK_TOKEN.approve(address(CCIP_ROUTER), ccipFee);

        /*
         * Transferring and approving USDC:
         * Send the `_amount` to bridge to the `CCIPTokenSender` contract 
         * and approve the `Router` to be able to spend `_amount` of USDC from the `CCIPTokenSender` contract:
        */
        USDC_TOKEN.safeTransferFrom(msg.sender, address(this), _amount);
        USDC_TOKEN.approve(address(CCIP_ROUTER), _amount);

        // Send CCIP Message
        /*
         * Finally, send the cross-chain message by calling the `ccipSend` function on the `Router` contract and emit an event:
        */
        messageId = CCIP_ROUTER.ccipSend(DESTINATION_CHAIN_SELECTOR, message);
        emit USDCTransferred(
            messageId,
            DESTINATION_CHAIN_SELECTOR,
            _receiver,
            _amount,
            ccipFee
        );
    }

    /*
     * The function `withdrawToken` allows the owner to be able to withdraw any USDC sent to the contract to a specified address `_beneficiary`:
    */
    function withdrawToken(
        address _beneficiary
    ) public onlyOwner {
        uint256 amount = IERC20(USDC_TOKEN).balanceOf(address(this));
        if (amount == 0) revert CCIPTokenSender__NothingToWithdraw();
        IERC20(USDC_TOKEN).transfer(_beneficiary, amount);
    }
}