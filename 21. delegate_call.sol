// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 *  A calls B, send 100 wei.
 *          B calls C, send 50 wei
 *
 *  A ---> B ---> C
 *      msg.sender = B
 *      msg.value = 50
 *      execute code on C's state variables
 *      use ETH in C
 */       

/*
 *  DelegateCall is to call the function in other contract to modify own variables.
 *  A calls B, send 100 wei
 *          B delegatecall C
 *
 *  A ---> B ---> C
 *      msg.sender = A
 *      msg.value = 100
 *      execute code on B's state variables
 *      use ETH in B
 */

contract TestDelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {
    event Response(bool success, bytes data);

    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        // _test.delegatecall(abi.encodeWithSignature("SetVars(uint256)", _num));
        _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
        );
    }
}
