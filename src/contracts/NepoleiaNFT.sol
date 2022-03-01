// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol"

contract NepoleiaNFT is ERC721A {

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
		MinigEnded
	}
	enum ArtRevealState {
		NotRevealed,
		Revealed
	}
	enum CardType {
		Human,
		God
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

  
	// ***<Modifires>***

	constructor() ERC721A("NepoleiaNFT", "NepoleiaNFT") {
		console.log("NepoleiaNFT constructor");
	}

	function mint(uint256 quantity) external payable {
		// _safeMint's second argument now takes in a quantity, not a tokenId.
		_safeMint(msg.sender, quantity);
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