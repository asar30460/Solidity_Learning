// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Immutable variables are like constants.
// Values of immutable variables can be set inside the constructor but cannot be modified afterwards.
// Also, immutable can reduce some gas compared to general state variable.

contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    // Usually show up with constructor.
    constructor(uint _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}
