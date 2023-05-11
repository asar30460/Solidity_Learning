// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Array {
    // initialize an array dynamically
    uint[] public arr;

    // initialize an array with fixed space
    uint[] public arr2 = [1, 2, 3];

    // Fixed sized array, all elements initialize to 0
    uint[10] public myFixedSizeArr;

    function get(uint _i) public view returns (uint) {
        require(_i < arr2.length, "Index out of bounds");
        return arr2[_i];
    }

    // Solidity can return the entire array
    // But this func should be avoided for arrays that can grow indefinitely in length. The bigger the array, the more gas it will use
    // "memory" for telling Solidity that we want to copy the state variable nums into memory and then return it
    function getArr() public view returns (uint[] memory) {
        return arr2;
    }

    function push(uint _i) public {
        // Append to array
        // This will increase the array length by 1.
        arr.push(_i);
    }

    function pop() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function remove(uint index) public {
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[index];
    }

    function examples() external {
        // create array in memory, only fixed size can be created
        uint[] memory a = new uint[](5);
    }
}

contract ArrayRemoveByshifting {
    uint8[] public arr = [1, 2, 3, 4, 5];

    // Gas consumption too much
    function remove(uint8 _index) public {
        for (uint8 i = _index; i < arr.length - 1; i++) arr[i] = arr[i + 1];

        arr.pop();
    }
}
