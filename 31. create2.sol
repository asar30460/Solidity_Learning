// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 * How do we know the address of a contract before we deploy the contract?
 * Contract address can be precomputed, before the contract is deployed, using create2
 */

contract TestContract {
    address public owner;
    uint public foo;

    constructor(address _owner, uint _foo) payable {
        owner = _owner;
        foo = _foo;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Factory {
    // Returns the address of the newly deployed contract
    function deploy(
        address _owner,
        uint _foo,
        uint _salt
    ) public payable returns (address) {
        // This syntax is a newer way to invoke create2 without assembly, you just need to pass salt
        // https://docs.soliditylang.org/en/latest/control-structures.html#salted-contract-creations-create2
        return address(new TestContract{salt: bytes32(_salt)}(_owner, _foo));
    }
}

// This is the older way of doing so
contract FactoryAssembly {
    event Deploy(address addr, uint salt);

    function deploy(bytes memory bytecode, uint _salt) public payable {
        address addr;

        /*
        NOTE: How to call create2

        create2(v, p, n, s)
        create new contract with code at memory p to p + n
        and send v wei
        and return the new address
        where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[p…(p+n)))
              s = big-endian 256-bit value
        */
        bytes32 salt = bytes32(_salt);

        assembly {
            addr := create2(
                callvalue(), // wei sent with current call
                // Actual code starts after skipping the first 32 bytes
                add(bytecode, 0x20),
                mload(bytecode), // Load the size of code contained in the first 32 bytes
                salt // Salt from function arguments
            )

            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        emit Deploy(addr, _salt);
    }

    function getAddress(
        bytes memory bytecode,
        uint _salt
    ) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                bytes32(_salt),
                keccak256(bytecode)
            )
        );

        return address(uint160(uint(hash)));
    }

    function getBytecode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(Factory).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
}
