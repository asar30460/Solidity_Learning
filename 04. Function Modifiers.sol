// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FunctionModifier {
    bool public paused;
    uint public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    modifier whenNotPaused(){
        require(!paused, 'Contract Paused.');
        _;  // This line means run the subsequent code.
    }

    function inc() external whenNotPaused {
        count ++;
    }

    function desc() external whenNotPaused{
        count --;
    }

    modifier restric(uint _x) {
        require(_x < 100, 'x must less than 100.');
        _;
    }

    function incBy(uint _x) external whenNotPaused restric(_x) {
        count += _x;
    }

    // Ths rest code is demonstration of sandwich.
    modifier sandwich() {
        count += 10;
        _;
        count *=2;
    }
    // Firstly do count + 10. Then, execute foo function. After end of function, do count * 2;
    function foo() external sandwich {
        count += 1;
    }
}