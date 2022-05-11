// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity 0.8.4;

// CollectiGame : Collectible + Game
// interface of NFT.sol for interacting with it from other contracts
interface ICollectiGame {
    function MAX_SUPPLY() external view returns (uint256);

    struct ContractState {
        bool initialized;
        bool auctionIsActive;
        bool whitelistMintingIsActive;
        bool mintingIsActive;
        bool artIsRevealed;
        bool finished;
    }
    function state() external view returns (ContractState memory);

    struct ContractAddresses {
        address daoTreasuryContract;
        address whiteListVerifier;
        address gameTreasuryContract;
    }
    function addresses() external view returns (ContractAddresses memory);

    function MINT_PRICE_IN_WEI() external view returns (uint256);
}