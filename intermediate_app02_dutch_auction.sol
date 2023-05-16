// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Dutch auction: sellers set an initial price of a good
// Most of buyers may think it is overpriced, so this good go on sale overtime
// 10 on sale, 20 on sale, 30 on sale...
// Finally this good is sold.
// This is what Dutch auction indicates.


interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;

    /* Stroe the address of the NFT, and the NFT id that we're selling
     * for this auction
     */
    IERC721 public immutable nft;
    uint public  immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    enum Status{
        Progressing,
        Completed
    }
    Status private status;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;

        require(_startingPrice >= _discountRate * DURATION, "starting price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;

        status = Status.Progressing;
    }

    // When the buyer call this function to calculate the current price of NFT
    function getPrice() public view returns(uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable {
        require(status == Status.Progressing, "this NFT was sold");
        require(block.timestamp < expiresAt, "auction expired");

        uint price = getPrice();
        require(msg.value >= price, "ETH < price");

        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value - price;
        if(refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        status = Status.Completed;
    }
}