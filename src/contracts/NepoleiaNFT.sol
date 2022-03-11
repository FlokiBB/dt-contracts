// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './ERC721A.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import 'hardhat/console.sol';

// TODO: good require message
// TODO: move row require in head of an function to proper modifier
// TODO: proper name for functions and variables
// TODO: add proper Event to functions
// TODO: set getter and setter for variables if needed
// TODO: implement maxSupply in contract
// ToDo: attention to eip165
// TODO: call _setRoyalties in initializer
contract NepoleiaNFT is ERC721A {
    using ECDSA for bytes32;

    // ███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░███████╗██╗░█████╗░
    // ████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░██╔════╝██║██╔══██╗
    // ██╔██╗██║█████╗░░██████╔╝██║░░██║██║░░░░░█████╗░░██║███████║
    // ██║╚████║██╔══╝░░██╔═══╝░██║░░██║██║░░░░░██╔══╝░░██║██╔══██║
    // ██║░╚███║███████╗██║░░░░░╚█████╔╝███████╗███████╗██║██║░░██║
    // ╚═╝░░╚══╝╚══════╝╚═╝░░░░░░╚════╝░╚══════╝╚══════╝╚═╝╚═╝░░╚═╝

    // Enums
    enum ContractState {
        Deployed,
        Initialized,
        WhitListMinting,
        PublicMinting,
        MintingEnded
    }
    enum ArtRevealState {
        NotRevealed,
        Revealed
    }
    enum TypeOFWhiteList {
        Normal,
        Royal
    }

    // ***<Addresses>***
    address public platform;
    address public owner;
    address payable public defiTitan;

    // ***<Structs>***
    struct PlatformAddresses {
        address gameTreasury;
        address buyBackTreasury;
        address fundDistributor;
    }

    // Eip2981
    struct RoyaltyInfo {
        address recipient;
        uint8 percent;
    }

    struct GameIPFS {
        string godIPFS;
        string notRevealedHumanIPFS;
        string revealedHumanIPFS;
    }

    struct GodAuctionConfig {
        uint256 startPrice;
        uint256 endPrice;
        uint256 discountRate;
    }
    struct GodAuction {
        uint8 tokenID;
        uint256 startTime;
        uint256 expiresAt;
        uint256 startPrice;
        uint256 endPrice;
        uint256 discountRate;
    }

    // ***<Mappings>***
    mapping(address => bool) private _whiteListStatus;
    mapping(uint16 => string) private upgradedTokensIPFS;
    mapping(uint16 => bool) public upgradedTokens;
    mapping(uint16 => bool) public _isGod;
    mapping(uint8 => GodAuction) public godAuctions;
    mapping(uint256 => bool) public upgradeRequestFeeIsPaid;

    // ***<State Variables>***
    PlatformAddresses public platformAddresses;
    ArtRevealState public revealStatus;
    GameIPFS public gameIPFS;
    uint256 public publicSalePrice;
    ContractState public contractState;
    uint256 public mintPrice;
    uint256 public maxMintPerAddress;
    uint256 public auctionDuration;
    uint256 public auctionStartTime;
    uint256 public upgradeRequestFee;
    RoyaltyInfo private _royalties;

    // ***<Modifires>***

    constructor() ERC721A('NepoleiaNFT', 'NepoleiaNFT') {
        console.log('NepoleiaNFT constructor');
    }

    // initializer function should run as first function after constructor
    // require onlyOwner
    function initializer() external {
        // mint gods in here and setup auctions for them
        // initial date in here
        // require not in the whitelist minting
        // _setupGodAuction(10);
    }

    // todo: add statuse to god auction struct and handle require with it
    function buyGod(uint8 day) external payable {
        // buy god
        // require contract in the state of active auction
        require(1 <= day && day <= 10, 'day must be between 1 and 10');
        require(contractState == ContractState.Initialized, 'not allowed to call');
        require(godAuctions[day].startTime <= block.timestamp, 'not allowed to call');
        require(godAuctions[day].expiresAt >= block.timestamp, 'not allowed to call');
        uint8 tokenId = day - 1;
        TokenOwnership memory ownership = ownershipOf(tokenId);
        require(ownership.addr == defiTitan, 'the token is sailed in auction');

        GodAuction memory auction = godAuctions[day];
        uint256 currentPrice = _getAuctionPrice(auction);

        require(currentPrice >= auction.endPrice, 'auction has ended because it receive to base price');
        require(currentPrice <= msg.value, 'not enough money');
        // TODO: transfer fund to defi titan in here safely (watch out reentrancy)

        transferFrom(defiTitan, msg.sender, tokenId);
        (bool sent, ) = defiTitan.call{value: msg.value}('');
        require(sent, 'Failed to send Ether');
    }

    function _getAuctionPrice(GodAuction memory auction) internal view returns (uint256) {
        // get auction price
        uint256 timeElapsed = block.timestamp - auction.startTime;
        uint256 discount = auction.discountRate * timeElapsed;
        return auction.startPrice - discount;
    }

    function getGodAuctionPrice(uint8 day) external view returns (uint256) {
        require(1 <= day && day <= 10, 'day must be between 1 and 10');
        require(contractState == ContractState.Initialized, 'not allowed to call');
        uint256 timeElapsed = block.timestamp - godAuctions[day].startTime;
        uint256 discount = godAuctions[day].discountRate * timeElapsed;
        return godAuctions[day].startPrice - discount;
    }

    function _setupGodAuction(uint256 numberOfGod, GodAuctionConfig[] memory configs) private {
        require(configs.length == numberOfGod, 'config length must be equal to number of god');
        // setup auction for god
        _safeMint(defiTitan, numberOfGod);
        // approve this contract for transferring this tokens in here

        require(_totalMinted() == numberOfGod, 'bad initialization of contract');

        for (uint8 index = 0; index < numberOfGod; index++) {
            GodAuction memory god = GodAuction(
                index,
                auctionStartTime + auctionDuration * index,
                auctionStartTime + auctionDuration * (index + 1),
                configs[index].startPrice,
                configs[index].endPrice,
                configs[index].discountRate
            );
            godAuctions[index + 1] = god;
            _defiTitanAuctionApproval(index);
        }
    }

    function _defiTitanAuctionApproval(uint8 tokenId) private {
        TokenOwnership memory ownership = ownershipOf(tokenId);
        require(ownership.addr == defiTitan, 'bad call');
        _approve(address(this), tokenId, defiTitan);
    }

    function whitelistMinting(
        address addr,
        uint8 maxQuantity,
        uint64 quantity,
        TypeOFWhiteList typeOFWhiteList,
        bytes calldata sig
    ) external payable {
        require(contractState == ContractState.WhitListMinting, 'WhitListMinting state not active');
        require(_whiteListStatus[addr] != true, 'whitelisted is used');
        require(isWhitelisted(addr, maxQuantity, typeOFWhiteList, sig), 'signature is not valid');
        uint64 _aux = _getAux(addr);
        require(_aux + quantity <= maxQuantity, 'quantity is not allowed');
        if (typeOFWhiteList == TypeOFWhiteList.Royal) {
            _setAux(addr, _aux + quantity);
            _safeMint(addr, quantity);
        } else {
            require(quantity * mintPrice <= msg.value, 'quantity is not allowed');
            _setAux(addr, _aux + quantity);
            _safeMint(addr, quantity);
        }
    }

    function isWhitelisted(
        address account,
        uint8 maxQuantity,
        TypeOFWhiteList typeOFWhiteList,
        bytes calldata sig
    ) internal view returns (bool) {
        return
            ECDSA.recover(
                keccak256(abi.encodePacked(account, maxQuantity, typeOFWhiteList)).toEthSignedMessageHash(),
                sig
            ) == defiTitan;
    }

    function publicMint(uint256 quantity) external payable {
        require(contractState == ContractState.PublicMinting, 'PublicMinting state not active');
        require(quantity <= maxMintPerAddress, 'quantity is not allowed');
        require(_numberMinted(msg.sender) <= maxMintPerAddress, 'quantity is not allowed');
        require(quantity * mintPrice <= msg.value, 'not enoughs ether');
        _safeMint(msg.sender, quantity);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory returnURI = '';
        uint16 id = uint16(tokenId);
        // TODO: set it when minting
        if (upgradedTokens[id]) {
            returnURI = string(abi.encodePacked(upgradedTokensIPFS[id]));
        } else if (_isGod[id]) {
            returnURI = string(abi.encodePacked(gameIPFS.godIPFS, Strings.toString(id)));
        } else {
            string memory humanIPFS = revealStatus == ArtRevealState.NotRevealed
                ? gameIPFS.notRevealedHumanIPFS
                : gameIPFS.revealedHumanIPFS;
            returnURI = string(abi.encodePacked(humanIPFS, Strings.toString(id)));
        }

        return returnURI;
    }

    function revealArt(string memory ipfsCid) external {
        // use only owner
        require(msg.sender == owner, 'only owner can reveal art');
        require(revealStatus == ArtRevealState.NotRevealed, 'art is already revealed');
        uint256 len = bytes(ipfsCid).length;
        require(len > 0, 'CID is empty');
        gameIPFS.revealedHumanIPFS = ipfsCid;
    }

    function upgradeTokenRequestFee(uint256 tokenId) external payable {
        require(_exists(tokenId), 'token does not exist');
        TokenOwnership memory ownership = ownershipOf(tokenId);
        require(msg.sender == ownership.addr, 'only owner of token can upgrade token');
        require(upgradeRequestFee <= msg.value, 'not enoughs ether');

        upgradeRequestFeeIsPaid[tokenId] = true;

        (bool sent, ) = payable(platform).call{value: msg.value}('');

        require(sent, 'Failed to send Ether');
        // TODO: emit a special event in here
    }

    function upgradeToken(string memory ipfsCid, uint16 tokenId) external {
        require(msg.sender == platform, 'only platform can upgrade token');
        uint256 len = bytes(ipfsCid).length;
        require(len > 0, 'CID is empty');
        require(upgradeRequestFeeIsPaid[tokenId], 'upgrade fee is not paid');
        upgradeRequestFeeIsPaid[tokenId] = false;
        upgradedTokensIPFS[tokenId] = ipfsCid;
        upgradedTokens[tokenId] = true;
        // TODO: emit proper event here
    }

    function buyBackToken(uint256 tokenId) external {
        require(tokenId > 10 , 'god are not allowed to buy back');
        require(_exists(tokenId), 'token does not exist');
        TokenOwnership memory ownership = ownershipOf(tokenId);
        require(msg.sender == ownership.addr, 'only owner of token can buy back token');
        _burn(tokenId);
        // TODO: in here we should call function from BuyBack treasury contract and give it the msg.sender
        // TODO: emit proper event here
    }

    /// @dev Sets token royalties
    /// @param recipient recipient of the royalties
    /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
    function _setRoyalties(address recipient, uint8 value) internal {
        _royalties = RoyaltyInfo(recipient, uint8(value));
    }

    function royaltyInfo(uint256, uint256 value) external view returns (address receiver, uint256 royaltyAmount) {
        RoyaltyInfo memory royalties = _royalties;
        receiver = royalties.recipient;
        royaltyAmount = (value * royalties.percent) / 100;
    }
    // ███████╗██╗░░░░░░█████╗░██╗░░██╗██╗  ██████╗░██████╗░
    // ██╔════╝██║░░░░░██╔══██╗██║░██╔╝██║  ██╔══██╗██╔══██╗
    // █████╗░░██║░░░░░██║░░██║█████═╝░██║  ██████╦╝██████╦╝
    // ██╔══╝░░██║░░░░░██║░░██║██╔═██╗░██║  ██╔══██╗██╔══██╗
    // ██║░░░░░███████╗╚█████╔╝██║░╚██╗██║  ██████╦╝██████╦╝
    // ╚═╝░░░░░╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝  ╚═════╝░╚═════╝░
}
