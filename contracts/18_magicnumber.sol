// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}

/*
*********** Runtime Opcodes ***********
1. Get data (42 || 0x2a) to storage location (0x80) and store
PUSH1 0x2a -> 602a 
PUSH1 0x80 -> 6080
MSTORE     -> 52

2. Return data from storage location (0x80) as bytes32 (0x20)
PUSH1 0x20 -> 6020 
PUSH1 0x80 -> 6080
RETURN     -> f3

Runtime Opcodes = 602a60805260206080f3 

*********** Initialization Opcodes ***********
1. Copy 10 bytes runtime code (0x0a) from current position (initially unknown) to destination memory of index 0 (0x00)
PUSH1 0x0a -> 600a 
PUSH1 0x?? -> 600c (0x0c (current position) was gotten from the index where the runtime opscode starts from in the final byte code)
PUSH1 0x00 -> 6000 
CODECOPY   -> 39

2. Return the 10 bytes copied code from storage location (0x00)
PUSH1 0x20 -> 600a 
PUSH1 0x00 -> 6000
RETURN     -> f3

Initialization Opcodes = 600a600c600039600a6000f3

Solver contract bytecode = 0x + Initialization Opcodes + Runtime Opcodes
i.e 0x600a600c600039600a6000f3602a60805260206080f3

*********** Initialization Opcodes ***********
deploymentTx = await web3.eth.sendTransaction({from: yourPublicKey, data: '0x600a600c600039600a6000f3602a60805260206080f3'})
solverAddr = deploymentTx.contractaddress

using the setSolver function in the MagicNum contract set solverAddr as solver
*/

interface ISolver {
    function whatIsTheMeaningOfLife() external pure returns (uint256 result);
}

contract Test {
    function getContactSize(address contractAddress)
        public
        view
        returns (uint256 size)
    {
        assembly {
            // Set the return value to the top item on the stack
            size := extcodesize(contractAddress)
        }
    }
}
