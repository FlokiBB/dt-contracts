// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

interface IGameTreasury {
    function buybackTax() external payable returns (bool);
}