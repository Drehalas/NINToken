// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timelock {
    address public owner;
    uint256 public unlockTime;
    bool public locked;

    event FundsUnlocked(address indexed owner, uint256 amount);

    constructor(uint256 _unlockTime) {
        owner = msg.sender;
        unlockTime = _unlockTime;
        locked = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyAfter(uint256 _time) {
        require(block.timestamp >= _time, "Function called too early");
        _;
    }

    modifier isLocked() {
        require(locked == true, "Timelock is already unlocked");
        _;
    }

    function deposit() public payable {
        // Funds can be deposited anytime
    }

    function withdraw(uint256 _amount) public onlyOwner onlyAfter(unlockTime) isLocked {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(owner).transfer(_amount);
        emit FundsUnlocked(owner, _amount);
    }

    function extendLock(uint256 _newUnlockTime) public onlyOwner {
        require(locked == true, "Timelock is already unlocked");
        unlockTime = _newUnlockTime;
    }

    function unlock() public onlyOwner {
        locked = false;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}