// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

import './library/DTAuth.sol';
import './interfaces/IGameTreasury.sol';


contract GameTreasuryV0 is DTAuth(1), IGameTreasury{
    bool private active = true;
    address public v1Contract;

    uint8 private constant DAO_ROLE_ID = 0;

    modifier isActive() {
        require(active, 'GameTreasuryV0 is not active');
        _;
    }

    constructor(address _daoMultisig){
        address[] memory authorizedAddresses = new address[](1);
        authorizedAddresses[0] = _daoMultisig;

        uint8[] memory authorizedActors = new uint8[](1);
        authorizedActors[0] = DAO_ROLE_ID;

        init(authorizedAddresses, authorizedActors);
    }

    receive() external payable {
        //do nothing for act as normal address on receiving ether
    }

    fallback() external payable {
        //do nothing for act as normal address on receiving ether
    }

    function buybackTax(uint256 amount) virtual override external payable isActive returns (bool){
        require(amount > msg.value, 'amount must be greater than msg.value');
        return true;
    }
    
    function setV1ContractAddress(address _v1Contract) external isActive hasAuthorized(DAO_ROLE_ID){
        require(_v1Contract != address(0), '_v1Contract is not valid');
        v1Contract = _v1Contract;
    }

    function migrateToNewVersion() override external  isActive returns (bool){
        require(msg.sender == v1Contract, 'only v1 contract can call this function');
        active = false;
        uint256 balance = gameTreasuryV0Balance();
        _transferEth(v1Contract, balance);
        return true;
    }

    function transferEthToNewVersion() external  {
        require(!active, 'GameTreasuryV0 is active');
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, 'Contract Balance is Zero');
        _transferEth(v1Contract, contractBalance);

    }


    function gameTreasuryV0Balance() public view returns (uint256){
        uint256 balance = address(this).balance;
        return balance;
    }

    function _transferEth(address to_, uint256 amount) private {
        address payable to = payable(to_);
        (bool sent, ) = to.call{value: amount}('');
        require(sent, 'Transfer Failed');
    }
}