// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract building {
    event Log(string message);

    string public name;
    string public location = "undefined";

    constructor(string memory _name) {
        name = _name;
    }

    // "virtual' to tell Solidity that this func can be inherited and customized by the other contract.
    function set_location(string memory _location) public {
        location = _location;
    }

    function get_location() public virtual returns (string memory) {
        return location;
    }

    // more code here.
    function Owner() public pure returns (string memory) {
        return "AI";
    }
}

contract Google is building("Taipei 1st headquarter") {
    string private area;

    function get_name() public view returns (string memory) {
        return name;
    }

    function set_area(string memory _area) public {
        area = _area;
    }

    // "override' means that this func can be customized.
    function get_location() public virtual override returns (string memory) {
        emit Log("Func. 'Google.get_location' called.");
        return (string.concat(location, area));
    }

    // more code here.
}

/* 
// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.
*/

// building is more priorior than Google, so, put building first, and then Google.
contract user is building, Google {
    string private section;

    function set_section(string memory _section) public {
        section = _section;
    }

    function get_location()
        public
        override(building, Google)
        returns (string memory)
    {
        return (string.concat(super.get_location(), section));
    }
}
