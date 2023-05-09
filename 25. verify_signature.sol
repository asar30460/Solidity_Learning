// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/

contract VerifySig {
    function verify(address _signer, string memory _message, bytes memory _sig) external pure returns(bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(string memory _message) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns(address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        // Get the wellet(signed) address
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        // Length 65 = 32 + 32 + 1(uint 8)
        require(_sig.length == 65, "Invalid signature length.");

        assembly {
            // "mload" capture the first 32 bytes
            // Skip first 32 bytes since it store length
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            // Only get the first byte "96"
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}