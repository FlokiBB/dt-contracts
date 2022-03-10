// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './ERC721A.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import 'hardhat/console.sol';

// TODO: good requre message
// TODO: move row requre in head of an function to proper modifier
// TODO: proper name for functions and variables
// TODO: add prpoper Event to functions
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

    struct GameIPFS {
        string godIPFS;
        string notRevealedHumanIPFS;
        string revealedHumanIPFS;
    }

	struct GodAuctionConfig {
        uint256 startPrice;
        uint256 endPrice;
		uint256 godAuctionDiscountRate;
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

    // ***<Modifires>***

    constructor() ERC721A('NepoleiaNFT', 'NepoleiaNFT') {
        console.log('NepoleiaNFT constructor');
    }

    // initializer function should run as first function after constructure
    // require onlyOwner
    function initializer() external {
        // mint gods in here and setup auctions for them
        // intial date in here
        // require not in the whitlist minting
        _setupGodAuction(10);
    }

    function buyGod(uint8 day) external payable {
        // buy god
		// require contract in the state of active auction
		require(1 <= day && day <= 10, "day must be between 1 and 10");
		require(contractState == ContractState.Initialized, "not allowed to call");
		require(godAuctions[day].startTime <= block.timestamp, "not allowed to call");
		require(godAuctions[day].expiresAt >= block.timestamp, "not allowed to call");
		uint8 tokenId = day - 1;
		TokenOwnership memory Ownership = ownershipOf(tokenId);
		require(Ownership.addr == defiTitan, 'the toekn is sailed in auction');

		GodAuction auction = godAuctions[day];
		uint256 currentPrice = _getAuctionPrice(auction);

		require(currentPrice >= auction.endPrice, 'auction has endede because it recive to base price');
		require(currentPrice <= msg.value);
		// TODO: transfer fund to defi titan in here safely (whatch out reenterncy)

		(bool sent, bytes memory data) = defiTitan.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

		transferFrom(defiTitan, msg.sender, tokenId)

    }

    function _getAuctionPrice(GodAuction auction) internal pure returns (uint256) {
        // get auction price
		uint timeElapsed = block.timestamp - auction.startTime;
        uint discount = auction.discountRate * timeElapsed;
        return auction.startPrice - discount;
    }
	function getGodAuctionPrice(uint8 day) external view returns (uint256) {
		require(1 <= day && day <= 10, "day must be between 1 and 10");
		require(contractState == ContractState.Initialized, "not allowed to call");
		uint timeElapsed = block.timestamp - godAuctions[day].startTime;
        uint discount = godAuctions[day].discountRate * timeElapsed;
        return godAuctions[day].startPrice - discount;
	}


    function _setupGodAuction(uint256 numberOfGod, GodAuctionConfig[] configs) private {
		require(configs.length == numberOfGod, "config length must be equal to number of god");
        // setup auction for god
        _safeMint(defiTitan, numberOfGod);
        // aprove this contract for transfering this tokens in here

        require(_totalMinted() == numberOfGod, 'bad initialzation of contract');

        for (uint8 index = 0; index < numberOfGod; index++) {
            GodAuction god = GodAuction(
				index
                auctionStartTime + auctionDuration * index,
                auctionStartTime + auctionDuration * (index + 1),
				configs[index].startPrice,
				configs[index].endPrice,
				configs[index].discountRate
            );
            godAuctions[index+1] = god;
			_defiTitanAuctionApproval(index)
        }
    }

	function _defiTitanAuctionApproval(uint8 tokenId) private {
		TokenOwnership memory Ownership = ownershipOf(tokenId);
		require(Ownership.addr == );
		_approve(this, tokenId, defiTitan)
	}

    function whitelistMinting(
        address addr,
        uint64 maxQuantity,
        uint64 quantity,
        TypeOFWhiteList typeOFWhiteList,
        bytes calldata sig
    ) external payable {
        require(contractState == ContractState.WhitListMinting, 'WhitListMinting state not active');
        require(_whiteListStatus[addr] != true, 'whiteliste is used');
        require(isWhitelisted(addr, maxQuantity, typeOFWhiteList, sig), 'signature is not valid');
        uint64 _aux = _getAux(addr);
        require(_aux + quantity <= maxQuantity, 'quantity is not allowed');
        if (typeOFWhiteList == TypeOFWhiteList.Royal) {
            _safeMint(addr, quantity);
            _setAux(addr, _aux + quantity);
        } else {
            require(quantity * mintPrice <= msg.value, 'quantity is not allowed');
            _safeMint(addr, quantity);
            _setAux(addr, _aux + quantity);
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
        require(quantity * mintPrice <= msg.value, 'not enought ether');
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
        uint256 len = CID.length;
        require(len > 0, 'CID is empty');
        require(CID[len - 1] == '/', 'CID is not valid');
        gameIPFS.revealedHumanIPFS = ipfsCid;
    }

    // ███████╗██╗░░░░░░█████╗░██╗░░██╗██╗  ██████╗░██████╗░
    // ██╔════╝██║░░░░░██╔══██╗██║░██╔╝██║  ██╔══██╗██╔══██╗
    // █████╗░░██║░░░░░██║░░██║█████═╝░██║  ██████╦╝██████╦╝
    // ██╔══╝░░██║░░░░░██║░░██║██╔═██╗░██║  ██╔══██╗██╔══██╗
    // ██║░░░░░███████╗╚█████╔╝██║░╚██╗██║  ██████╦╝██████╦╝
    // ╚═╝░░░░░╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝  ╚═════╝░╚═════╝░
}
