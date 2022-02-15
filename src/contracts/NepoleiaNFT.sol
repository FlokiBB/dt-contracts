
// ███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░███████╗██╗░█████╗░
// ████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░██╔════╝██║██╔══██╗
// ██╔██╗██║█████╗░░██████╔╝██║░░██║██║░░░░░█████╗░░██║███████║
// ██║╚████║██╔══╝░░██╔═══╝░██║░░██║██║░░░░░██╔══╝░░██║██╔══██║
// ██║░╚███║███████╗██║░░░░░╚█████╔╝███████╗███████╗██║██║░░██║
// ╚═╝░░╚══╝╚══════╝╚═╝░░░░░░╚════╝░╚══════╝╚══════╝╚═╝╚═╝░░╚═╝

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NepoleiaNFT is ERC721A {
  enum ContractState {
    Deployed,
    Initialized,
    WhitListMinting,
    PublicMinting,
    MinigEnded,
  }
  enum AuctionState {
    NotStarted,
    InProgress,
    Ended,
  }
  enum ArtRevealState {
    NotRevealed,
    Revealed,
  }
  mapping(address => bool) private whiteListStatus;
  constructor() ERC721A("NepoleiaNFT", "NepoleiaNFT") {}

  function mint(uint256 quantity) external payable {
    // _safeMint's second argument now takes in a quantity, not a tokenId.
    _safeMint(msg.sender, quantity);
  }
}

// ███████╗██╗░░░░░░█████╗░██╗░░██╗██╗██████╗░██████╗░
// ██╔════╝██║░░░░░██╔══██╗██║░██╔╝██║██╔══██╗██╔══██╗
// █████╗░░██║░░░░░██║░░██║█████═╝░██║██████╦╝██████╦╝
// ██╔══╝░░██║░░░░░██║░░██║██╔═██╗░██║██╔══██╗██╔══██╗
// ██║░░░░░███████╗╚█████╔╝██║░╚██╗██║██████╦╝██████╦╝
// ╚═╝░░░░░╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═════╝░