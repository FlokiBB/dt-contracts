import { expect } from 'chai';
import { ethers } from 'hardhat';
import { NFT } from '../types';

describe('NFT', function () {
  let NFTContract: NFT;

  let ownerAddress: string;
  let platformMultisigAddress: string;
  let defiTitanAddress: string;
  let buyBackTreasuryContractAddress: string;
  let whiteListVerifierAddress: string;
  let royaltyDistributorAddress: string;

  const godCID_ = 'ipfs://QmXDwhDEc1seGdaCSccrUMfPBwTx2TL22yTxNxd1UoSXVs';
  const notRevealedArtCID_ = 'ipfs://QmeEHxgXssbcN9bvYszFrHSw5YBYAtKxrA1ypzAzzFENB9';
  const afterRevealArtCID_ = 'ipfs://QmNMgz4h3NHWdy5fFGCZRgxEJzxMVKWRp3ykSsbhDRK5RE';

  const MintPriceInWei_ = ethers.utils.parseEther('0.05');
  const AuctionDuration_ = 86400 // 1 day
  const NumberOFTokenForAuction_ = 3;
  let AuctionStartTime_: number;

  const upgradeRequestFeeInWei_ = ethers.utils.parseEther('0.01');

  // auction formula => AUCTION_DROP_PER_STEP: (START_PRICE - END_PRICE)/ (1 day in seconds(86400)) * (AUCTION_DROP_INTERVAL in seconds)
  const auctionConfig = [
    {
      startPrice: ethers.utils.parseEther('50'),
      endPrice: ethers.utils.parseEther('5'),
      auctionDropPerStep: ethers.utils.parseEther('0.3125'),
    }, {
      startPrice: ethers.utils.parseEther('5'),
      endPrice: ethers.utils.parseEther('2'),
      auctionDropPerStep: ethers.utils.parseEther('0.02083333'),
    }, {
      startPrice: ethers.utils.parseEther('10'),
      endPrice: ethers.utils.parseEther('1'),
      auctionDropPerStep: ethers.utils.parseEther('0.0625'),
    }];

  beforeEach(async () => {
    const accounts = await ethers.getSigners();
    ownerAddress = accounts[0].address;
    platformMultisigAddress = accounts[1].address;
    defiTitanAddress = accounts[2].address;
    buyBackTreasuryContractAddress = accounts[3].address;
    whiteListVerifierAddress = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
    royaltyDistributorAddress = accounts[5].address;
    const Contract = await ethers.getContractFactory("NFT");
    NFTContract = (await Contract.deploy(
      godCID_,
      notRevealedArtCID_,
      upgradeRequestFeeInWei_,
      ownerAddress,
      platformMultisigAddress,
      defiTitanAddress,
    )) as NFT;
    AuctionStartTime_ = (await ethers.provider.getBlock('latest')).timestamp;

    await NFTContract.connect(accounts[1]).initializer(auctionConfig, buyBackTreasuryContractAddress ,royaltyDistributorAddress, whiteListVerifierAddress);
  });

  // TODO: check name and symbol
  describe('#constructor', () => {
    it('should have correct max supply', async () => {
      const maxSupply = await NFTContract.MAX_SUPPLY();
      expect(maxSupply).to.equal(7777);
    });

    it('should have correct owner address', async () => {
      const OwnableOwner = await NFTContract.owner();
      expect(OwnableOwner).to.equal(ownerAddress);
    });

    it('should have correct platform multisig address', async () => {
      const platformMultisig = (await NFTContract.roles(0)).addr;
      expect(platformMultisig).to.equal(platformMultisigAddress);
    });

    it('should have correct defi titan address', async () => {
      const defiTitan = (await NFTContract.roles(1)).addr;
      expect(defiTitan).to.equal(defiTitanAddress);
    });

    it('should have correct white list verifier address', async () => {
      const whiteListVerifier = (await NFTContract.addresses()).whiteListVerifier;
      expect(whiteListVerifier).to.equal(whiteListVerifierAddress);
    });

    it('should have correct god cid', async () => {
      const godCID = (await NFTContract.ipfs()).godCID;
      expect(godCID).to.equal(godCID_);
    });

    it('should have correct not revealed art cid', async () => {
      const notRevealedArtCID = (await NFTContract.ipfs()).notRevealedArtCID;
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
      const numberOfTokenInAuction = (await NFTContract.NUMBER_OF_TOKEN_FOR_AUCTION());
      expect(currentSupply).to.equal(numberOfTokenInAuction);
    });

    it('should set auction config correctly', async () => {
      for (let i = 0; i < NumberOFTokenForAuction_; i++) {
        const auction = await NFTContract.auctions(i + 1);
        expect(auction.startPrice).to.equal(auctionConfig[i].startPrice);
        expect(auction.endPrice).to.equal(auctionConfig[i].endPrice);
        expect(auction.startAt).to.equal(AuctionStartTime_ + i * AuctionDuration_ );
        expect(auction.expireAt).to.equal(AuctionStartTime_ + (i + 1) * AuctionDuration_);
        expect(auction.tokenId).to.equal(i);
        expect(auction.isSold).to.equal(false);
        expect(await NFTContract.AUCTION_DROP_INTERVAL()).to.equal(600);
        expect(auction.auctionDropPerStep).to.equal(auctionConfig[i].auctionDropPerStep);
      }
    });

    it('god should not be able to BuyBack theirs token ', async () => {
      const accounts = await ethers.getSigners();
      const tokenId = NumberOFTokenForAuction_ - 1;
      await expect(NFTContract.connect(accounts[2]).buyBackToken(tokenId)).to.be.revertedWith('Only Humans');
    });

    it('check currentness of tokenOfOwnerByIndex', async () => {
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
    it('auction test', async () => {
      const accounts = await ethers.getSigners();
      const tokenId = 0;
      const day = tokenId + 1;
      const price = await NFTContract.getAuctionPrice(day);
      expect(price).to.equal(auctionConfig[tokenId].startPrice);
      // expect(0.1).to.be.closeTo(0.2, 0.1, 'no why fail??');

      const time = 40 * 60; // 40 minutes

      const blockNumBefore = await ethers.provider.getBlockNumber();
      const blockBefore = await ethers.provider.getBlock(blockNumBefore);
      const timestampBefore = blockBefore.timestamp;

      await ethers.provider.send('evm_increaseTime', [time]);
      await ethers.provider.send('evm_mine', []);

      const blockNumAfter = await ethers.provider.getBlockNumber();
      const blockAfter = await ethers.provider.getBlock(blockNumAfter);
      const timestampAfter = blockAfter.timestamp;

      expect(blockNumAfter).to.be.equal(blockNumBefore + 1);
      expect(timestampAfter).to.be.closeTo(timestampBefore + time, 2);

      const step = time /600;
      const calcPrice = auctionConfig[tokenId].startPrice.sub(
        auctionConfig[tokenId].auctionDropPerStep.mul(
          parseInt(step.toString())
        )
      );
      const afterPrice = await NFTContract.getAuctionPrice(day);
      expect(afterPrice).to.equal(calcPrice);

      await expect(
        NFTContract.connect(accounts[2]).buyAGodInAuction(day, { value: afterPrice.sub(1) })
      ).to.be.revertedWith('Not Enough Ether');
      
      const BalanceBefore = await ethers.provider.getBalance(accounts[2].address);
      await NFTContract.connect(accounts[11]).buyAGodInAuction(day, { value: afterPrice });
      const owner = await NFTContract.ownerOf(tokenId);
      expect(owner).to.equal(accounts[11].address);

      const BalanceAfter = await ethers.provider.getBalance(accounts[2].address);
      expect(BalanceAfter.sub(BalanceBefore)).to.equal(afterPrice);

      await expect(
        NFTContract.connect(accounts[2]).buyAGodInAuction(day, { value: afterPrice })
      ).to.be.revertedWith('Already Sold');

      await expect(
        NFTContract.connect(accounts[2]).buyAGodInAuction(day + 1)
      ).to.be.revertedWith('Not Started Yet');

      const TowDays = 2 * 24 * 60 * 60;
      await ethers.provider.send('evm_increaseTime', [TowDays]);
      await ethers.provider.send('evm_mine', []);

      await expect(
        NFTContract.connect(accounts[2]).buyAGodInAuction(day + 1)
      ).to.be.revertedWith('Expired');

      await expect(
        NFTContract.connect(accounts[2]).buyAGodInAuction(day + 11, { value: afterPrice })
      ).to.be.revertedWith('Day Is Out Of Range');

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
      const address = accounts[1].address;
      const numberOfTokenAllowToMint = 3
      // 0 for normal whitelist and 1 for royal whitelist
      const typeOfWhiteList = 0;

      const messageHash = ethers.utils.solidityKeccak256(
        ['address', 'uint8', 'uint8'],
        [address, numberOfTokenAllowToMint, typeOfWhiteList]
      );
      const messageHashBinary = ethers.utils.arrayify(messageHash);
      const wallet = new ethers.Wallet("0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e");
      const signature = await wallet.signMessage(messageHashBinary);

      const verifyOnContract = await NFTContract.isWhitelisted(address, numberOfTokenAllowToMint, typeOfWhiteList, signature);
      expect(verifyOnContract).to.equal(true);
    });

    it('normal whitelist check', async () => {
      const accounts = await ethers.getSigners();
      const address = accounts[9].address;
      const numberOfTokenAllowToMint = 3
      // 0 for normal whitelist and 1 for royal whitelist
      const typeOfWhiteList = 0;

      const messageHash = ethers.utils.solidityKeccak256(
        ['address', 'uint8', 'uint8'],
        [address, numberOfTokenAllowToMint, typeOfWhiteList]
      );
      const messageHashBinary = ethers.utils.arrayify(messageHash);
      const wallet = new ethers.Wallet("0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e");
      const signature = await wallet.signMessage(messageHashBinary);

      await expect(
        NFTContract.connect(accounts[9]).whitelistMinting(numberOfTokenAllowToMint, 2, typeOfWhiteList, signature)
      ).to.be.revertedWith('Not Activated');

      await NFTContract.connect(accounts[1]).startWhiteListMinting();

      await expect(
        NFTContract.connect(accounts[9]).whitelistMinting(numberOfTokenAllowToMint, 2, typeOfWhiteList, signature)
      ).to.be.revertedWith('Not Enoughs Ether');

      const daoTreasuryAddress = accounts[3].address;
      const OldDaoTreasuryBalance = await ethers.provider.getBalance(daoTreasuryAddress);
      const tx = await NFTContract.connect(accounts[9]).whitelistMinting(numberOfTokenAllowToMint, 2, typeOfWhiteList, signature, {
        value: ethers.utils.parseEther('0.2'),
      });
      await tx.wait();

      const balance = await NFTContract.balanceOf(accounts[9].address);
      expect(balance).to.equal(2);

      const DaoTreasuryBalance = await ethers.provider.getBalance(daoTreasuryAddress);
      expect(DaoTreasuryBalance).to.equal(ethers.utils.parseEther('0.2').add(OldDaoTreasuryBalance));

    });

    it('royal whitelist check', async () => {
      const accounts = await ethers.getSigners();
      const address = accounts[8].address;
      const numberOfTokenAllowToMint = 150
      // 0 for normal whitelist and 1 for royal whitelist
      const typeOfWhiteList = 1;

      const messageHash = ethers.utils.solidityKeccak256(
        ['address', 'uint8', 'uint8'],
        [address, numberOfTokenAllowToMint, typeOfWhiteList]
      );
      const messageHashBinary = ethers.utils.arrayify(messageHash);
      const wallet = new ethers.Wallet("0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e");
      const signature = await wallet.signMessage(messageHashBinary);
      await NFTContract.connect(accounts[1]).startWhiteListMinting();

      await expect(
        NFTContract.connect(accounts[8]).whitelistMinting(numberOfTokenAllowToMint, 160, typeOfWhiteList, signature)
      ).to.be.revertedWith('Receive To Max Quantity');

      await expect(
        NFTContract.connect(accounts[8]).whitelistMinting(240, 160, typeOfWhiteList, signature)
      ).to.be.revertedWith('Bad Signature');

      const tx = await NFTContract.connect(accounts[8]).whitelistMinting(numberOfTokenAllowToMint, 150, typeOfWhiteList, signature);
      await tx.wait();

      const balance = await NFTContract.balanceOf(accounts[8].address);
      expect(balance).to.equal(150);


    });
    // test normal mint scenario cases
    it('mint & reveal & upgrade & burn', async () => {
      const accounts = await ethers.getSigners();

      await expect(NFTContract.publicMint(4)).to.be.revertedWith('Not Activated');


      await expect(
        NFTContract.connect(accounts[1]).startPublicMinting()
      ).to.be.revertedWith('Priority Issue');

      await NFTContract.connect(accounts[1]).startWhiteListMinting();
      await NFTContract.connect(accounts[1]).startPublicMinting();

      const publicMintState = (await NFTContract.state()).mintingIsActive
      expect(publicMintState).to.equal(true);

      await expect(NFTContract.publicMint(4)).to.be.revertedWith('Receive To Max Mint Per Address');

      await expect(NFTContract.publicMint(3)).to.be.revertedWith('Not Enoughs Ether');

      const tx = await NFTContract.connect(accounts[10]).publicMint(3, {
        value: MintPriceInWei_.mul(3),
      });
      await tx.wait();

      const balance = await NFTContract.balanceOf(accounts[10].address);
      expect(balance).to.equal(3);

      await expect(NFTContract.publicMint(27000)).to.be.revertedWith('Receive To Max Supply');

      // token Uri checking
      const tokenURI = await NFTContract.tokenURI(1);
      expect(tokenURI).to.equal(godCID_.concat('/1'));

      expect((await NFTContract.state()).artIsRevealed).to.equal(false);
      const tokenURI2 = await NFTContract.tokenURI(5);
      expect(
        tokenURI2
      ).to.equal(
        notRevealedArtCID_
      );

      // test reveal art 

      await expect(
        NFTContract.connect(accounts[1]).revealArt('')
      ).to.be.revertedWith('CID Is Empty');

      await NFTContract.connect(accounts[1]).revealArt(afterRevealArtCID_);

      expect((await NFTContract.state()).artIsRevealed).to.equal(true);

      // test burn

      await expect(
        NFTContract.connect(accounts[0]).buyBackToken(10000)
      ).to.be.revertedWith('Token Not Exists');

      await expect(
        NFTContract.connect(accounts[0]).buyBackToken(1)
      ).to.be.revertedWith('Only Humans');

      await expect(
        NFTContract.connect(accounts[0]).buyBackToken(4)
      ).to.be.revertedWith('Is Not Owner');

      await NFTContract.connect(accounts[10]).buyBackToken(4);

      await expect(
        NFTContract.tokenURI(4)
      ).to.be.revertedWith('Token Not Exists');

      expect(
        (await NFTContract._ownerships(4)).burned
      ).to.be.equal(true);

      await NFTContract.connect(accounts[12]).publicMint(3, {
        value: MintPriceInWei_.mul(3),
      });

      expect(
        await NFTContract.ownerOf(7)
      ).to.be.equal(accounts[12].address);

      // test upgrade

      await expect(
        NFTContract.connect(accounts[12]).upgradeTokenRequestFee(1)
      ).to.be.revertedWith('Not Finished');

      await expect(
        NFTContract.connect(accounts[2]).finishMinting()
      ).to.be.revertedWith('caller is not authorized');

      await NFTContract.connect(accounts[1]).finishMinting()

      await expect(
        NFTContract.connect(accounts[12]).upgradeTokenRequestFee(1)
      ).to.be.revertedWith('Only Humans');

      await expect(
        NFTContract.connect(accounts[12]).upgradeTokenRequestFee(600)
      ).to.be.revertedWith('Token Not Exists');

      await expect(
        NFTContract.connect(accounts[12]).upgradeTokenRequestFee(7)
      ).to.be.revertedWith('Not Enoughs Ether');

      await NFTContract.connect(accounts[12]).upgradeTokenRequestFee(7, {
        value: upgradeRequestFeeInWei_,
      });

      expect(
        await NFTContract.upgradeRequestFeeIsPaid(7)
      ).to.be.equal(true);

      const upgradeCID = 'IPFS://QmTF2PivsUf3PQqrTAamNczxNXRR3Mj1jwJ41GaoNs3e89'
      await NFTContract.connect(accounts[1]).upgradeToken(upgradeCID, 7, false);

      await expect(
        NFTContract.connect(accounts[1]).upgradeToken(upgradeCID, 7, false)
      ).to.be.revertedWith('Upgrade Request Fee Not Paid');

      expect(
        await NFTContract.tokenURI(7)
      ).to.be.equal(upgradeCID);

      expect(
        await NFTContract.upgradeRequestFeeIsPaid(7)
      ).to.be.equal(false);

    });

  });



  describe('#transfer', () => {

  });

  describe('#approve', () => {

  });

  describe('#transferFrom', () => {

  });

  describe('#setApprovalForAll', () => {

  });

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