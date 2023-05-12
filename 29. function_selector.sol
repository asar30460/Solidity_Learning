// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract FunctionSelector {
    function getSelector(string calldata _func) external pure returns(bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

contract Receiver {
    event Log(bytes data);
    
    function transfer(address _to, uint amount) external {
        emit Log(msg.data);
        // This return the following bytes data
        // 0xa9059cbb0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000064
        // 「0xa9059cbb」: Hash(transfer(address _to, uint amount)). And taking the first four bytes.
        // The rest of bytes is the parameters passing to the function
        // HEX(64) = 100

    }
}