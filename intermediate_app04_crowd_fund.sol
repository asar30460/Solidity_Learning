// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CrowdFund is ERC20 {
    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total pledge amount
        uint pledged;
        // Timestamp of start of campaign
        uint startAt;
        // Timestamp of end of campaign
        uint endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    // Total count of campaign created
    // It is also used to generate id for new campaign
    uint count;
    uint32 private immutable MIN_DURATION;
    // Mapping from id to Campaign
    mapping(uint => Campaign) public campaigns;
    // Look up amount that the one pledge in specific campaign
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(
        string memory _name,
        string memory _symbol,
        uint32 min_duration
    ) ERC20(_name, _symbol) {
        MIN_DURATION = min_duration;
        _mint(msg.sender, 1000);
    }

    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed pledger, uint amount);
    event Unpledge(uint indexed id, address indexed pledger, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed pledger, uint amount);

    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "Launch in the future only");
        require(_endAt > _startAt, "It ended before it started");
        require(
            _endAt >= _startAt + MIN_DURATION,
            "Too small period of campaign"
        );

        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        count++;

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.startAt);
        require(campaign.creator == msg.sender, "Not creator");

        delete campaigns[_id];
        emit Cancel(_id);
    }
    event Para(address, address);
    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.startAt);
        require(block.timestamp < campaign.endAt);
        emit Para(msg.sender, address(this));
        campaign.pledged += _amount;
        transferFrom(msg.sender, address(this), _amount);
        pledgedAmount[_id][msg.sender] += _amount;

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp < campaign.endAt, "Ended");
        require(pledgedAmount[_id][msg.sender] >= _amount, "Exceed the amount you pleage before");

        pledgedAmount[_id][msg.sender] -= _amount;
        campaign.pledged -= _amount;
        transferFrom(address(this), msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "Not ended");
        require(campaign.creator == msg.sender, "Not creator");
        require(campaign.goal >= campaign.pledged, "Not enough");
        require(!campaign.claimed, "Campaign ended");

        campaign.claimed = true;
        transfer(campaign.creator, campaign.pledged);

        emit Claim(_id);
    }

    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "Not ended");
        require(campaign.goal < campaign.pledged, "Goal achieved");

        uint amount = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        transfer(msg.sender, amount);

        emit Refund(_id, msg.sender, amount);
    }

    function showCurrentTime() external view returns (uint) {
        return block.timestamp;
    }

    function showThisAddress() external view returns (address) {
        return address(this);
    }
}
