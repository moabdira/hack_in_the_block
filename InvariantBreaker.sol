// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract InvariantBreaker {

    bool public flag0 = true;
    bool public flag1 = true;

    function set0(int val) public returns (bool){
        if (val % 100 == 0) 
            flag0 = false;
        return flag0;
    }

    function set1(int val) public returns (bool){
        if (val % 10 == 0 && !flag0) 
            flag1 = false;
        return flag1;
    }
}

contract InvariantTest is Test {
    InvariantBreaker inv;

    function setUp() public {
        inv = new InvariantBreaker();
    }

    function invariant_neverFalse() public {
        require(inv.flag1());
    }
}
