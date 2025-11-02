// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title EtherPot
 * @dev A simple lottery smart contract where users can enter by sending a fixed
 * amount of Ether. The owner can then pick a winner, who receives the entire pot.
 *
 * DISCLAIMER: The pseudo-randomness mechanism used here is NOT secure for production
 * use as it can be influenced by miners. This contract is for educational purposes only.
 */
contract EtherPot {
    address public owner;
    uint256 public ticketPrice;
    address payable[] public players;
    uint256 public lotteryId;
    address public lastWinner;

    event LotteryEnter(address indexed player, uint256 lotteryId);
    event LotteryWinner(address indexed winner, uint256 amount, uint256 lotteryId);

    constructor(uint256 _ticketPrice) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        lotteryId = 1;
    }

    /**
     * @dev Restricts function access to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "EtherPot: Caller is not the owner");
        _;
    }

    /**
     * @dev Allows a player to enter the lottery.
     * The player must send an amount of Ether equal to the ticketPrice.
     */
    function enter() public payable {
        require(msg.value == ticketPrice, "EtherPot: Must send exact ticket price");
        players.push(payable(msg.sender));
        emit LotteryEnter(msg.sender, lotteryId);
    }

    /**
     * @dev Picks a random winner from the list of players.
     * This function can only be called by the owner.
     * The winner receives the entire balance of the contract.
     *
     * IMPORTANT: This pseudo-random number generation is insecure and should not
     * be used in a production environment.
     */
    function pickWinner() public onlyOwner {
        require(players.length > 0, "EtherPot: No players in the lottery");

        uint256 index = getRandomNumber() % players.length;
        address payable winner = players[index];
        uint256 prizePool = address(this).balance;

        // Transfer the entire balance to the winner
        (bool success, ) = winner.call{value: prizePool}("");
        require(success, "EtherPot: Transfer failed");

        lastWinner = winner;
        emit LotteryWinner(winner, prizePool, lotteryId);

        // Reset the lottery for the next round
        players = new address payable[](0);
        lotteryId++;
    }

    /**
     * @dev Generates a pseudo-random number based on block properties.
     * WARNING: Not cryptographically secure. Miners can manipulate the outcome.
     */
    function getRandomNumber() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.difficulty,
            players.length,
            owner
        )));
    }

    /**
     * @dev Returns the list of players currently in the lottery.
     */
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    /**
     * @dev Returns the current prize pool (balance of the contract).
     */
    function getPrizePool() public view returns (uint256) {
        return address(this).balance;
    }
}
