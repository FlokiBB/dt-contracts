import { expect } from 'chai';
import { ethers } from 'hardhat';
import { NFT } from '../types';

describe('NFT', function () {
  let NFTContract: NFT;

  const maxSupply_ = 100;

  let ownerAddress: string;
  let platformMultisigAddress: string;
  let defiTitanAddress: string;
  let buyBackTreasuryContractAddress: string;
  let whiteListVerifierAddress: string;
  let royaltyDistributorAddress: string;

  const godCID_ = 'ipfs://GodCID';
  const notRevealedArtCID_ = 'ipfs://NotRevealedArtCID';

  const MintPriceInWei_ = ethers.utils.parseEther('0.05');
  const MaxMintPerAddress_ = 3;
  const AuctionStartTime_ = Date.now(); // set current epoch time
  const AuctionDuration_ = 86400 // 1 day
  const NumberOFTokenForAuction_ = 3;
  const RoyaltyFeePercent_ = 10;

  const upgradeRequestFeeInWei_ = ethers.utils.parseEther('0.01');

  const auctionConfig = [
    {
      START_PRICE: 50,
      END_PRICE: 5,
      AUCTION_DROP_INTERVAL: 1875,
      AUCTION_DROP_PER_STEP: 25,
    }, {
      START_PRICE: 5,
      END_PRICE: 2,
      AUCTION_DROP_INTERVAL: 375,
      AUCTION_DROP_PER_STEP: 125,
    }, {
      START_PRICE: 10,
      END_PRICE: 1,
      AUCTION_DROP_INTERVAL: 375,
      AUCTION_DROP_PER_STEP: 5,
  }];

  beforeEach(async () => {
    const accounts = await ethers.getSigners();
    ownerAddress = accounts[0].address;
    platformMultisigAddress = accounts[1].address;
    defiTitanAddress = accounts[2].address;
    buyBackTreasuryContractAddress = accounts[3].address;
    whiteListVerifierAddress = accounts[4].address;
    royaltyDistributorAddress = accounts[5].address;
    const Contract = await ethers.getContractFactory("NFT");
    NFTContract = (await Contract.deploy(
      maxSupply_,
      {
        OWNER: ownerAddress,
        PLATFORM: platformMultisigAddress,
        DECENTRAL_TITAN: defiTitanAddress,
        BUY_BACK_TREASURY_CONTRACT: buyBackTreasuryContractAddress,
        WHITE_LIST_VERIFIER: whiteListVerifierAddress,
        ROYALTY_DISTRIBUTOR_CONTRACT: royaltyDistributorAddress,

      },
      godCID_,
      notRevealedArtCID_,
      {
        MINT_PRICE_IN_WEI: MintPriceInWei_,
        MAX_MINT_PER_ADDRESS: MaxMintPerAddress_,
        AUCTION_START_TIME: AuctionStartTime_,
        AUCTION_DURATION: AuctionDuration_,
        NUMBER_OF_TOKEN_FOR_AUCTION: NumberOFTokenForAuction_,
        ROYALTY_FEE_PERCENT: RoyaltyFeePercent_,
      },
      upgradeRequestFeeInWei_
    )) as NFT;

    await NFTContract.initializer(auctionConfig);
  });

  // TODO: check name and symbol
  describe('#constructor', () => {
    it('should have correct max supply', async () => {
      const maxSupply = await NFTContract.MAX_SUPPLY();
      expect(maxSupply).to.equal(maxSupply_);
    });

    it('should have correct owner address', async () => {
      const OwnableOwner = await NFTContract.owner();
      const AddressesOwner = (await NFTContract.ADDRESS()).OWNER
      expect(OwnableOwner).to.equal(ownerAddress);
      expect(AddressesOwner).to.equal(ownerAddress);
    });

    it('should have correct platform multisig address', async () => {
      const platformMultisig = (await NFTContract.ADDRESS()).PLATFORM;
      expect(platformMultisig).to.equal(platformMultisigAddress);
    });

    it('should have correct defi titan address', async () => {
      const defiTitan = (await NFTContract.ADDRESS()).DECENTRAL_TITAN;
      expect(defiTitan).to.equal(defiTitanAddress);
    });

    it('should have correct buy back treasury contract address', async () => {
      const buyBackTreasuryContract = (await NFTContract.ADDRESS()).BUY_BACK_TREASURY_CONTRACT;
      expect(buyBackTreasuryContract).to.equal(buyBackTreasuryContractAddress);
    });

    it('should have correct white list verifier address', async () => {
      const whiteListVerifier = (await NFTContract.ADDRESS()).WHITE_LIST_VERIFIER;
      expect(whiteListVerifier).to.equal(whiteListVerifierAddress);
    });

    it('should have correct royalty distributor address', async () => {
      const royaltyDistributor = (await NFTContract.ADDRESS()).ROYALTY_DISTRIBUTOR_CONTRACT;
      expect(royaltyDistributor).to.equal(royaltyDistributorAddress);
    });

    it('should have correct god cid', async () => {
      const godCID = (await NFTContract.IPFS()).GOD_CID;
      expect(godCID).to.equal(godCID_);
    });

    it('should have correct not revealed art cid', async () => {
      const notRevealedArtCID = (await NFTContract.IPFS()).NOT_REVEALED_ART_CID;
      expect(notRevealedArtCID).to.equal(notRevealedArtCID_);
    });
  });

  describe('#initializer', async () => {
    it('should have correct royaltyInfo', async () => {
      const tempValue = 100;
      const tempRoyalty = 10
      const { receiver, royaltyAmount } = await NFTContract.royaltyInfo(0, tempValue);
      expect(receiver).to.equal(royaltyDistributorAddress);
      expect(royaltyAmount).to.equal(tempRoyalty);
    });
    it('the owner of the these three token should be defi titan in the first place', async () => {
      const ownerAddress: string[] = []
      for (let i = 0; i < NumberOFTokenForAuction_; i++) {
        const address = await NFTContract.ownerOf(i);
        if (!ownerAddress.includes(address as string)) {
          ownerAddress.push(address as string);
        }
      }
      expect(ownerAddress.length).to.equal(1);
      expect(ownerAddress[0]).to.equal(defiTitanAddress);
    });

    it('maxSupply should be equal to number of token in auction in this stage', async () => {
      const currentSupply = await NFTContract.totalSupply();
      const numberOfTokenInAuction = (await NFTContract.MINTING_CONFIG()).NUMBER_OF_TOKEN_FOR_AUCTION;
      expect(currentSupply).to.equal(numberOfTokenInAuction);
    });

    it('should set auction config correctly', async () => {
      for (let i = 0; i < NumberOFTokenForAuction_; i++) {
        const auction = await NFTContract.AUCTIONS(i+1);
        expect(auction.START_PRICE).to.equal(auctionConfig[i].START_PRICE);
        expect(auction.END_PRICE).to.equal(auctionConfig[i].END_PRICE);
        expect(auction.START_TIME).to.equal(AuctionStartTime_ + i * AuctionDuration_);
        expect(auction.EXPIRE_AT).to.equal(AuctionStartTime_ + (i + 1) * AuctionDuration_);
        expect(auction.TOKEN_ID).to.equal(i);
        expect(auction.IS_SOLD).to.equal(false);
        expect(auction.AUCTION_DROP_INTERVAL).to.equal(auctionConfig[i].AUCTION_DROP_INTERVAL);
        expect(auction.AUCTION_DROP_PER_STEP).to.equal(auctionConfig[i].AUCTION_DROP_PER_STEP);
      }
    });

    it('god should not be able to BuyBack theirs token ', async () => {
      const accounts = await ethers.getSigners();
      const tokenId = NumberOFTokenForAuction_ - 1;
      await expect(NFTContract.connect(accounts[2]).buyBackToken(tokenId)).to.be.revertedWith('Only Humans');
    });

    it('check currentness of tokenOfOwnerByIndex' ,async () => {
      const currentSupply = await NFTContract.totalSupply();
      expect(currentSupply).to.equal(NumberOFTokenForAuction_);
      const tokenIdByIndex = await NFTContract.tokenByIndex(NumberOFTokenForAuction_ - 1)
      expect(tokenIdByIndex).to.equal(NumberOFTokenForAuction_ - 1)
      const balance = await NFTContract.balanceOf(defiTitanAddress);
      for (let i = 0; i < balance.toNumber(); i++) {
        const tokenId = await NFTContract.tokenOfOwnerByIndex(defiTitanAddress, i);
        expect(tokenId).to.equal(i);
      }
    });

  });

  describe('#buyAGodInAuction', () => {
    // test buy in auction in normal case
    it('should buy a god in auction in normal case', async () => {
      const tokenId = 0;
      const day = tokenId + 1;
      const price = await NFTContract.getAuctionPrice(day);
      console.log(`price of token ${tokenId} is ${price}`);

    });    
    // test buy in auction when in not sold in correct time ( should belong to defi titian and not buyable)
    // test buy in auction . check currentness of the price decrement
    // check buy in auction for the day that is not coming yet
    // test buy in auction when auction is not started
    // test buy in auction when auction is ended
    // test buy in auction with not enough balance
  });

  describe('#mint', () => {
    // test white list (normal and royal)
    it('check isWhiteListed method', async () => {
      const accounts = await ethers.getSigners();
      

    });    
    // test normal mint scenario cases
    // test mint when max supply is reached
    // test mint when max mint per address is reached
    // test mint when auction is not started
    // test mint when auction is ended
    // test mint when not enough balance
  });

  describe('#burn', () => {
    // buyback 
    // god are not allowed to burn
  });

  describe('#upgrade', () => {

  });

  describe('#transfer', () => {

  });

  describe('#approve', () => {

  });

  describe('#transferFrom', () => {

  });

  describe('#setApprovalForAll', () => {

  });

  describe('#RevealArt', () => {
  });

  describe('#EIP2982', () => { });

  describe('#CustomOwnable', () => { });

  describe('#TokenURI', () => { });

  describe('#Utils', () => { 
    it('test receive and fall back', async () => {
      const accounts = await ethers.getSigners();

      // test receive 
      await expect(accounts[6].sendTransaction({
        to: NFTContract.address, 
        value: ethers.utils.parseEther('0.01'), 
        gasLimit: 5000000
      })).to.be.revertedWith('Not Allowed');

      await expect(accounts[6].sendTransaction({
        to: NFTContract.address,
        value: ethers.utils.parseEther('0.01'),
        gasLimit: 5000000,
        data: "0x0005"
      })).to.be.revertedWith('Call Valid Function');


    });    
  });

});