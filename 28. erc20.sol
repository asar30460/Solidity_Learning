// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IERC20 {
    // The amount of this ERC20 token
    function totalSupply() external view returns(uint);

    // The amount of ERC token that the account has
    function balanceof(address account) external view returns(uint);

    // Holder transfer holder ERC20 token to recipient
    function transfer(address recepient, uint amount) external returns(bool);

    // Approve other sender to spend some of his token. Also, by calling transfer
    function approve(address spender, uint amount) external returns(bool);

    // How much is a spender allowed to spend from a holder
    function transferFrom(address sender, address recipient, uint amount) external returns(bool);

}

contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    function transfer(address recepient, uint amount) external returns(bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recepient] += amount;
        emit Transfer(msg.sender, recepient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns(bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns(bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external  {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}