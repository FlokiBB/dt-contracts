// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import './library/DTAuth.sol';
import './interfaces/ICollectiGame.sol';
import './interfaces/IDAOTreasury.sol';
import './interfaces/IGameTreasury.sol';

contract DAOTreasury is UUPSUpgradeable, DTAuth(1), IDAOTreasury {
    uint256 public immutable START_TIME = block.timestamp;
    uint8 private constant DAO_ROLE_ID = 0;

    address public daoMultisig;
    address public collectigame;
    address public gameTreasury;
    uint256 public guaranteedFlorPrice;
    uint256 public buybackTaxRation;

    event ChangeAnnouncement(address daoMultisig, address newImplementation);

    modifier OnlyCollectigame() {
        require(msg.sender == collectigame, 'Caller Is Not Collectigame');
        _;
    }

    function initialize(
        address daoMultisig_,
        address collectigame_,
        address gameTreasury_,
        uint256 buybackTaxRation_
    ) public initializer {
        daoMultisig = daoMultisig_;

        address[] memory authorizedAddresses = new address[](1);
        authorizedAddresses[0] = daoMultisig;

        uint8[] memory authorizedActors = new uint8[](1);
        authorizedActors[0] = DAO_ROLE_ID;

        init(authorizedAddresses, authorizedActors);

        collectigame = collectigame_;
        gameTreasury = gameTreasury_;

        guaranteedFlorPrice = ICollectiGame(collectigame).MINT_PRICE_IN_WEI();

        buybackTaxRation = buybackTaxRation_;
    }

    function getTreasuryBalance() public view virtual returns (uint256) {
        return address(this).balance;
    }

    function buybackNFT(address nftOwner) external virtual override OnlyCollectigame returns (bool) {
        ICollectiGame.ContractState memory collectigameState = ICollectiGame(collectigame).state();
        require(collectigameState.initialized == true, 'CollectiGame contract has not initialized yet');

        uint256 tresuryBalance = getTreasuryBalance();
        require(tresuryBalance > guaranteedFlorPrice, 'Treasury balance is not enough to buyback');

        uint256 tax = (guaranteedFlorPrice * buybackTaxRation) / 100;
        IGameTreasury(gameTreasury).buybackTax(tax);

        uint256 buybackAmount = guaranteedFlorPrice - tax;
        _transferEth(nftOwner, buybackAmount);

        return true;
    }

    function mintPriceDeposit(uint256 amount) external payable virtual override returns (bool) {
        require(msg.value >= amount, 'Amount is not enough');
        return true;
    }

    function gameTresuryDeposit(uint256 amount) external payable virtual override returns (bool) {
        require(msg.value >= amount, 'Amount is not enough');
        return true;
    }

    function setBuybackTaxRatio(uint256 buybackTaxRation_) external virtual hasAuthorized(DAO_ROLE_ID) {
        buybackTaxRation = buybackTaxRation_;
    }

    function increaseGuaranteedFlorPrice(uint256 increaseAmount) external virtual hasAuthorized(DAO_ROLE_ID) {
        uint256 maxSupply = uint256(ICollectiGame(collectigame).MAX_SUPPLY());
        uint256 numberOfGod = uint256(ICollectiGame(collectigame).NUMBER_OF_TOKEN_FOR_AUCTION());
        uint256 neededBalance = (maxSupply - numberOfGod) * guaranteedFlorPrice;
        uint256 treasuryBalance = getTreasuryBalance();
        require(treasuryBalance >= neededBalance, 'Treasury balance is not enough to increase guaranteed flor price');
        guaranteedFlorPrice += increaseAmount;
    }

    function _transferEth(address to_, uint256 amount) internal virtual {
        address payable to = payable(to_);
        (bool sent, ) = to.call{value: amount}('');
        require(sent, 'Transfer Failed');
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override {
        require(msg.sender == daoMultisig, 'Unauthorized Upgrade');
        emit ChangeAnnouncement(daoMultisig, newImplementation);
    }
}
