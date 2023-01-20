// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IFallout {
    function Fal1out() external payable;

    function collectAllocations() external;

    function allocatorBalance(address allocator)
        external
        view
        returns (uint256);
}
