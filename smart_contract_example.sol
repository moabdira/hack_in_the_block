/**
* We are using Foundry for the blockchain and running it as local docker image: anvil - https://github.com/foundry-rs/foundry
* Example to store and retrive in the blockchain:
* 1. Run anvil - to start the blockchain
2. forge create Contract --private-key $PRIV_KEY
3. [⠆] Compiling...
    1. No files changed, compilation skipped
    2. Deployer: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
    3. Deployed to: 0x5fbdb2315678afecb367f032d93f642f64180aa3
    4. Transaction hash: 0x740c6bd4c08afa56710fec93192f22c9e43aa412b42ec91f7b2bbdef1f13aff4
4. cast call  0x5fbdb2315678afecb367f032d93f642f64180aa3 "hello():(string)"
    1. Output is in HEX = 0x0000000000000000000000000000000000000000000000000000000000000064
5. cast send --private-key=$PRIV_KEY 0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0 "sendMoney(uint256)" 100
*
* Teacher Example:
* ================
* Compile it: forge create src/Contract.sol:Contract --private-key=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
* To Store: cast send --private-key=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 0x5fc8d32690cc91d4c39d9d3abcbd16989f875707 "store(uint256)" 3
* To Retrieve: cast call 0x5fc8d32690cc91d4c39d9d3abcbd16989f875707 "getStore()(uint256)" 3
**/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    uint256 a =100;
    uint256 x;
    function hello() public view returns(uint256){
        return a;
    }

    function mult(uint256 b) public view returns(uint256){
        return a*b;
    }

    function store(uint256 c) public {
         x = c;
    }

    function getStore() public returns(uint256){
        return x;
    }
}
