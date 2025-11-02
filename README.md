# EtherPot Lottery Smart Contract

A simple, decentralized lottery game built on Solidity. Users can enter the lottery by purchasing a ticket at a fixed price. The contract owner can then trigger a function to select a random winner, who receives the entire prize pool.

## Features

-   **Fixed Ticket Price**: The entry fee is set upon deployment.
-   **Open Entry**: Anyone can enter by sending the correct amount of Ether.
-   **Owner-Controlled Draw**: The contract owner is responsible for initiating the winner selection process.
-   **Winner Takes All**: The chosen winner receives the entire balance of the contract.
-   **Automatic Reset**: The lottery automatically resets for a new round after a winner is chosen.
-   **Events**: Emits events for player entry and winner selection for easy tracking on the blockchain.

## Concepts Demonstrated

-   `payable` functions to receive Ether.
-   Storing data in a dynamic `address` array.
-   `owner` pattern using a `modifier`.
-   Transferring Ether from a contract to a user.
-   Basic pseudo-random number generation (for educational purposes).
-   Using `events` to log important actions.

## How to Use

### 1. Deploy the Contract

Deploy the `EtherPot.sol` contract using a tool like Remix, Hardhat, or Truffle. When deploying, you must provide a `_ticketPrice` in Wei.

*Example*: To set a ticket price of 0.01 ETH, you would pass `10000000000000000` as the constructor argument.

### 2. Enter the Lottery

Call the `enter()` function, sending exactly the `ticketPrice` amount of Ether with the transaction. Your address will be added to the list of players.

### 3. Pick a Winner (Owner Only)

The contract owner calls the `pickWinner()` function. This function will:
1.  Generate a pseudo-random index.
2.  Select a winner from the `players` array.
3.  Transfer the entire contract balance to the winner.
4.  Reset the `players` array for the next round.

---

### **Security Disclaimer** ⚠️

This contract is intended for **educational purposes only** and should not be used in a production environment. The method used for generating a "random" number (`getRandomNumber`) is based on block attributes, which can be influenced by miners. This makes the outcome predictable and manipulable. For a production-ready lottery, a secure source of randomness like Chainlink VRF would be necessary.
