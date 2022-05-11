// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

interface IGameTreasury {
    function buybackFee() external payable returns (bool);
}