//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // Use this to help generate a random number
    uint256 private seed;

    /*
     * Link to events in solidity: https://blog.chain.link/events-and-logging-in-solidity/
     */
    event NewWave(address indexed from, uint256 timestamp, string message);

    /*
     * A struct is a custom datatype where we customise what we want to hold inside
     * Link to structs https://www.tutorialspoint.com/solidity/solidity_structs.htm
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * Add variable to store array of structs
     * This is what will hold all the waves anyone sends me
     */
    Wave[] waves;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    // Require the function to have a message, the message the user sends us
    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s has waved with message %s", msg.sender, _message);

        // Store the wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        // Give a 50% chance that the user wins the prize
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            //send the prize
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        //Emit an event
        // Link to emit: https://medium.com/coinmonks/the-curious-case-of-emit-in-solidity-2d88913e3d9a
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    // Function to get all waves
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
