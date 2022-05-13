// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

interface IDAOTreasury {
    struct Release {
        uint256 amountOrPercent;
        uint256 releaseDate;
        address receiver;
        bool isReleased;
    }

    struct Proposal {
        string title;
        uint256 fundRequestAmount;
        uint256 votingStartTime;
        uint256 votingEndTime;
        address proposer;
        bool isFunded;
    }
    function buybackNFT(address nftOwner) external returns (bool);

    function mintPriceDeposit(uint256 amount) external payable returns (bool);

    function gameTresuryDeposit(uint256 amount) external payable returns (bool);
}
