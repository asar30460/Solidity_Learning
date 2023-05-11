// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Basic {
    // Show range of datatype
    int public minInt = type(int).min;
    uint public maxUint = type(uint).max;

    // Gas difference between constant and non constant
    address public constant MY_ADDRESS =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    address public my_address = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;

    // State variables are variables that store data onto the blockcahin
    // State variables are declared inside a contract but outside of function!!!
    uint8 public stateVar = 123;
    bool public isClick = false;

    // Basic function
    function showLocalVar() external {
        uint8 nonStateVar = 1;
        nonStateVar += stateVar;
        isClick = true;
    }

    // Basic function with unable to read and write data on blockchine "pure"
    // External means when you deploy this contract, you can call this function
    function add(uint a, uint b) external pure returns (uint) {
        return a + b;
    }

    // Introduce global variables in Solidity. "view" will be discussed later.
    function globalVars() external view returns (address, uint, uint) {
        // This is a global variable that stores the address that the one called this function
        address sender = msg.sender;

        // Stores the uint timpstamp of when this function was called
        uint timestamp = block.timestamp;

        // S tores the current block number
        uint blockNum = block.number;
        return (sender, timestamp, blockNum);
    }

    function ternary(uint _x) external pure returns (uint) {
        // Genereal if statement is same as C++
        return _x < 10 ? 1 : 2;
    }

    function for_loop() external pure {
        for (uint i = 0; i < 10; i++) {
            if (i == 3) continue;
            if (i == 5) break;
        }

        uint j = 0;
        while (j < 10) {
            j++;
        }
    }
}
