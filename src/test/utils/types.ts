import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { NFT, DAOTreasury, GameTreasuryV0 } from '../../types';
import { BigNumber } from "@ethersproject/bignumber";

export interface auctionConfig {
    startPrice: BigNumber,
    endPrice: BigNumber,
    auctionDropPerStep: BigNumber
};

export interface SetupOutput {
    usedSinger: {
        DAOMultisigAddress: SignerWithAddress;
        DecentralTitan: SignerWithAddress;
        CollectiGameOwner: SignerWithAddress;
        WhiteListVerifier: SignerWithAddress;
        WhiteListVerifierPrivKey: string;
    };

    deployedContracts: {
        NFTContract: NFT;
        DAOTreasuryContract: DAOTreasury;
        GameTreasuryV0Contract: GameTreasuryV0;
    };

    auctionConfig: auctionConfig[]; 

    ipfsConfig: {
        godCID: string;
        notRevealedArtCID: string;
        afterRevealArtCID: string;
    };

    upgradeRequestFeeInWei: BigNumber;

    treasuryConfig: {
        buybackTaxRation: number;
    };
    auctionStartTime: number;
}