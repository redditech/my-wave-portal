//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaves;

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
    }

    // Require the function to have a message, the message the user sends us
    function wave(string memory _message) public {
        totalWaves +=1;
        console.log("%s has waved with message %s", msg.sender,  _message);

        // Store the wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        //Emit an event
        // Link to emit: https://medium.com/coinmonks/the-curious-case-of-emit-in-solidity-2d88913e3d9a
        emit NewWave(msg.sender, block.timestamp, _message);

        uint256 prizeAmount = 0.0001 ether;
        require (
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has"
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
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