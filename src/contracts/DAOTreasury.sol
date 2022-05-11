// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
contract DAOTreasury is UUPSUpgradeable{

        address internal owner;
    uint256 internal length;
    uint256 internal width;
    uint256 internal height;

    function initialize(uint256 l, uint256 w, uint256 h) public initializer {
        owner = msg.sender;
        length = l;
        width = w;
        height = h;
    }

    function volume() public view returns (uint256) {
        return length * width * height;
    }

    function _authorizeUpgrade(address newImplementation) internal override virtual {
        require(msg.sender == owner, "Unauthorized Upgrade");
    }
    
}