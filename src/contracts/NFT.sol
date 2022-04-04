// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import './DTERC721A.sol';
import './DTOwnable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

// TODO: receive and fall back
// TODO: good require message
// TODO: proper name for functions and variables
// TODO: set getter and setter for variables if needed
// ToDo: attention to eip165
// TODO: check 2982 correctness of implementation
// TODO: add NatSpec in above of the function
// TODO: add https://www.npmjs.com/package/@primitivefi/hardhat-dodoc to project
// TODO: use error instead of revert(it help to deployment cost but there is trade off)
// TODO: return remaining msg.value in mint and auction
// @audit-ok
// @audit
// TODO: this can be good to have (endAuctionAndSetupNonAuctionSaleInfo)
// TODO: set the correct name for NFT after Team Decide and change the Asci Art
// TODO: think about future and needed event in that time
contract NFT is DTERC721A, DTOwnable, ReentrancyGuard {
    using ECDSA for bytes32;

// *******************************************************************************
//           |                   |                  |                     |
//  _________|________________.=""_;=.______________|_____________________|_______
// |                   |  ,-"_,=""     `"=.|                  |
// |___________________|__"=._o`"-._        `"=.______________|___________________
//           |                `"=._o`"=._      _`"=._                     |
//  _________|_____________________:=._o "=._."_.-="'"=.__________________|_______
// |                   |    __.--" , ; `"=._o." ,-"""-._ ".   |
// |___________________|_._"  ,. .` ` `` ,  `"-._"-._   ". '__|___________________
//           |           |o`"=._` , "` `; .". ,  "-._"-._; ;              |
//  _________|___________| ;`-.o`"=._; ." ` '`."\` . "-._ /_______________|_______
// |                   | |o;    `"-.o`"=._``  '` " ,__.--o;   |
// |___________________|_| ;     (#) `-.o `"=.`_.--"_o.-; ;___|___________________
// ____/______/______/___|o;._    "      `".o|o_.--"    ;o;____/______/______/____
// /______/______/______/_"=._o--._        ; | ;        ; ;/______/______/______/_
// ____/______/______/______/__"=._o--._   ;o|o;     _._;o;____/______/______/____
// /______/______/______/______/____"=._o._; | ;_.--"o.--"_/______/______/______/_
// ____/______/______/______/______/_____"=.o|o_.--""___/______/______/______/____
// /______/______/______/______/______/______/______/______/______/______/____/___
// *******************************************************************************

    // Structs
    struct ContractState {
        bool INITIALIZED;
        bool AUCTION_IS_ACTIVE;
        bool WHITE_LIST_MINTING_IS_ACTIVE;
        bool MINTING_IS_ACTIVE;
        bool ART_IS_REVEALED;
        bool FINISHED;
    }

    struct ContractAddresses {
        address OWNER;
        address PLATFORM;
        address DECENTRAL_TITAN;
        address BUY_BACK_TREASURY_CONTRACT;
        address WHITE_LIST_VERIFIER;
        address ROYALTY_DISTRIBUTOR_CONTRACT;
    }

    struct ContractIPFS {
        string GOD_CID;
        string NOT_REVEALED_ART_CID;
        string ART_CID;
    }

    struct ContactMintConfig {
        uint256 MINT_PRICE_IN_WEI;
        uint16 MAX_MINT_PER_ADDRESS;
        uint256 AUCTION_START_TIME; // epoch time
        uint256 AUCTION_DURATION; // in seconds
        uint8 NUMBER_OF_TOKEN_FOR_AUCTION;
        uint8 ROYALTY_FEE_PERCENT;
    }

    struct AuctionConfig {
        uint256 START_PRICE; // in wei
        uint256 END_PRICE; // in wei
        uint256 AUCTION_DROP_INTERVAL; // in seconds
        uint256 AUCTION_DROP_PER_STEP; // in wei
    }
    struct Auction {
        uint8 TOKEN_ID;
        uint256 START_TIME; // epoch time
        uint256 EXPIRE_AT; // epoch time
        uint256 START_PRICE; // in wei
        uint256 END_PRICE; // in wei
        uint256 AUCTION_DROP_INTERVAL; // in seconds
        uint256 AUCTION_DROP_PER_STEP; // in wei
        bool IS_SOLD;
    }

    struct RoyaltyInfo {
        address RECIPIENT;
        uint8 PERCENT;
    }

    // Enums
    enum WhiteListType {
        NORMAL,
        ROYAL
    }

    // Events
    event UpgradeRequestPayment(uint16 _token, uint256 _value);

    // State variables
    uint16 public immutable MAX_SUPPLY;
    uint256 public UPGRADE_REQUEST_FEE_IN_WEI;
    ContractState public STATE;
    ContractAddresses public ADDRESS;
    ContractIPFS public IPFS;
    ContactMintConfig public MINTING_CONFIG;
    RoyaltyInfo private _ROYALTIES;

    // Mappings
    mapping(uint16 => bool) public TOKEN_IS_UPGRADED;
    mapping(uint16 => string) private _UPGRADED_TOKEN_CID;
    mapping(uint16 => bool) public TOKEN_IS_GOD;
    mapping(uint8 => Auction) public AUCTIONS;
    mapping(uint256 => bool) public UPGRADE_REQUEST_FEE_IS_PAID;

    // Modifires
    modifier whileAuctionIsActive() {
        require(STATE.AUCTION_IS_ACTIVE, 'Auction is not active');
        _;
    }
    modifier whileMintingIsActive() {
        require(STATE.MINTING_IS_ACTIVE, 'Minting is not active');
        _;
    }
    modifier whileWhiteListMintingIsActive() {
        require(STATE.WHITE_LIST_MINTING_IS_ACTIVE, 'WhiteListMinting is not active');
        _;
    }
    modifier whileMintingDone() {
        require(STATE.FINISHED, 'Minting is not finished');
        require(STATE.INITIALIZED, 'Contract is not initialized');
        _;
    }

    modifier onlyPlatform() {
        require(ADDRESS.PLATFORM == _msgSender(), 'Only platform address can call this function');
        _;
    }
    modifier onlyDecentralTitan() {
        require(ADDRESS.DECENTRAL_TITAN == _msgSender(), 'Only defi titan address can call this function');
        _;
    }

    modifier onlyHuman(uint16 tokenId_) {
        require(!TOKEN_IS_GOD[tokenId_], 'this function is only functional for humans');
        _;
    }

    constructor(
        uint16 maxSupply_,
        ContractAddresses memory addresses_,
        string memory godCID_,
        string memory notRevealedArtCID_,
        ContactMintConfig memory mintConfig_,
        uint256 upgradeRequestFeeInWei_
    ) DTERC721A('DemmortalTreasure', 'DT') DTOwnable(addresses_.OWNER) {
        MAX_SUPPLY = maxSupply_;
        STATE = ContractState(false, false, false, false, false, false);
        ADDRESS = addresses_;
        IPFS.GOD_CID = godCID_;
        IPFS.NOT_REVEALED_ART_CID = notRevealedArtCID_;
        MINTING_CONFIG = mintConfig_;
        UPGRADE_REQUEST_FEE_IN_WEI = upgradeRequestFeeInWei_;
    }

    // State Management related functions.
    function initializer(AuctionConfig[] calldata configs) external onlyOwner {
        require(!STATE.INITIALIZED, 'NFT: contract is already initialized');
        require(!STATE.FINISHED, 'NFT: contract is already finished');
        require(!STATE.AUCTION_IS_ACTIVE, 'NFT: auction is already active');
        STATE.INITIALIZED = true;
        _setupGodAuction(configs);
        STATE.AUCTION_IS_ACTIVE = true;

        _setRoyalties(ADDRESS.ROYALTY_DISTRIBUTOR_CONTRACT, MINTING_CONFIG.ROYALTY_FEE_PERCENT);
    }

    function revealArt(string memory ipfsCid) external onlyOwner {
        require(!STATE.ART_IS_REVEALED, 'Art is already revealed');
        uint256 len = bytes(ipfsCid).length;
        require(len > 0, 'CID is empty');
        IPFS.ART_CID = ipfsCid;
        STATE.ART_IS_REVEALED = true;
    }

    function setPlatform(address platform_) external onlyDecentralTitan {
        ADDRESS.PLATFORM = platform_;
    }

    function setBuyBackTreasury(address buyBackTreasury_) external onlyPlatform {
        ADDRESS.BUY_BACK_TREASURY_CONTRACT = buyBackTreasury_;
    }

    function setUpgradeRequestFeeInWei(uint256 upgradeRequestFeeInWei_) external onlyDecentralTitan whileMintingDone {
        UPGRADE_REQUEST_FEE_IN_WEI = upgradeRequestFeeInWei_;
    }

    function startWhiteListMinting() external onlyOwner {
        require(STATE.INITIALIZED, 'NFT: contract is not initialized');
        require(!STATE.FINISHED, 'NFT: Minting is already finished');
        require(!STATE.WHITE_LIST_MINTING_IS_ACTIVE, 'NFT: WhiteListMinting is already active');
        STATE.WHITE_LIST_MINTING_IS_ACTIVE = true;
    }

    function startPublicMinting() external onlyOwner {
        require(!STATE.FINISHED, 'NFT: Minting is already finished');
        require(!STATE.MINTING_IS_ACTIVE, 'NFT: Minting is already active');
        require(STATE.WHITE_LIST_MINTING_IS_ACTIVE, 'NFT: WhiteListMinting should active before Public Minting');
        STATE.MINTING_IS_ACTIVE = true;
    }

    function finishAuction() external onlyDecentralTitan {
        require(!STATE.FINISHED, 'NFT: Minting is already finished');
        require(STATE.INITIALIZED, 'NFT: contract is not initialized');
        require(STATE.AUCTION_IS_ACTIVE, 'NFT: Auction is not active');
        STATE.AUCTION_IS_ACTIVE = false;
    }

    function finishMinting() external onlyDecentralTitan {
        require(!STATE.FINISHED, 'NFT: Minting is already finished');
        require(STATE.MINTING_IS_ACTIVE, 'NFT: Minting is not active');
        STATE.MINTING_IS_ACTIVE = false;
        STATE.AUCTION_IS_ACTIVE = false;
        STATE.WHITE_LIST_MINTING_IS_ACTIVE = false;
        STATE.FINISHED = true;
    }

    // Auction related functions.

    function buyAGodInAuction(uint8 day) external payable whileAuctionIsActive {
        // buy god
        // require contract in the state of active auction
        require(1 <= day && day <= MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION, 'day is out of range');
        require(AUCTIONS[day].START_TIME <= block.timestamp, 'auction is not started yet');
        require(AUCTIONS[day].EXPIRE_AT >= block.timestamp, 'auction is expired');

        Auction memory auction = AUCTIONS[day];
        TokenOwnership memory ownership = ownershipOf(auction.TOKEN_ID);
        require(!auction.IS_SOLD, 'auction is already sold');
        require(ownership.addr == ADDRESS.DECENTRAL_TITAN, 'auction is not owned by Decentral Titan');

        uint256 currentPrice = _getAuctionPrice(auction);

        require(currentPrice <= auction.END_PRICE, 'auction has ended because it receive to base price');
        require(currentPrice <= msg.value, 'not enough ether');

        transferFrom(ADDRESS.DECENTRAL_TITAN, msg.sender, auction.TOKEN_ID);

        _transferEth(ADDRESS.DECENTRAL_TITAN, msg.value);
    }

    function _getAuctionPrice(Auction memory auction_) internal view returns (uint256) {
        if (block.timestamp < auction_.START_TIME) {
            return auction_.START_PRICE;
        }
        if (block.timestamp > auction_.EXPIRE_AT) {
            return auction_.END_PRICE;
        }
        uint256 elapsedTime = block.timestamp - auction_.START_TIME;
        uint256 steps = elapsedTime / auction_.AUCTION_DROP_INTERVAL;
        return auction_.START_PRICE - (steps * auction_.AUCTION_DROP_PER_STEP);
    }

    function getAuctionPrice(uint8 day) external view whileAuctionIsActive returns (uint256) {
        require(1 <= day && day <= MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION, 'day is out of range');

        Auction memory auction = AUCTIONS[day];
        return _getAuctionPrice(auction);
    }

    function _setupGodAuction(AuctionConfig[] memory configs) private {
        require(
            _totalMinted() + MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION <= MAX_SUPPLY,
            'not enough space for new auctions'
        );
        require(
            configs.length == MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION,
            'configs must be the same length as count'
        );

        _safeMint(ADDRESS.DECENTRAL_TITAN, MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION);

        // we need set first token id to the token sell in auction for CID availability.
        require(_totalMinted() == MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION, 'bad initialization of contract');

        for (uint8 i = 0; i < MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION; i++) {
            Auction memory _auction = Auction(
                i,
                MINTING_CONFIG.AUCTION_START_TIME + MINTING_CONFIG.AUCTION_DURATION * i,
                MINTING_CONFIG.AUCTION_START_TIME + MINTING_CONFIG.AUCTION_DURATION * (i + 1),
                configs[i].START_PRICE,
                configs[i].END_PRICE,
                configs[i].AUCTION_DROP_INTERVAL,
                configs[i].AUCTION_DROP_PER_STEP,
                false
            );
            AUCTIONS[i + 1] = _auction;
            _defiTitanAuctionApproval(i);
            TOKEN_IS_GOD[i] = true;
        }
    }

    function _defiTitanAuctionApproval(uint8 tokenId) private {
        TokenOwnership memory ownership = ownershipOf(tokenId);
        require(ownership.addr == ADDRESS.DECENTRAL_TITAN, 'this is work only for defi titan assets');
        _approve(address(this), tokenId, ADDRESS.DECENTRAL_TITAN);
    }

    // WhiteListMinting related functions.
    function whitelistMinting(
        address addr_,
        uint8 maxQuantity_,
        uint64 quantity_,
        WhiteListType whiteListType_,
        bytes calldata sig
    ) external payable whileWhiteListMintingIsActive {
        require(isWhitelisted(addr_, maxQuantity_, whiteListType_, sig), 'signature is not valid');
        require(_totalMinted() + quantity_ <= MAX_SUPPLY, 'Max supply is reached');

        uint64 _aux = _getAux(addr_);

        require(_aux + quantity_ <= maxQuantity_, 'Quantity is not valid');

        if (whiteListType_ == WhiteListType.ROYAL) {
            _setAux(addr_, _aux + quantity_);
            _safeMint(addr_, quantity_);
        } else {
            require(quantity_ * MINTING_CONFIG.MINT_PRICE_IN_WEI <= msg.value, 'Not enoughs ether.');
            _setAux(addr_, _aux + quantity_);
            _safeMint(addr_, quantity_);
        }
        if (msg.value > 0) {
            _transferEth(ADDRESS.BUY_BACK_TREASURY_CONTRACT, msg.value);
        }
    }

    function isWhitelisted(
        address account_,
        uint8 maxQuantity_,
        WhiteListType whiteListType_,
        bytes calldata sig_
    ) internal view returns (bool) {
        return
            ECDSA.recover(
                keccak256(abi.encodePacked(account_, maxQuantity_, whiteListType_)).toEthSignedMessageHash(),
                sig_
            ) == ADDRESS.WHITE_LIST_VERIFIER;
    }

    // Minting related functions.

    function publicMint(uint256 quantity) external payable whileMintingIsActive {
        require(
            _numberMinted(msg.sender) + quantity <= MINTING_CONFIG.MAX_MINT_PER_ADDRESS,
            'NFT: you reached the maximum number of mints per address'
        );
        require(quantity * MINTING_CONFIG.MINT_PRICE_IN_WEI <= msg.value, 'not enoughs ether');
        _safeMint(msg.sender, quantity);
        _transferEth(ADDRESS.BUY_BACK_TREASURY_CONTRACT, msg.value);
    }

    // Token Upgradeability related functions.
    function upgradeTokenRequestFee(uint16 tokenId) external payable whileMintingDone onlyHuman(tokenId) {
        require(_exists(tokenId), 'token does not exist');
        require(UPGRADE_REQUEST_FEE_IN_WEI <= msg.value, 'not enoughs ether');

        UPGRADE_REQUEST_FEE_IS_PAID[tokenId] = true;

        _transferEth(ADDRESS.PLATFORM, msg.value);
        emit UpgradeRequestPayment(tokenId, msg.value);
    }

    function upgradeToken(
        string memory ipfsCid,
        uint16 tokenId,
        bool isGodNow
    ) external whileMintingDone onlyPlatform onlyHuman(tokenId) {
        uint256 len = bytes(ipfsCid).length;
        require(len > 0, 'CID is empty');
        require(UPGRADE_REQUEST_FEE_IS_PAID[tokenId], 'upgrade fee is not paid');
        UPGRADE_REQUEST_FEE_IS_PAID[tokenId] = false;
        _UPGRADED_TOKEN_CID[tokenId] = ipfsCid;
        TOKEN_IS_UPGRADED[tokenId] = true;
        if (isGodNow) {
            TOKEN_IS_GOD[tokenId] = true;
        }
    }

    // customize Token URI
    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        require(_exists(tokenId_), 'token does not exist');

        uint16 id = uint16(tokenId_);

        if (TOKEN_IS_UPGRADED[id]) {
            return string(abi.encodePacked(_UPGRADED_TOKEN_CID[id]));
        } else if (TOKEN_IS_GOD[id]) {
            return string(abi.encodePacked(IPFS.GOD_CID, Strings.toString(id)));
        } else if (STATE.ART_IS_REVEALED) {
            return string(abi.encodePacked(IPFS.ART_CID, Strings.toString(id)));
        } else {
            return string(abi.encodePacked(IPFS.NOT_REVEALED_ART_CID, Strings.toString(id)));
        }
    }

    // Token BuyBack related functions.
    function buyBackToken(uint16 tokenId) external onlyHuman(tokenId) nonReentrant {
        require(_exists(tokenId), 'token does not exist');
        TokenOwnership memory ownership = ownershipOf(tokenId);
        require(msg.sender == ownership.addr, 'only owner of token can buy back token');
        _burn(tokenId);
        // TODO: in here we should call function from BuyBack treasury contract and give it the msg.sender
    }

    // EIP-2981 related functions.

    /// @dev Sets token royalties
    /// @param recipient recipient of the royalties
    /// @param value percentage of the royalties
    function _setRoyalties(address recipient, uint8 value) internal {
        _ROYALTIES = RoyaltyInfo(recipient, uint8(value));
    }

    function royaltyInfo(uint256, uint256 value) external view returns (address receiver, uint256 royaltyAmount) {
        receiver = _ROYALTIES.RECIPIENT;
        royaltyAmount = (value * _ROYALTIES.PERCENT) / 100;
    }

    // utility functions

    function _transferEth(address to_, uint256 amount) private {
        address payable to = payable(to_);
        (bool sent, ) = to.call{value: amount}('');
        require(sent, 'Failed to send Ether');
    }

    // ███████╗██╗░░░░░░█████╗░██╗░░██╗██╗  ██████╗░██████╗░
    // ██╔════╝██║░░░░░██╔══██╗██║░██╔╝██║  ██╔══██╗██╔══██╗
    // █████╗░░██║░░░░░██║░░██║█████═╝░██║  ██████╦╝██████╦╝
    // ██╔══╝░░██║░░░░░██║░░██║██╔═██╗░██║  ██╔══██╗██╔══██╗
    // ██║░░░░░███████╗╚█████╔╝██║░╚██╗██║  ██████╦╝██████╦╝
    // ╚═╝░░░░░╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝  ╚═════╝░╚═════╝░
}
