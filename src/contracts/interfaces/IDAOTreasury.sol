// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

interface IDAOTreasury {
    function buybackNFT(address nftOwner) external returns (bool);
    function mintPriceDeposit(uint256 amount) external payable returns (bool);
    function gameTresuryDeposit(uint256 amount) external payable returns (bool);
}