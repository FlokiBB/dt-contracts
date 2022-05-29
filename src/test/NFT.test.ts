import { expect } from 'chai';
import { BigNumberish } from 'ethers';
import { ethers } from 'hardhat';
import setup from './utils';
import { SetupOutput } from './utils/types';

let data: SetupOutput;
const MintPriceInWei_ = ethers.utils.parseEther('0.07');

describe('NFT', function () {

  beforeEach(async () => {
    data = await setup();
  });

  // TODO: check name and symbol
  describe('#constructor', () => {
    it('should have correct max supply', async () => {
      const maxSupply = await data.deployedContracts.NFTContract.MAX_SUPPLY();
      expect(maxSupply).to.equal(7777);
    });

    it('should have correct owner address', async () => {
      const OwnableOwner = await data.deployedContracts.NFTContract.owner();
      expect(OwnableOwner).to.equal(data.usedSinger.CollectiGameOwner.address);
    });

    it('should have correct platform multisig address', async () => {
      const platformMultisig = (await data.deployedContracts.NFTContract.roles(0)).addr;
      expect(platformMultisig).to.equal(data.usedSinger.DAOMultisigAddress.address);
    });

    it('should have correct defi titan address', async () => {
      const defiTitan = (await data.deployedContracts.NFTContract.roles(1)).addr;
      expect(defiTitan).to.equal(data.usedSinger.DecentralTitan.address);
    });

    it('should have correct white list verifier address', async () => {
      const whiteListVerifier = (await data.deployedContracts.NFTContract.getAddresses()).whiteListVerifier;
      expect(whiteListVerifier).to.equal(data.usedSinger.WhiteListVerifier.address);
    });

    // it('should have correct god cid', async () => {
    //   const godCID = (await NFTContract.ipfs()).godCID;
    //   expect(godCID).to.equal(godCID_);
    // });

    // it('should have correct not revealed art cid', async () => {
    //   const notRevealedArtCID = (await NFTContract.ipfs()).notRevealedArtCID;
    //   expect(notRevealedArtCID).to.equal(notRevealedArtCID_);
    // });
  });

  describe('#initializer', async () => {
    it('should have correct royaltyInfo', async () => {
      const tempValue = 100;
      const tempRoyalty = 10
      const { receiver, royaltyAmount } = await data.deployedContracts.NFTContract.royaltyInfo(0, tempValue);
      expect(receiver).to.equal(data.deployedContracts.GameTreasuryV0Contract.address);
      expect(royaltyAmount).to.equal(tempRoyalty);
    });
    it('the owner of the these three token should be defi titan in the first place', async () => {
      const ownerAddress: string[] = []
      for (let i = 0; i < 10; i++) {
        const address = await data.deployedContracts.NFTContract.ownerOf(i);
        if (!ownerAddress.includes(address as string)) {
          ownerAddress.push(address as string);
        }
      }
      expect(ownerAddress.length).to.equal(1);
      expect(ownerAddress[0]).to.equal(data.usedSinger.DecentralTitan.address);
    });

    it('maxSupply should be equal to number of token in auction in this stage', async () => {
      const currentSupply = await data.deployedContracts.NFTContract.totalSupply();
      const numberOfTokenInAuction = (await data.deployedContracts.NFTContract.NUMBER_OF_TOKEN_FOR_AUCTION());
      expect(currentSupply).to.equal(numberOfTokenInAuction);
    });

    it('should set auction config correctly', async () => {
      for (let i = 0; i < 10; i++) {
        const auction = await data.deployedContracts.NFTContract.auctions(i + 1);
        expect(auction.startPrice).to.equal(data.auctionConfig[i].startPrice);
        expect(auction.endPrice).to.equal(data.auctionConfig[i].endPrice);
        expect(auction.startAt).to.equal(data.auctionStartTime + i * 86400 );
        expect(auction.expireAt).to.equal(data.auctionStartTime + (i + 1) * 86400);
        expect(auction.tokenId).to.equal(i);
        expect(auction.isSold).to.equal(false);
        expect(await data.deployedContracts.NFTContract.AUCTION_DROP_INTERVAL()).to.equal(600);
        expect(auction.auctionDropPerStep).to.equal(data.auctionConfig[i].auctionDropPerStep);
      }
    });

    it('god should not be able to BuyBack theirs token ', async () => {
      const accounts = await ethers.getSigners();
      const tokenId = 10 - 1;
      await expect(data.deployedContracts.NFTContract.connect(accounts[2]).buyBackToken(tokenId)).to.be.revertedWith('Only Humans');
    });

    it('check currentness of tokenOfOwnerByIndex', async () => {
      const currentSupply = await data.deployedContracts.NFTContract.totalSupply();
      expect(currentSupply).to.equal(10);
      const tokenIdByIndex = await data.deployedContracts.NFTContract.tokenByIndex(10 - 1)
      expect(tokenIdByIndex).to.equal(10 - 1)
      const balance = await data.deployedContracts.NFTContract.balanceOf(data.usedSinger.DecentralTitan.address);
      for (let i = 0; i < balance.toNumber(); i++) {
        const tokenId = await data.deployedContracts.NFTContract.tokenOfOwnerByIndex(data.usedSinger.DecentralTitan.address, i);
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
      const price = await data.deployedContracts.NFTContract.getAuctionPrice(day);
      expect(price).to.equal(data.auctionConfig[tokenId].startPrice);
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
      const calcPrice = data.auctionConfig[tokenId].startPrice.sub(
        data.auctionConfig[tokenId].auctionDropPerStep.mul(
          parseInt(step.toString())
        )
      );
      const afterPrice = await data.deployedContracts.NFTContract.getAuctionPrice(day);
      expect(afterPrice).to.equal(calcPrice);

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[2]).buyAGodInAuction(day, { value: afterPrice.sub(1) })
      ).to.be.revertedWith('Not Enough Ether');
      
      const BalanceBefore = await ethers.provider.getBalance(accounts[11].address);
      const tx = await data.deployedContracts.NFTContract.connect(accounts[11]).buyAGodInAuction(day, { value: afterPrice });
      const gasCost = await tx.wait();
      const owner = await data.deployedContracts.NFTContract.ownerOf(tokenId);
      expect(owner).to.equal(accounts[11].address);

      const buyGodCost = afterPrice.add(gasCost.gasUsed.mul(tx.gasPrice as BigNumberish));
      const BalanceAfter = await ethers.provider.getBalance(accounts[11].address);
      expect(BalanceBefore.sub(BalanceAfter)).to.equal(buyGodCost);

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[2]).buyAGodInAuction(day, { value: afterPrice })
      ).to.be.revertedWith('Already Sold');

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[2]).buyAGodInAuction(day + 1)
      ).to.be.revertedWith('Not Started Yet');

      const TowDays = 2 * 24 * 60 * 60;
      await ethers.provider.send('evm_increaseTime', [TowDays]);
      await ethers.provider.send('evm_mine', []);

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[2]).buyAGodInAuction(day + 1)
      ).to.be.revertedWith('Expired');

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[2]).buyAGodInAuction(day + 11, { value: afterPrice })
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
      const wallet = new ethers.Wallet(data.usedSinger.WhiteListVerifierPrivKey);
      const signature = await wallet.signMessage(messageHashBinary);

      const verifyOnContract = await data.deployedContracts.NFTContract.isWhitelisted(address, numberOfTokenAllowToMint, typeOfWhiteList, signature);
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
      const wallet = new ethers.Wallet(data.usedSinger.WhiteListVerifierPrivKey);
      const signature = await wallet.signMessage(messageHashBinary);

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[9]).whitelistMinting(numberOfTokenAllowToMint, 2, typeOfWhiteList, signature)
      // ).to.be.revertedWith('Not Activated');

      // await data.deployedContracts.NFTContract.connect(accounts[1]).startWhiteListMinting();

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[9]).whitelistMinting(numberOfTokenAllowToMint, 2, typeOfWhiteList, signature)
      ).to.be.revertedWith('Not Enoughs Ether');

      const OldDaoTreasuryBalance = await ethers.provider.getBalance(data.deployedContracts.DAOTreasuryContract.address);
      const tx = await data.deployedContracts.NFTContract.connect(accounts[9]).whitelistMinting(numberOfTokenAllowToMint, 2, typeOfWhiteList, signature, {
        value: ethers.utils.parseEther('0.2'),
      });
      await tx.wait();

      const balance = await data.deployedContracts.NFTContract.balanceOf(accounts[9].address);
      expect(balance).to.equal(2);

      const DaoTreasuryBalance = await ethers.provider.getBalance(data.deployedContracts.DAOTreasuryContract.address);
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
      const wallet = new ethers.Wallet(data.usedSinger.WhiteListVerifierPrivKey);
      const signature = await wallet.signMessage(messageHashBinary);

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[8]).whitelistMinting(numberOfTokenAllowToMint, 160, typeOfWhiteList, signature)
      ).to.be.revertedWith('Receive To Max Quantity');

      await expect(
        data.deployedContracts.NFTContract.connect(accounts[8]).whitelistMinting(240, 160, typeOfWhiteList, signature)
      ).to.be.revertedWith('Bad Signature');

      const tx = await data.deployedContracts.NFTContract.connect(accounts[8]).whitelistMinting(numberOfTokenAllowToMint, 150, typeOfWhiteList, signature);
      await tx.wait();

      const balance = await data.deployedContracts.NFTContract.balanceOf(accounts[8].address);
      expect(balance).to.equal(150);


    });
    // test normal mint scenario cases
    it('mint & reveal & upgrade & burn', async () => {
      const accounts = await ethers.getSigners();

      // await expect(data.deployedContracts.NFTContract.publicMint(4)).to.be.revertedWith('Not Activated');


      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[1]).startPublicMinting()
      // ).to.be.revertedWith('Priority Issue');

      // await data.deployedContracts.NFTContract.connect(accounts[1]).startWhiteListMinting();
      // await data.deployedContracts.NFTContract.connect(accounts[1]).startPublicMinting();

      const publicMintState = (await data.deployedContracts.NFTContract.getState()).mintingIsActive
      expect(publicMintState).to.equal(true);

      await expect(data.deployedContracts.NFTContract.publicMint(4)).to.be.revertedWith('Receive To Max Mint Per Address');

      await expect(data.deployedContracts.NFTContract.publicMint(3)).to.be.revertedWith('Not Enoughs Ether');

      const tx = await data.deployedContracts.NFTContract.connect(accounts[10]).publicMint(3, {
        value: MintPriceInWei_.mul(3),
      });
      await tx.wait();

      const balance = await data.deployedContracts.NFTContract.balanceOf(accounts[10].address);
      expect(balance).to.equal(3);

      await expect(data.deployedContracts.NFTContract.publicMint(27000)).to.be.revertedWith('Receive To Max Supply');

      // token Uri checking
      const tokenURI = await data.deployedContracts.NFTContract.tokenURI(1);
      expect(tokenURI).to.equal(data.ipfsConfig.godCID.concat('/1'));

      expect((await data.deployedContracts.NFTContract.getState()).artIsRevealed).to.equal(false);
      // const tokenURI2 = await data.deployedContracts.NFTContract.tokenURI(5);
      // expect(
      //   tokenURI2
      // ).to.equal(
      //   data.ipfsConfig.notRevealedArtCID.concat('/5')
      // );

      // test reveal art 

      await expect(
        data.deployedContracts.NFTContract.connect(data.usedSinger.DAOMultisigAddress).revealArt('')
      ).to.be.revertedWith('CID Is Empty');

      await data.deployedContracts.NFTContract.connect(data.usedSinger.DAOMultisigAddress).revealArt(data.ipfsConfig.afterRevealArtCID);

      expect((await data.deployedContracts.NFTContract.getState()).artIsRevealed).to.equal(true);

      // test burn

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[0]).buyBackToken(10000)
      // ).to.be.revertedWith('Token Not Exists');

      // await expect(
      //   data.deployedContracts.NFTContract.connect(data.usedSinger.DecentralTitan).buyBackToken(1)
      // ).to.be.revertedWith('Only Humans');

      // await expect(
      //   data.deployedContracts.NFTContract.connect(data.usedSinger.DecentralTitan).buyBackToken(4)
      // ).to.be.revertedWith('Is Not Owner');

      // // await data.deployedContracts.NFTContract.connect(accounts[10]).buyBackToken(4);

      // await expect(
      //   data.deployedContracts.NFTContract.tokenURI(14)
      // ).to.be.revertedWith('Token Not Exists');

      // expect(
      //   (await data.deployedContracts.NFTContract._ownerships(4)).burned
      // ).to.be.equal(true);

      // await data.deployedContracts.NFTContract.connect(accounts[12]).publicMint(3, {
      //   value: MintPriceInWei_.mul(3),
      // });

      // expect(
      //   await data.deployedContracts.NFTContract.ownerOf(7)
      // ).to.be.equal(accounts[12].address);

      // test upgrade

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[12]).upgradeTokenRequestFee(1)
      // ).to.be.revertedWith('Not Finished');

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[2]).finishMinting()
      // ).to.be.revertedWith('caller is not authorized');

      // await data.deployedContracts.NFTContract.connect(data.usedSinger.DAOMultisigAddress).finishMinting()

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[12]).upgradeTokenRequestFee(1)
      // ).to.be.revertedWith('Only Humans');

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[12]).upgradeTokenRequestFee(600)
      // ).to.be.revertedWith('Token Not Exists');

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[12]).upgradeTokenRequestFee(7)
      // ).to.be.revertedWith('Not Enoughs Ether');

      // await data.deployedContracts.NFTContract.connect(accounts[12]).upgradeTokenRequestFee(7, {
      //   value: data.upgradeRequestFeeInWei,
      // });

      // expect(
      //   await data.deployedContracts.NFTContract.upgradeRequestFeeIsPaid(7)
      // ).to.be.equal(true);

      // const upgradeCID = 'IPFS://QmTF2PivsUf3PQqrTAamNczxNXRR3Mj1jwJ41GaoNs3e89'
      // await data.deployedContracts.NFTContract.connect(accounts[1]).upgradeToken(upgradeCID, 7, false);

      // await expect(
      //   data.deployedContracts.NFTContract.connect(accounts[1]).upgradeToken(upgradeCID, 7, false)
      // ).to.be.revertedWith('Upgrade Request Fee Not Paid');

      // expect(
      //   await data.deployedContracts.NFTContract.tokenURI(7)
      // ).to.be.equal(upgradeCID);

      // expect(
      //   await data.deployedContracts.NFTContract.upgradeRequestFeeIsPaid(7)
      // ).to.be.equal(false);

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
        to: data.deployedContracts.NFTContract.address,
        value: ethers.utils.parseEther('0.01'),
        gasLimit: 5000000
      })).to.be.revertedWith('Not Allowed');

      await expect(accounts[6].sendTransaction({
        to: data.deployedContracts.NFTContract.address,
        value: ethers.utils.parseEther('0.01'),
        gasLimit: 5000000,
        data: "0x0005"
      })).to.be.revertedWith('Call Valid Function');


    });
  });

});