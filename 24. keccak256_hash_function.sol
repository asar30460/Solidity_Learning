// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// Some of use cases are to sign a signature come up with a unique ID
contract HashFunc {
    function hash(bytes32 a, address b) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(a, b));
    }

    function encode(string calldata text0, string calldata text1) external pure returns (bytes memory) {
        // Encode data into bytes.
        return abi.encode(text0, text1);
    }

    function encode_packed(string calldata text0, string calldata text1) external pure returns (bytes memory) {
        // Encode data into bytes and then compression.
        return abi.encodePacked(text0, text1);
    }

    function collision() external pure returns (bytes32, bytes32) {
        // Meeting collision condition when data is dynamic.
        return (keccak256((abi.encodePacked("AAAA", "BBB"))), keccak256((abi.encodePacked("AAA", "ABBB"))));
    }

    function solve_collision() external pure returns (bytes32, bytes32) {
        uint x = 123;
        return (keccak256((abi.encodePacked("AAAA", x, "BBB"))), keccak256((abi.encodePacked("AAA", x, "ABBB"))));
    }
}