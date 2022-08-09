// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "forge-std/Test.sol";

// This contract is designed to act as a time vault.
// User can deposit into this contract but cannot withdraw for atleast a week.
// User can also extend the wait time beyond the 1 week waiting period.

/*
1. Alice and bob both have 1 Ether balance
2. Deploy TimeLock Contract
3. Alice and bob both deposit 1 Ether to TimeLock, they need to wait 1 week to unlock Ether
4. Bob caused an overflow on his lockTime
5, Alice can't withdraw 1 Ether, because the lock time not expired.
6. Bob can withdraw 1 Ether, because the lockTime is overflow to 0

What happened?
Attack caused the TimeLock.lockTime to overflow,
and was able to withdraw before the 1 week waiting period.
*/

contract TimeLockContract {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease; // vulnerable
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }
}

contract TimeLockTest is Test {
    TimeLockContract timeLock;
    address alice = address(0x1);
    address bob = address(0x1);
    function setUp() public {
        timeLock = new TimeLockContract();
    }

    function testWithdraw() public {
        timeLock.deposit();
        console.log("Current balance: ", timeLock.getBalance());
    }

    // This is fuzzing function and the tools knows via the parameter time that it needs to fuzz it.
    function testfuzz(uint time)public {
        //uint256 MAX_INT = 115792089237316195423570985008687907853269984665640564039457584007913129639935
        vm.startPrank(alice); 
        TimeLockContract.deposit{value: 1 ether}();
        //console.log("Alice balance", alice.balance);
        TimeLockContract.increaseLockTime(time);
        uint lockTime = TimeLockContract.lockTime(alice);
        console.log("The Block Timestamp",block.timestamp + 1 weeks);
        require(lockTime >= block.timestamp + 1 weeks);
        vm.stopPrank();
    }

}
