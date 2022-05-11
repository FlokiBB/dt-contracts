// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./library/DTAuth.sol";
import "./interfaces/ICollectiGame.sol";

//NOTE: buyback should only work when the collectigame contract has initialized state:
// ICollectiGame(addr).state().initialized == true
//Note: when buyback called 10% of the floor price should going the the GameTreasury Contract
//Note: buyback should have only CollectiGame modifier

contract DAOTreasury is UUPSUpgradeable, DTAuth(1) {

    address public daoMultisig;
    address public collectigame;
    uint256 public startTime;

    event ChangeAnnouncement(address daoMultisig, address newImplementation);

    function initialize(address daoMultisig_) public initializer {
        daoMultisig = daoMultisig_;
    }

    function getBalance () public view returns (uint256) {
        return address(this).balance;
    }

    function _authorizeUpgrade(address newImplementation) internal override virtual {
        require(msg.sender == daoMultisig, "Unauthorized Upgrade");
        emit ChangeAnnouncement(daoMultisig, newImplementation);
    }
    
}