// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Deploy to Base Sepolia

// `IRouterClient`: Interface for the CCIP router.
import {IRouterClient} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/interfaces/IRouterClient.sol";
// `Client`: Library containing CCIP message struct.
import {Client} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/libraries/Client.sol";
// `CCIPReceiver`: Abstract contract that needs to be inherited to receive cross-chain messages.
import {CCIPReceiver} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/applications/CCIPReceiver.sol";
// `IERC20` & `SafeERC20`: For handling token transfers safely.
import {IERC20} from "@chainlink/contracts@1.3.0/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@chainlink/contracts@1.3.0/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/utils/SafeERC20.sol";
// `Ownable`: To implement ownership.
import {Ownable} from "@openzeppelin/contracts@5.2.0/access/Ownable.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract Receiver is CCIPReceiver, Ownable {

    // Using SafeERC20 for all IERC20 calls
    using SafeERC20 for IERC20;

    // Event emitted when a message is received from another chain.
    event MessageReceived(
        bytes32 indexed messageId, // The unique ID of the CCIP message.
        uint64 indexed sourceChainSelector, // The chain selector of the source chain.
        address sender, // The address of the sender from the source chain.
        bytes data, // The data that was received.
        address token, // The token address that was transferred.
        uint256 tokenAmount // The token amount that was transferred.
    );

    address private s_sender;

    // https://docs.chain.link/ccip/supported-networks/v1_2_0/testnet#ethereum-testnet-sepolia
    uint64 private constant SOURCE_CHAIN_SELECTOR = 16015286601757825753; // only allow messages from Sepolia

    error Receiver__NothingToWithdraw();
    error Receiver__NotAllowedForSourceChainOrSenderAddress(uint64 sourceChainSelector, address sender);
    error Receiver__FunctionCallFail();
    error Receiver__SenderNotSet();

    // pass the destination router address to the CCIPReceiver constructor(here, Base Sepolia router address)
    constructor() CCIPReceiver(0xD3b06cEbF099CE7DA4AcCf578aaebFDBd6e88a93) Ownable(msg.sender) {}

    modifier onlyAllowlisted(uint64 _sourceChainSelector, address _sender) {
        if (s_sender == address(0)) {
            revert Receiver__SenderNotSet();
        }
        if (_sourceChainSelector != SOURCE_CHAIN_SELECTOR || _sender != s_sender) {
            revert Receiver__NotAllowedForSourceChainOrSenderAddress(_sourceChainSelector, _sender);
        }
        _;
    }

    function setSender(address _sender) external onlyOwner {
        // set the sender contract allowed to receive messages from 
        s_sender = _sender;
    }

    /*
     * It implements the `_ccipReceive` function from the `CCIPReceiver` abstract contract and uses the `onlyAllowlisted` modifier.
     * Decodes the message data to extract a target address (the `Vault` contract) and function calldata (the `deposit` function signature and arguments).
     * Makes a low-level call to the target contract with the function data.
     * Reverts if the call fails.
     * Emits a `MessageReceived` event with details about the message
    */
    /// handle a received message
    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    )
        internal
        override
        onlyAllowlisted(
            any2EvmMessage.sourceChainSelector,
            abi.decode(any2EvmMessage.sender, (address))
        ) // Make sure source chain and sender are allowlisted
    {
        (address target, bytes memory functionCallData) = abi.decode(any2EvmMessage.data, (address, bytes));
        (bool success, ) = target.call(functionCallData);

        if (!success) {
            revert Receiver__FunctionCallFail();
        }

        emit MessageReceived(
            any2EvmMessage.messageId,
            any2EvmMessage.sourceChainSelector,
            abi.decode(any2EvmMessage.sender, (address)),
            any2EvmMessage.data,
            any2EvmMessage.destTokenAmounts[0].token,
            any2EvmMessage.destTokenAmounts[0].amount
        );
    }

    /*
     * This function allows the contract owner to withdraw any ERC-20 tokens in the contract:
     * Checks the contract's balance of the specified token.
     * Reverts if there are no tokens to withdraw.
     * Uses `SafeERC20`'s `safeTransfer` function to safely send all tokens to the owner.
    */
    function withdrawToken(address _token) public onlyOwner {
        // Retrieve the balance of this contract
        uint256 amount = IERC20(_token).balanceOf(address(this));

        // Revert if there is nothing to withdraw
        if (amount == 0) revert Receiver__NothingToWithdraw();

        IERC20(_token).safeTransfer(msg.sender, amount);
    }
}