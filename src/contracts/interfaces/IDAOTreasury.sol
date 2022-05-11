// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

interface IDAOTreasury {
    function buybackNFT() external returns (bool);
    function mintPriceDeposit() external payable returns (bool);
    function gameTresuryDeposit() external payable returns (bool);
}