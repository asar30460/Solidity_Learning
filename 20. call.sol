// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Receiver {
    string public message;
    uint public x;

    event Received(address caller, uint256 amount, string message);


    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    receive() external payable {
        emit Received(msg.sender, msg.value, "Receive was called");
    }

    function foo(string memory _message, uint256 _x) public payable returns (bool, uint256) {
        emit Received(msg.sender, msg.value, _message);
        message = _message;
        x = _x;
        return (true, 100);
    }
}

contract Caller {
    event Response(bool success, bytes data);

    // Let's imagine that contract Caller does not have the source code for the
    // contract Receiver, but we do know the address of contract Receiver and the function to call.
    /*
    // The transaction itself can still succeed as long as it does not run out of gas before being included in a block.
    // When a transaction is sent to the Ethereum network, 
    // it needs to be included in a block before it can be executed. 
    // Miners are responsible for adding transactions to blocks, 
    // and they can choose which transactions to include based on factors such as the gas price and gas limit specified by the sender.
    // If a transaction runs out of gas before it can be executed, 
    // it will be reverted and any state changes made by the transaction will be discarded.
    // However, the transaction itself may still be included in a block, even though it failed to execute. 
    // This means that the sender may still have to pay the transaction fee (i.e., gas cost) even if the transaction did not complete successfully.
    */
    function testCallFoo(address _addr) public payable {
        // You can send ether and specify a custom gas amount.
        // "abi.encodeWithSignature" encodes the function we're going to call.
        (bool success, bytes memory data) = _addr.call{value: 1000}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        );
        
        emit Response(success, data);
    }

    // Calling a function that does not exist triggers the fallback function.
    function testCallDoesNotExist(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}
