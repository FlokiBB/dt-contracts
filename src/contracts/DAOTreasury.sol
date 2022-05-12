// SPDX-License-Identifier: MIT
// Creator: DDD(DeDogma DAO)

pragma solidity ^0.8.4;

import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import './library/DTAuth.sol';
import './interfaces/ICollectiGame.sol';
import './interfaces/IDAOTreasury.sol';
import './interfaces/IGameTreasury.sol';

//Note: unlockDate, add team address, add DaoProposalFundingTransaction
contract DAOTreasury is UUPSUpgradeable, DTAuth(1), IDAOTreasury {
    uint256 public immutable START_TIME = block.timestamp;
    uint8 private constant DAO_ROLE_ID = 0;

    address public collectigame;
    address public gameTreasury;
    address public teamMultisig;
    uint256 public guaranteedFlorPrice;
    uint256 public buybackTaxRation;
    uint256 public collectigameSupply;
    uint256 public daoProposalFundingStartTime;
    bool private isSetup = false;

    struct Release {
        uint256 amountOrPercent;
        uint256 releaseDate;
        address receiver;
        bool isReleased;
    }
    mapping(uint8 => Release) public ethReleasesPlan;
    mapping(uint8 => string) public ethReleasesPlanDescription;

    event ChangeAnnouncement(address daoMultisig, address newImplementation);

    modifier OnlyCollectigame() {
        require(msg.sender == collectigame, 'Caller Is Not Collectigame');
        _;
    }
    modifier whenSetup() {
        require(isSetup, 'DAO Treasury Is Not Setup');
        _;
    }

    function initialize(
        address daoMultisig_,
        address collectigame_,
        address gameTreasury_,
        address teamMultisig_,
        uint256 buybackTaxRation_
    ) public initializer {
        address[] memory authorizedAddresses = new address[](1);
        authorizedAddresses[0] = daoMultisig_;

        uint8[] memory authorizedActors = new uint8[](1);
        authorizedActors[0] = DAO_ROLE_ID;

        init(authorizedAddresses, authorizedActors);

        collectigame = collectigame_;
        gameTreasury = gameTreasury_;
        teamMultisig = teamMultisig_;

        guaranteedFlorPrice = ICollectiGame(collectigame).MINT_PRICE_IN_WEI();
        collectigameSupply = uint256(ICollectiGame(collectigame).MAX_SUPPLY());

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
        collectigameSupply -= 1;

        _transferEth(nftOwner, buybackAmount);

        return true;
    }

    function setupReleasePlan() external virtual {
        require(!isSetup, 'Already Setup');
        uint8 releaseId = 0;

        uint256 duringMintingReleaseAmount = (collectigameSupply * guaranteedFlorPrice * 20) / 100;
        Release memory duringMintingRelease = Release(
            duringMintingReleaseAmount,
            START_TIME,
            roles[DAO_ROLE_ID].addr,
            false
        );
        ethReleasesPlan[releaseId] = duringMintingRelease;
        ethReleasesPlanDescription[releaseId] = 'Market making and bootstrapping';
        releaseId++;

        uint256 month = 3 * 30 * 24 * 60 * 60;
        for (releaseId; releaseId < 4; releaseId++) {
            uint256 releasePercent = 10;
            uint256 releaseDate = START_TIME + (3 * month) + ((releaseId - 1) * month);

            Release memory release = Release(releasePercent, releaseDate, teamMultisig, false);
            ethReleasesPlan[releaseId] = release;
            ethReleasesPlanDescription[releaseId] = 'The team';
        }

        for (releaseId; releaseId < 7; releaseId++) {
            uint256 releasePercent = 10;
            uint256 releaseDate = START_TIME + (3 * month) + ((releaseId - 1) * month);

            Release memory release = Release(releasePercent, releaseDate, roles[DAO_ROLE_ID].addr, false);
            ethReleasesPlan[releaseId] = release;
            ethReleasesPlanDescription[releaseId] = 'DDD platform expansion';
        }

        isSetup = true;
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
        uint256 numberOfGod = uint256(ICollectiGame(collectigame).NUMBER_OF_TOKEN_FOR_AUCTION());
        uint256 neededBalance = (collectigameSupply - numberOfGod) * guaranteedFlorPrice;
        uint256 treasuryBalance = getTreasuryBalance();
        require(treasuryBalance >= neededBalance, 'Treasury balance is not enough to increase guaranteed flor price');
        guaranteedFlorPrice += increaseAmount;
    }

    function releaseFund(uint8 releaseId) external virtual whenSetup {
        Release storage release = ethReleasesPlan[releaseId];
        require(!release.isReleased, 'Fund has been released');
        require(release.releaseDate <= block.timestamp, 'Release date is not reached');
        require(release.releaseDate > START_TIME, 'Release date is not reached');

        if (releaseId == 0) {
            release.isReleased = true;

            _transferEth(release.receiver, release.amountOrPercent);
        } else {
            release.isReleased = true;

            uint256 treasuryBalance = getTreasuryBalance();
            uint256 releaseAmount = (treasuryBalance * release.amountOrPercent) / 100;
            _transferEth(release.receiver, releaseAmount);
        }
    }

    function _transferEth(address to_, uint256 amount) internal virtual {
        address payable to = payable(to_);
        (bool sent, ) = to.call{value: amount}('');
        require(sent, 'Transfer Failed');
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override {
        address daoMultisig = roles[DAO_ROLE_ID].addr;
        require(msg.sender == daoMultisig, 'Unauthorized Upgrade');
        emit ChangeAnnouncement(daoMultisig, newImplementation);
    }
}
