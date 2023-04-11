// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
View function can read data from blockchain, while pure function can't.
Howerver, both of them can't modify data onto blockchain.
*/
contract ViewAndPureFunctions {
    uint public num;

    function viewFunc() external view returns (uint) {
        return num;
    }

    function pureFunc() external pure returns (uint) {
        return 1;
    }

    function addToNum(uint x) external view returns (uint) {
        return num + x;
    }

    function addTowNum(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}