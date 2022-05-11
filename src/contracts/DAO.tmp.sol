// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

// TODO: think about contract deploymnet pirority and change NFT contract constructor
// TODO: write this function pausable and in future proof maner
// contract DAOTreasury {
//     uint256 public collectionSupply;
//     uint256 public MintPrice;

//     constructor()  {
//         collectionSupply = 0;
//         MintPrice = 1;
//     }

//     function daoTransfer (address _to, uint256 _value) {
//         require(_to != address(0));
//         require(_value > 0);
//         require(msg.sender.balance >= _value);
//         msg.sender.transfer(_to, _value);
//     }

//     function buyBackNFT(uint256 _id) public {
//         require(_id > 0);
//         require(collectionSupply >= _id);
//         require(MintPrice > 0);
//     }

//     releaseFundDuringMinting (uint256 _id) {
//         collectionSupply += 1;
//     }

//     // month 3,4,5
//     releaseTeamFund(){

//     }

//     // month 6,7,8
//     releaseDDDFund(){

//     }

//     depositMintPrice(uint256 _price) {
//         require(_price > 0);
//         MintPrice = _price;
//     }

//     depositeWeeklyCollectionRoyaltyShare(uint256 _amount) {
//         require(_amount > 0);
//         collectionSupply += _amount;
//     }

//     getBalance(uint256 _amount) {
//         require(_amount > 0);
//         collectionSupply += _amount;
//     }

// }
