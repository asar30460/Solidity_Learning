// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MultiSigWallet is ERC20 {
    event Deposit(address indexed sender, uint amount);
    // Transcation is submitted waiting for other owners to approve.
    // txId is the location where the transaction stores.
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bool executed;
    }

    address payable public tokenOwner = payable(msg.sender);
    // State vars to store owners.
    address[] public owners;
    // Only owners can call most of the functions inside this contrace.
    mapping(address => bool) public isOwner;
    // State vars to specify how many approvees to approve transaction.
    uint public required;

    // Store the transaction that approved by which owner.
    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _owners,
        uint _required
    ) ERC20(_name, _symbol) {
        require(_owners.length > 0, "owners required");
        require(
            _required > 0 && _required <= _owners.length,
            "Invalid required number of owners"
        );

        _mint(tokenOwner, 1000 * (10 ** decimals()));

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");

            // Require owner is unique.
            require(!isOwner[owner], "Owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value) external onlyOwner {
        require(balanceOf(msg.sender) >= _value, "not enough balance");
        transactions.push(
            Transaction({
                to: _to,
                value: (_value * (10 ** decimals())),
                executed: false
            })
        );
        emit Submit(transactions.length - 1);
    }

    function approveTransaction(
        uint _txId
    ) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getTransactionApprovalCount(
        uint _txId
    ) private view returns (uint count) {
        for (uint i; i < owners.length; i++) {
            if (approved[_txId][owners[i]]) count++;
        }
    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(
            _getTransactionApprovalCount(_txId) >= required,
            "not enough approvers"
        );
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        bool success = transfer(transaction.to, transaction.value);
        require(success, "execution failed");

        emit Execute(_txId);
    }

    function revokeApproval(
        uint _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}
