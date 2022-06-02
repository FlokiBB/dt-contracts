import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers, upgrades } from "hardhat";
import { CollectigameNFT, DAOTreasury, GameTreasuryV0 } from '../../types';
import {SetupOutput, auctionConfig} from './types'
import { BigNumber } from "@ethersproject/bignumber";


let DAOMultisigAddress: SignerWithAddress;
let DecentralTitan: SignerWithAddress;
let CollectiGameOwner: SignerWithAddress;
let WhiteListVerifier: SignerWithAddress;
let NFTContract: CollectigameNFT;
let DAOTreasuryContract: DAOTreasury;
let GameTreasuryV0Contract: GameTreasuryV0;
let auctionConfig: auctionConfig[];
let godCID_: string;
let notRevealedArtCID_: string;
let afterRevealArtCID_: string;
let upgradeRequestFeeInWei_: BigNumber;
let buybackTaxRation: number;
let auctionStartTime: number;

async function deployCollectiGame() {
    godCID_ = 'ipfs://QmXDwhDEc1seGdaCSccrUMfPBwTx2TL22yTxNxd1UoSXVs';
    notRevealedArtCID_ = 'ipfs://QmeEHxgXssbcN9bvYszFrHSw5YBYAtKxrA1ypzAzzFENB9';
    afterRevealArtCID_ = 'ipfs://QmNMgz4h3NHWdy5fFGCZRgxEJzxMVKWRp3ykSsbhDRK5RE';
    upgradeRequestFeeInWei_ = ethers.utils.parseEther('0.01');

    const Contract = await ethers.getContractFactory("CollectigameNFT");
    Contract.connect(CollectiGameOwner).deploy

    NFTContract = (await Contract.connect(CollectiGameOwner).deploy(
        godCID_,
        notRevealedArtCID_,
        upgradeRequestFeeInWei_,
        CollectiGameOwner.address,
        DAOMultisigAddress.address,
        DecentralTitan.address,
    )) as CollectigameNFT;

    await NFTContract.deployed();
    const blockNum = await ethers.provider.getBlockNumber();
    const block = await ethers.provider.getBlock(blockNum);
    auctionStartTime = block.timestamp;
}

async function deployGameTreasury() {
    const GameTreasuryV0 = await ethers.getContractFactory("GameTreasuryV0");
    GameTreasuryV0Contract = (await GameTreasuryV0.deploy(
        DAOMultisigAddress.address
    )) as GameTreasuryV0;
    await GameTreasuryV0Contract.deployed();

}

async function deployDaoTreasury() {
    const DAOTreasury = await ethers.getContractFactory("DAOTreasury");
    buybackTaxRation = 10;

    DAOTreasuryContract = (await upgrades.deployProxy(DAOTreasury, [
        DAOMultisigAddress.address,
        NFTContract.address,
        GameTreasuryV0Contract.address,
        DecentralTitan.address,
        buybackTaxRation
    ])) as DAOTreasury; // initializer should be added in this line
    await DAOTreasuryContract.deployed();
}

async function callCollectiGameInitializer() {
    // auction formula => AUCTION_DROP_PER_STEP: (START_PRICE - END_PRICE)/ (1 day in seconds(86400)) * (AUCTION_DROP_INTERVAL in seconds)
    auctionConfig = [
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
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }, {
            startPrice: ethers.utils.parseEther('10'),
            endPrice: ethers.utils.parseEther('1'),
            auctionDropPerStep: ethers.utils.parseEther('0.0625'),
        }];

    await NFTContract.connect(DAOMultisigAddress).initializer(
        auctionConfig,
        DAOTreasuryContract.address,
        GameTreasuryV0Contract.address,
        WhiteListVerifier.address
    );



}
async function activateWhiteListMinting() {
    await NFTContract.connect(DAOMultisigAddress).startWhiteListMinting()
}
async function activatePublicMinting() {
    await NFTContract.connect(DAOMultisigAddress).startPublicMinting()
}

async function setupReleasePlane() {
    await DAOTreasuryContract.connect(DAOMultisigAddress).setupReleasePlan();
}
export default async function setup(): Promise<SetupOutput> {
    const accounts = await ethers.getSigners();
    DAOMultisigAddress = accounts[0]; // same with platform multisig address
    DecentralTitan = accounts[1]; // same with team multisig address
    CollectiGameOwner = accounts[2];
    WhiteListVerifier = accounts[3];

    await deployCollectiGame();
    await deployGameTreasury();
    await deployDaoTreasury();

    await callCollectiGameInitializer();
    await activateWhiteListMinting();
    await activatePublicMinting();
    await setupReleasePlane();

    return {
        usedSinger: {
            DAOMultisigAddress,
            DecentralTitan,
            CollectiGameOwner,
            WhiteListVerifier,
            WhiteListVerifierPrivKey: '0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6',
        },
        deployedContracts: {
            NFTContract,
            DAOTreasuryContract,
            GameTreasuryV0Contract,
        },
        auctionConfig,
        ipfsConfig: {
            godCID: godCID_,
            notRevealedArtCID: notRevealedArtCID_,
            afterRevealArtCID: afterRevealArtCID_,
        },
        upgradeRequestFeeInWei: upgradeRequestFeeInWei_,
        treasuryConfig: {
            buybackTaxRation,
        },
        auctionStartTime
    };
}