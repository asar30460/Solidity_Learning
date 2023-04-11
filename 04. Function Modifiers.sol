// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FunctionModifier {
    bool public paused;
    uint public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    modifier whenNotPaused(){
        require(!paused, 'Paused.');
        _;  // This line means run the subsequent code.
    }

    function inc() external whenNotPaused {
        count ++;
    }

    function desc() external {
        count --;
    }
}