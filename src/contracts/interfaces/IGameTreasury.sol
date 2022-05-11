// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

interface IGameTreasury {
    function buybackTax(uint256 amount) external payable returns (bool);
}