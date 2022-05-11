// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./library/DTAuth.sol";
import "./interfaces/ICollectiGame.sol";
import "./interfaces/IDAOTreasury.sol";

//NOTE: buyback should only work when the collectigame contract has initialized state:
// ICollectiGame(addr).state().initialized == true
//Note: when buyback called 10% of the floor price should going the the GameTreasury Contract
//Note: buyback should have only CollectiGame modifier

contract DAOTreasury is UUPSUpgradeable, DTAuth(1), IDAOTreasury {

    uint256 public immutable START_TIME = block.timestamp;
    uint8 private constant DAO_ROLE_ID = 0;


    address public daoMultisig;
    address public collectigame;
    address public gameTreasury;
    uint256 public guaranteedFlorPrice;
    bool public isSetup = false;
    uint256 public  buybackTaxRation;



    event ChangeAnnouncement(address daoMultisig, address newImplementation);

    modifier IsSetup() {
        require(isSetup, 'Not Initialized');
        _;
    }
    modifier OnlyCollectigame() {
        require(msg.sender == collectigame, 'Caller Is Not Collectigame');
        _;
    }

    function initialize(address daoMultisig_) public initializer {
        daoMultisig = daoMultisig_;

        address[] memory authorizedAddresses = new address[](1);
        authorizedAddresses[0] = daoMultisig;

        uint8[] memory authorizedActors = new uint8[](1);
        authorizedActors[0] = DAO_ROLE_ID;

        init(authorizedAddresses, authorizedActors);
    }

    function getTreasuryBalance() public view returns (uint256) {
        return address(this).balance;
    }


    function setup(address collectigame_, address gameTreasury_, uint256 buybackTaxRation_) external hasAuthorized(DAO_ROLE_ID) {
        collectigame = collectigame_;
        gameTreasury = gameTreasury_;

        guaranteedFlorPrice = ICollectiGame(collectigame).MINT_PRICE_IN_WEI();

        buybackTaxRation = buybackTaxRation_;
        isSetup = true;
    }

    function buybackNFT(address nftOwner) external override IsSetup OnlyCollectigame returns (bool) {
        ICollectiGame.ContractState memory collectigameState = ICollectiGame(collectigame).state();
        require(collectigameState.initialized == true, "CollectiGame contract has not initialized yet");

        uint256 tresuryBalance = getTreasuryBalance();
        require(tresuryBalance > guaranteedFlorPrice, "Treasury balance is not enough to buyback");

        uint256 tax = guaranteedFlorPrice * buybackTaxRation / 100;
        _transferEth(gameTreasury, tax);

        uint256 buybackAmount = guaranteedFlorPrice - tax;
        _transferEth(nftOwner, buybackAmount);

        return true;
    }
    function mintPriceDeposit(uint256 amount) external override payable returns (bool){
        require(msg.value >= amount, "Amount is not enough");
        return true;
    }
    function gameTresuryDeposit(uint256 amount) external override payable returns (bool){
        require(msg.value >= amount, "Amount is not enough");
        return true;
    }

    function setBuybackTaxRatio(uint256 buybackTaxRation_) external hasAuthorized(DAO_ROLE_ID) {
        buybackTaxRation = buybackTaxRation_;
    }




    function _transferEth(address to_, uint256 amount) private {
        address payable to = payable(to_);
        (bool sent, ) = to.call{value: amount}('');
        require(sent, 'Transfer Failed');
    }
    function _authorizeUpgrade(address newImplementation) internal override virtual {
        require(msg.sender == daoMultisig, "Unauthorized Upgrade");
        emit ChangeAnnouncement(daoMultisig, newImplementation);
    }
    
}