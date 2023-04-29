// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
}

// Interface is useful when the contract you called contains thousand of lines.
// And you don't wanna copy paste, you can implement by interface.
// In this example, we assume "Counter" not in this file.
interface ICounter {
    function count() external view returns(uint);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns(uint) {
        return ICounter(_counter).count();
    }
}