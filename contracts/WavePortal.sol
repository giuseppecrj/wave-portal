// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract WavePortal {
    uint totalWaves;
    uint private seed;

    event NewWave(address indexed from, uint timestamp, string message);

    struct Wave {
        address waver; // address of user who waved.
        string message; // message user sent.
        uint timestamp; // timestamp when the user waved.
    }

    // Declare a variable called waves which will hold a list of Wave{}
    Wave[] waves;

    // Let's create a mapping for cooldown
    mapping(address => uint) public lastWaved;

    constructor() payable  {
        console.log("We have been constructed");

        // Set an initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) external {
        /**
        * We need to make sure the current timestamp is at least
        * 30 seconds bigger than the last timestamp we stored
        */
        require(
            lastWaved[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );


        // Update the current timestamp we have for the user;
        lastWaved[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        // push the wave into the waves array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave;
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("Random # generated: %d", seed);

        // Give a 50% chance that the user wins the prize
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money that what the contract has"
            );

            (bool success, ) = (msg.sender).call{ value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        // emit the Wave
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() external view returns(Wave[] memory) {
        return waves;
    }

    function getTotalWaves() external view returns(uint) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
