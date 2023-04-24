// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract TestContract1{
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, 'not owner');
        owner = _owner;
    }
}

contract TestContract2 {
    address public owner = msg.sender;
    uint public value = msg.value;
    uint public x;
    uint public y;

    constructor(uint _x, uint _y) payable {
        x = _x;
        y = _y;
    }
}

contract Proxy {
    // When the contract deployed, we call event.
    event Deploy(address);

    function deploy(bytes memory _code) external payable returns(address addr) {
        // Here to decide which contract to deploy.
        assembly {
            // create(v, p, n)
            // v = amount of ether to send.
            // p = pointer in memory to start of code.
            // n = size of code
            /*
            // msg.value not work in assembly, use callvalue alternatively.
            // The first 32 bytes encodes the length of the code, so actual code start after 32 bytes.
            // mload lod the first 32 bytes.
            // "addr :=" equal to address addr = create(...).
            */
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        // address(0) means that there was an error creating the contract.
        require(addr != address(0), 'deploy failed.');

        emit Deploy(addr);
    }
}

contract Hepler {
    function getBytecode1() external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract1).creationCode;
        return bytecode;
    }

    function getBytecode2(uint _x, uint _y) external pure returns(bytes memory) {
        bytes memory bytecode = type(TestContract2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_x, _y));
    }

    function getCalldata(address _owner) external pure returns(bytes memory) {
        return abi.encodeWithSignature('setOwner(address)', _owner);
    }
}