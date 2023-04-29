// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Wallet {
    address payable public owner;

    constructor(){
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdrawal(uint _amount) external payable {
        require(msg.sender == owner, "caller is not owner");
        // To save gas, replace state var with var inside memory.
        payable(msg.sender).transfer(_amount);

        /*
        // Anothor way to transfer.
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");
        */
    }

    function get_balance() external view returns(uint) {
        return address(this).balance;
    }
}