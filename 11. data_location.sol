// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DataLocations {
    struct MyStruct {
        uint foo;
        string text;
    }
    mapping(address => MyStruct) myStructs;

    function examples(
        uint[] calldata y,
        string calldata s
    ) external returns (uint[] memory) {
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        // Use 'stroage' to modify data.
        MyStruct storage myStruct_1 = myStructs[msg.sender];
        myStruct_1.text = "foo";
        // Use 'memory' to read data.
        MyStruct memory readOnly = myStructs[msg.sender];
        // readOnly.text = '456'; wrong usage.

        _internal(y);

        // For arrays that are initialized in memory we can only create a fixed size array.
        uint[] memory memArr = new uint[](3);
        memArr[0] = 234;

        return memArr;
    }

    // Call data is not modifiable. it can save gas when you pass input into this func.
    function _internal(uint[] calldata y) private {
        uint x = y[0];
    }
}
