// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

library Math {
    function max(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x : y;
    }
}

contract TestLibrary {
    function max(uint x, uint y) external pure returns (uint) {
        return Math.max(x, y);
    }
}

// Use library function to modify state variable
library ArrayHelper {
    function index(uint[] storage arr, uint x) internal view returns (uint i) {
        for (uint i = 0; i < arr.length; i++) if (arr[i] == x) return i;

        revert("Not Found.");
    }
}

contract TestLibraryWithModifyVar {
    // Another way to use lib.
    // Tell Solidity that for this data type attach all of the functionalities defined inside lib.
    using ArrayHelper for uint[];

    uint[] public arr = [3, 2, 1];

    function testFind(uint number) external view returns (uint i) {
        return arr.index(number);
    }
}
