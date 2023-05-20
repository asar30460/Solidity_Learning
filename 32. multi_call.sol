// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FunctionSet {
    function func1(uint8 pass_para) public view returns (uint8, uint) {
        return (pass_para, block.timestamp);
    }

    function func2(uint8 pass_para) public view returns (uint8, uint) {
        return (pass_para, block.timestamp);
    }

    function getData1(uint8 pass_para) external pure returns (bytes memory) {
        // abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector, pass_para);
    }

    function getData2(uint8 pass_para) external pure returns (bytes memory) {
        // abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func2.selector, pass_para);
    }
}

contract MultiCall {
    /*
     *  Parameters:
            target: The addresses of the contract. You may call the funcs from different contracts.
            data: The data passed to each target
     */
    function multiCall(
        address[] calldata targets,
        bytes[] calldata data
    ) external view returns (bytes[] memory) {
        require(targets.length == data.length, "target length != data length");
        // Initialize the array of variable of outputs
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < data.length; i++) {
            /*
             *  Choices of call:
             *      call: Send transaction
             *      statiscall: view function, not to send transaction
             */
            (bool success, bytes memory result) = targets[i].staticcall(
                data[i]
            );
            require(success, "call failed");
            results[i] = result;
        }

        return results;
        /*
        *  results (total 256 bytes):
                First 64 bytes: Return first para of output of func1.
                Second 64 bytes: Return second para of output of func1.
                And so on...
        */
    }
}
