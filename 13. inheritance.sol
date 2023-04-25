// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract A {
    // "virtual' to tell Solidity that this func can be inherited and customized by the other contract.
    function foo() public pure virtual returns(string memory){
        return 'A';
    }

    function bar() public pure virtual returns(string memory){
        return 'A';
    }

    // more code here.
    function baz() public pure returns(string memory){
        return 'A';
    }
}

contract B is A {
    // "override' means that this func can be customized.
    function foo() public pure override returns(string memory){
        return 'B';
    }

    function bar() public pure virtual override returns(string memory){
        return 'B';
    }

    // more code here.
}

contract C is B {
    // "override' means that this func can be customized.
    function bar() public pure virtual override returns(string memory) {
        return 'C';
    }

    function qux() public pure virtual returns(string memory) {
        return 'C';
    }
}

/* 
// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.
*/

// B is more priorior than C, so, put B first, and then C.
contract D is B, C {
    // D.bar() returns "C"
    // since C is the right most parent contract with function foo()
    function bar() public pure override(B, C) returns(string memory){
        return super.bar();
    }

    function qux() public pure override(C) returns(string memory) {
        return 'D';
    }
}