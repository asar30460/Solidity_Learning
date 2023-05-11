// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Mapping {
    // Mapping from address to uint
    mapping(address => uint256) public myMap;

    function get(address _addr) public view returns (uint256) {
        // Mapping always returns a value.
        // If the value was never set, it will return the default value.
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public {
        // Update the value at this address
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        // Reset the value to the default value.
        delete myMap[_addr];
    }
}

contract NestedMapping {
    // Nested mapping (mapping from address to another mapping)
    mapping(address => mapping(address => bool)) public isFriend;

    function get(address _addr, address _addr2) public view returns (bool) {
        return isFriend[address(_addr)][_addr2];
    }

    function set(address _addr1, address _addr2, bool set) public {
        isFriend[_addr1][_addr2] = set;
    }

    function remove(address _addr1, address _addr2) public {
        delete isFriend[_addr1][_addr2];
    }
}

contract IterableMappoing {
    mapping(address => uint256) balances;
    mapping(address => bool) inserted;
    address[] public keys;

    function set(address _key, uint256 _val) external {
        balances[_key] = _val;

        if (!inserted[_key]) {
            inserted[_key] = true;
            keys.push(_key);
        }
    }

    function getSize() public view returns (uint256) {
        return keys.length;
    }

    function first() external view returns (uint256) {
        return balances[keys[0]];
    }

    function last() external view returns (uint256) {
        return balances[keys[getSize() - 1]];
    }

    function get(uint _index) external view returns (uint256) {
        return balances[keys[_index]];
    }
}
