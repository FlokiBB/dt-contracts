// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "hardhat/console.sol";

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
	enum CardType {
		Human,
		God
	}
	enum TypeOFWhiteList {
		Normal,
		Royal
	}

	// ***<Addresses>***
	address public platform;
	address public owner;
	address payable public  defiTitan;

	// ***<Structs>***
	struct PlatformAddresses {
		address gameTreasury;
		address buyBackTreasury;
		address fundDistributor;
	}
  
	struct TokenData {
		CardType mod;
		bool upgraded;
	}

	struct GameIPFS {
		string godIPFS;
		string notRevealedHumanIPFS;
		string revealedHumanIPFS;
	}

	// ***<Mappings>***
	mapping(address => bool) private _whiteListStatus;
	mapping(uint16 => TokenData) private _tokenData;
	mapping(uint16 => string) private upgradedTokensIPFS;

	// ***<State Variables>***
	PlatformAddresses public platformAddresses;
	ArtRevealState public revealStatus;
	GameIPFS public gameIPFS;
	uint16 public totalMinted;
	uint16 public totalBurned;
	uint public publicSalePrice;
	ContractState public contractState;
	uint public mintPrice ;

  
	// ***<Modifires>***

	constructor() ERC721A("NepoleiaNFT", "NepoleiaNFT") {
		console.log("NepoleiaNFT constructor");
	}

	function mint(uint256 quantity) external payable {
		// _safeMint's second argument now takes in a quantity, not a tokenId.
		_safeMint(msg.sender, quantity);
	}


	function whitelistMinting(address addr, uint64 maxQuantity, uint64 quantity, TypeOFWhiteList typeOFWhiteList,bytes calldata sig) external payable {
		require(contractState == ContractState.WhitListMinting, "WhitListMinting state not active");
		require(_whiteListStatus[addr] != true, "whiteliste is used");
		require(isWhitelisted(addr,maxQuantity,typeOFWhiteList,sig), "signature is not valid");
		uint64 _aux = _getAux(addr);
		require(_aux + quantity <= maxQuantity, "quantity is not allowed");
		if (typeOFWhiteList == TypeOFWhiteList.Royal) {
			_safeMint(addr, quantity);
			_setAux(addr, _aux + quantity);
		} else {
			require(quauntity * mintPrice ether<= msg.value ether, "quantity is not allowed");
			_safeMint(addr, quantity);
			_setAux(addr, _aux + quantity);
		}
	}

	function isWhitelisted(address account, uint8 maxQuantity, TypeOFWhiteList typeOFWhiteList, bytes calldata sig) internal view returns (bool) {
    	return ECDSA.recover(keccak256(abi.encodePacked(account, maxQuantity, typeOFWhiteList)).toEthSignedMessageHash(), sig) == defiTitan;
  	}
	function tokenURI(uint256 tokenId) public view override returns (string memory) {
		if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

		string memory returnURI = "";
		uint16 id = uint16(tokenId);
		TokenData memory tokenData =  _tokenData[id];

		if (tokenData.upgraded == true ){
			returnURI = string(abi.encodePacked(upgradedTokensIPFS[id]));
		} else if (tokenData.mod == CardType.God) {
			returnURI = string(abi.encodePacked(gameIPFS.godIPFS, Strings.toString(id))) ;
		} else {
			string memory humanIPFS = revealStatus == ArtRevealState.NotRevealed ? gameIPFS.notRevealedHumanIPFS : gameIPFS.revealedHumanIPFS;
			returnURI = string(abi.encodePacked(humanIPFS,Strings.toString(id)));
		}

		return returnURI;
	}

	// ***<State Toggle Functions>***

	// ***<Private Functions>***

	// ***<Getter And Setter Functions>***


	// ███████╗██╗░░░░░░█████╗░██╗░░██╗██╗  ██████╗░██████╗░
	// ██╔════╝██║░░░░░██╔══██╗██║░██╔╝██║  ██╔══██╗██╔══██╗
	// █████╗░░██║░░░░░██║░░██║█████═╝░██║  ██████╦╝██████╦╝
	// ██╔══╝░░██║░░░░░██║░░██║██╔═██╗░██║  ██╔══██╗██╔══██╗
	// ██║░░░░░███████╗╚█████╔╝██║░╚██╗██║  ██████╦╝██████╦╝
	// ╚═╝░░░░░╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝  ╚═════╝░╚═════╝░
}