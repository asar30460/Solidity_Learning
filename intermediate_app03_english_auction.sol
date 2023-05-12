// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IERC721 {
    function transferFrom(address from, address to, uint nftId) external;
}

contract EnglishAuction {
    IERC721 public immutable nft;
    uint public immutable nftId;

    address public immutable seller;
    // uint32 can store 100 yeats from now.
    uint32 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        
    }
}