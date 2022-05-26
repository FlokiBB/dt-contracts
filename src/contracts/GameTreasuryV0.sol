// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;
import './library/DTAuth.sol';
import './interfaces/ICollectiGame.sol';
import './interfaces/IDAOTreasury.sol';
import './interfaces/IGameTreasury.sol';

contract GameTreasuryVo is  DTAuth(1), IGameTreasury {

    constructor(){

    }
    function buybackTax(uint256 amount) virtual override external payable returns (bool){
        return true;
    }
    function transferToV1() external {

    }

    receive() payable external{

    }

    fallback() payable external {

    }

    function getGameTreasuryBalance() public {
        
    }
}
