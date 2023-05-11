// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
fallback() or receive()?

    Ether is sent to contract
                |
        is msg.data empty?
                /\
            yes    no
              /    \
receive() exisits?  fallback()
            /  \
          yes   no
          /      \
    receive()      fallback()
*/

contract Fallback {
    event Log(string func, uint gas);

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log("fallback", gasleft());
    }

    // Receive is a varient of fallback that is triggered when msg.data is empty.
    receive() external payable {
        emit Log("receive", gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
