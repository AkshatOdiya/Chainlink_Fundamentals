// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Deploy on Sepolia

import {FunctionsClient} from "@chainlink/contracts@1.3.0/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
//`FunctionsRequest` is the library we use to create Functions `Request` structs
import {FunctionsRequest} from "@chainlink/contracts@1.3.0/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

contract FunctionsConsumer is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    string public s_lastCity;   // The latest city a Chainlink Functions got a temperature for
    string public s_requestedCity; // The city for the latest pending Chainlink Functions request 
    string public s_lastTemperature; // The temperature of the last city Chainlink Functions got a temperature for

    // State variables to store the last request ID, response, and error
    bytes32 public s_lastRequestId; // The ID of the last request
    bytes public s_lastResponse; // The response for the last request
    bytes public s_lastError; // The errors for the last request

    // Hardcoded for Sepolia
    // Supported networks https://docs.chain.link/chainlink-functions/supported-networks
    address constant ROUTER = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    bytes32 constant DON_ID =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;
    //Callback gas limit
    // This is the maximum gas rquired to execute the `fulfillRequests` function and therefore fulfill your request.
    uint32 constant GAS_LIMIT = 300000;
    // JavaScript source code
    string public  constant SOURCE =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3&m`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";
    
    // Event to log responses
    event Response(
        bytes32 indexed requestId,
        string temperature,
        bytes response,
        bytes err
    );
    
    error UnexpectedRequestID(bytes32 requestId);
    
    // Constructor requires the Chainlink `Router` contract address (on the chain the contract is being deployed to) as a constructor parameter:
    constructor() FunctionsClient(ROUTER) {}

    /*
     * `getTemperature` is the function we will call to get the temperature for a specific city. It takes:
     * `city`: the city to get the temperature using Chainlink Functions.
     * `subscriptionId`: The Chainlink Functions subscription you want to use to fund your Chainlink Functions request.
     * First, we create a `FunctionsRequest.Request` struct, called `req`, which, remember, we can call functions from the `FunctionsRequest` library on.
     * Then, we call `initializeRequestForInlineJavaScript` on the `req` and pass the `SOURCE` to initialize the request.
    */
    function getTemperature(
        string memory city,
        uint64 subscriptionId
    ) external returns (bytes32 requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(SOURCE); // Initialize the request with JS code
       
        /*
         * We need to create an argument in our `getTemperature` function. To do this, we:
         * Create a string array, with one element, that'll contain the arguments, called `args`.
         * Set the first element to `city`, since this is the argument in the JavaScript source code.
         * Call the `setArgs` function from the `FunctionsRequest` library on the `req` struct and pass the newly created `args` variable.
        */
        string[] memory args = new string[](1);
        args[0] = city;
        req.setArgs(args); // Set the arguments for the request

        // Send the request and store the request ID
        /*
         * we send the request using the `_sendRequest` function implemented on the `FunctionsClient` contract we inherited. Here, we pass:
         * The encoded request.
         * The subscription ID funding the request.
         * The gas limit for the callback function (which we will go through shortly).
         * The DON ID the request will be sent to.
        */
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            GAS_LIMIT,
            DON_ID
        );

        // set the city for which we are obtaining the temperature
        s_requestedCity = city;
        return s_lastRequestId;
    }

    // Receive the weather in the city requested
    /*
     * `fulfillRequest` is the callback function that Chainlink Functions consumer contracts must implement. 
     * The DON will call this function after the JavaScript code has been run and the request has been fulfilled
    */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }

        s_lastError = err;
        s_lastResponse = response;

        s_lastTemperature = string(response);
        s_lastCity = s_requestedCity;

        // Emit an event to log the response
        emit Response(requestId, s_lastTemperature, s_lastResponse, s_lastError);
    }
}