// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;


contract Enum{
    enum Status{
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Cancled
    }

    Status public status;

    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    function get() public view returns(Status) {
        return status;
    }

    function set(Status _status) public {
        status = _status;
    }

    function cancel() public {
        status = Status.Cancled;
    }

    function reset() public {
        delete status;
    }
}