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
  const AuctionStartTime_ = 0; // set current epoch time
  const AuctionDuration_ = 86400 // 1 day
  const NumberOFTokenForAuction_ = 3;
  const RoyaltyFeePercent_ = 10;

  const upgradeRequestFeeInWei_ = ethers.utils.parseEther('0.01');

  const auctionConfig = [
    {
      startPrice: 50,
      endPrice: 5,
      discountRate: 1875,
    }, {
      startPrice: 5,
      endPrice: 2,
      discountRate: 125,
    }, {
      startPrice: 10,
      endPrice: 1,
      discountRate: 375,
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
        Owner: ownerAddress,
        Platform: platformMultisigAddress,
        DefiTitan: defiTitanAddress,
        BuyBackTreasury: buyBackTreasuryContractAddress,
        WhiteListVerifier: whiteListVerifierAddress,
        RoyaltyDistributor: royaltyDistributorAddress,

      },
      godCID_,
      notRevealedArtCID_,
      {
        MintPriceInWei: MintPriceInWei_,
        MaxMintPerAddress: MaxMintPerAddress_,
        AuctionStartTime: AuctionStartTime_,
        AuctionDuration: AuctionDuration_,
        NumberOFTokenForAuction: NumberOFTokenForAuction_,
        RoyaltyFeePercent: RoyaltyFeePercent_,
      },
      upgradeRequestFeeInWei_
    )) as NFT;
  });

  // TODO: check name and symbol
  describe('#constructor', () => {
    it('should have correct max supply', async () => {
      const maxSupply = await NFTContract.MaxSupply();
      expect(maxSupply).to.equal(maxSupply_);
    });

    it('should have correct owner address', async () => {
      const OwnableOwner = await NFTContract.owner();
      const AddressesOwner = (await NFTContract.ADDRESS()).Owner
      expect(OwnableOwner).to.equal(ownerAddress);
      expect(AddressesOwner).to.equal(ownerAddress);
    });

    it('should have correct platform multisig address', async () => {
      const platformMultisig = (await NFTContract.ADDRESS()).Platform;
      expect(platformMultisig).to.equal(platformMultisigAddress);
    });

    it('should have correct defi titan address', async () => {
      const defiTitan = (await NFTContract.ADDRESS()).DefiTitan;
      expect(defiTitan).to.equal(defiTitanAddress);
    });

    it('should have correct buy back treasury contract address', async () => {
      const buyBackTreasuryContract = (await NFTContract.ADDRESS()).BuyBackTreasury;
      expect(buyBackTreasuryContract).to.equal(buyBackTreasuryContractAddress);
    });

    it('should have correct white list verifier address', async () => {
      const whiteListVerifier = (await NFTContract.ADDRESS()).WhiteListVerifier;
      expect(whiteListVerifier).to.equal(whiteListVerifierAddress);
    });

    it('should have correct royalty distributor address', async () => {
      const royaltyDistributor = (await NFTContract.ADDRESS()).RoyaltyDistributor;
      expect(royaltyDistributor).to.equal(royaltyDistributorAddress);
    });

    it('should have correct god cid', async () => {
      const godCID = (await NFTContract.IPFS()).GodCID;
      expect(godCID).to.equal(godCID_);
    });

    it('should have correct not revealed art cid', async () => {
      const notRevealedArtCID = (await NFTContract.IPFS()).NotRevealedArtCID;
      expect(notRevealedArtCID).to.equal(notRevealedArtCID_);
    });
  });

  describe('#initializer', async () => {
    beforeEach(async () => {
      await NFTContract.initializer(auctionConfig);
    });
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
        console.log(`owner of token ${i} is ${address}`);
        if (!ownerAddress.includes(address as string)) {
          ownerAddress.push(address as string);
        }
      }
      expect(ownerAddress.length).to.equal(1);
      expect(ownerAddress[0]).to.equal(defiTitanAddress);
    });

    it('maxSupply should be equal to number of token in auction in this stage', async () => {
      const currentSupply = await NFTContract.totalSupply();
      const numberOfTokenInAuction = (await NFTContract.MINTING_CONFIG()).NumberOFTokenForAuction;
      expect(currentSupply).to.equal(numberOfTokenInAuction);
    });

  });

  describe('', () => {
    // test buy in auction in normal case
    // test buy in auction when in not sold in correct time ( should belong to defi titian and not buyable)
    // test buy in auction . check currentness of the price decrement
    // check buy in auction for the day that is not coming yet
    // test buy in auction when auction is not started
    // test buy in auction when auction is ended
    // test buy in auction with not enough balance
  });

  describe('#mint', () => {
    // test white list (normal and royal)
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
});