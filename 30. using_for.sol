// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

struct Data { mapping(uint => bool) flags; }
// Now we attach functions to the type.
// The attached functions can be used throughout the rest of the module.
// If you import the module, you have to
// repeat the using directive there, for example as
//   import "flags.sol" as Flags;
//   using {Flags.insert, Flags.remove, Flags.contains}
//     for Flags.Data;
using {insert, remove, contains} for Data;

function insert(Data storage self, uint value)
{
    self.flags[value] = true;
}

function remove(Data storage self, uint value)
{
    self.flags[value] = false;
}

function contains(Data storage self, uint value)
    view
    returns (bool)
{
    return self.flags[value];
}


contract C {
    Data knownValues;

    function register(uint value) public {
        require(knownValues.flags[value], "value exists");
        knownValues.insert(value);
    }

    function block(uint value) external {
        require(!knownValues.flags[value], "not exist");
        knownValues.remove(value);
    }

    function status(uint value) external view returns(bool) {
        return knownValues.contains(value);
    }
}