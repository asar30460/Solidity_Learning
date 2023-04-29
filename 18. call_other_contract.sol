// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract CallTestContract {
    // There are 2 ways to call other contract.
    function setX_way1(address _test, uint _x) external {
        // Firstly, initialize the called contract.
        TestContract(_test).setX(_x);
    }
    function setX_way2(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    function getX(TestContract _test) external view returns(uint) {
        return _test.getX();
    }

    function setXandReceiveEther(TestContract _test, uint _x) external payable {
        // Send Ether to this contract by curly braces.
        _test.setXandReceiveEther{value: msg.value }(_x);
    }

    function getXandValue(TestContract _test) external view returns(uint _x, uint _value) {
        (_x, _value) = _test.getXandValue();
    }
}

contract TestContract {
    uint public x;
    uint public value = 123;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns(uint) {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns (uint, uint) {
        return (x, value);
    }
}