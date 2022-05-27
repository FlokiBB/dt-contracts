import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers, upgrades } from "hardhat";
import { NFT, DAOTreasury, GameTreasuryV0 } from '../src/types';


let DAOMultisigAddress: SignerWithAddress;
let DecentralTitan: SignerWithAddress;
let CollectiGameOwner: SignerWithAddress; 
let WhiteListVerifier: SignerWithAddress; 
let NFTContract: NFT;
let DAOTreasuryContract: DAOTreasury;
let GameTreasuryV0Contract: GameTreasuryV0;


async function deployCollectiGame(){
    const godCID_ = 'ipfs://QmXDwhDEc1seGdaCSccrUMfPBwTx2TL22yTxNxd1UoSXVs';
    const notRevealedArtCID_ = 'ipfs://QmeEHxgXssbcN9bvYszFrHSw5YBYAtKxrA1ypzAzzFENB9';
    const afterRevealArtCID_ = 'ipfs://QmNMgz4h3NHWdy5fFGCZRgxEJzxMVKWRp3ykSsbhDRK5RE';
    const upgradeRequestFeeInWei_ = ethers.utils.parseEther('0.01');

    const Contract = await ethers.getContractFactory("NFT");
    Contract.connect(CollectiGameOwner).deploy

    NFTContract = (await Contract.connect(CollectiGameOwner).deploy(
        godCID_,
        notRevealedArtCID_,
        upgradeRequestFeeInWei_,
        CollectiGameOwner.address,
        DAOMultisigAddress.address,
        DecentralTitan.address,
    )) as NFT;

    await NFTContract.deployed();
    console.log(`NFT Contract deployed at ${NFTContract.address}`);
}

async function deployGameTreasury(){
    const GameTreasuryV0 = await ethers.getContractFactory("GameTreasuryV0");
    GameTreasuryV0Contract = (await GameTreasuryV0.deploy(
        DAOMultisigAddress.address
    )) as GameTreasuryV0;
    await GameTreasuryV0Contract.deployed();
    console.log("GameTreasuryV0 deployed to:", GameTreasuryV0Contract.address);

}

async function deployDaoTreasury(){
    const DAOTreasury = await ethers.getContractFactory("DAOTreasury");
    const buybackTaxRation = 10;

    DAOTreasuryContract = (await upgrades.deployProxy(DAOTreasury, [
        DAOMultisigAddress.address,
        NFTContract.address,
        GameTreasuryV0Contract.address,
        DecentralTitan.address,
        buybackTaxRation
    ])) as DAOTreasury; // initializer should be added in this line
    await DAOTreasuryContract.deployed();
    console.log("Box deployed to:", DAOTreasuryContract.address);
}

async function callCollectiGameInitializer(){

}
async function activateWhiteListMinting(){

}
async function activatePublicMinting(){

}

async function main() {
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
}

main();