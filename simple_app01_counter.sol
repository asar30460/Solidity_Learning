// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Counter {
    uint public balance = 0;

    function deposit(uint num) external {
        balance += num;
    }

    function withdrawal(uint num) external {
        balance -= num;
    }
}
