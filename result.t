{
  "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
  "version": "2.1.0",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "Slither",
          "informationUri": "https://github.com/crytic/slither",
          "version": "0.8.2",
          "rules": [
            {
              "id": "0-1-reentrancy-eth",
              "name": "reentrancy-eth",
              "properties": {
                "precision": "high",
                "security-severity": "8.0"
              },
              "shortDescription": {
                "text": "Reentrancy vulnerabilities"
              },
              "help": {
                "text": "Apply the [`check-effects-interactions pattern`](http://solidity.readthedocs.io/en/v0.4.21/security-considerations.html#re-entrancy)."
              }
            },
            {
              "id": "1-1-divide-before-multiply",
              "name": "divide-before-multiply",
              "properties": {
                "precision": "high",
                "security-severity": "4.0"
              },
              "shortDescription": {
                "text": "Divide before multiply"
              },
              "help": {
                "text": "Consider ordering multiplication before division."
              }
            },
            {
              "id": "1-1-reentrancy-no-eth",
              "name": "reentrancy-no-eth",
              "properties": {
                "precision": "high",
                "security-severity": "4.0"
              },
              "shortDescription": {
                "text": "Reentrancy vulnerabilities"
              },
              "help": {
                "text": "Apply the [`check-effects-interactions` pattern](http://solidity.readthedocs.io/en/v0.4.21/security-considerations.html#re-entrancy)."
              }
            },
            {
              "id": "1-1-unused-return",
              "name": "unused-return",
              "properties": {
                "precision": "high",
                "security-severity": "4.0"
              },
              "shortDescription": {
                "text": "Unused return"
              },
              "help": {
                "text": "Ensure that all the return values of the function calls are used."
              }
            },
            {
              "id": "2-0-variable-scope",
              "name": "variable-scope",
              "properties": {
                "precision": "very-high",
                "security-severity": "3.0"
              },
              "shortDescription": {
                "text": "Pre-declaration usage of local variables"
              },
              "help": {
                "text": "Move all variable declarations prior to any usage of the variable, and ensure that reaching a variable declaration does not depend on some conditional if it is used unconditionally."
              }
            },
            {
              "id": "2-1-reentrancy-benign",
              "name": "reentrancy-benign",
              "properties": {
                "precision": "high",
                "security-severity": "3.0"
              },
              "shortDescription": {
                "text": "Reentrancy vulnerabilities"
              },
              "help": {
                "text": "Apply the [`check-effects-interactions` pattern](http://solidity.readthedocs.io/en/v0.4.21/security-considerations.html#re-entrancy)."
              }
            },
            {
              "id": "2-1-reentrancy-events",
              "name": "reentrancy-events",
              "properties": {
                "precision": "high",
                "security-severity": "3.0"
              },
              "shortDescription": {
                "text": "Reentrancy vulnerabilities"
              },
              "help": {
                "text": "Apply the [`check-effects-interactions` pattern](http://solidity.readthedocs.io/en/v0.4.21/security-considerations.html#re-entrancy)."
              }
            },
            {
              "id": "2-1-timestamp",
              "name": "timestamp",
              "properties": {
                "precision": "high",
                "security-severity": "3.0"
              },
              "shortDescription": {
                "text": "Block timestamp"
              },
              "help": {
                "text": "Avoid relying on `block.timestamp`."
              }
            },
            {
              "id": "3-0-assembly",
              "name": "assembly",
              "properties": {
                "precision": "very-high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Assembly usage"
              },
              "help": {
                "text": "Do not use `evm` assembly."
              }
            },
            {
              "id": "3-0-pragma",
              "name": "pragma",
              "properties": {
                "precision": "very-high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Different pragma directives are used"
              },
              "help": {
                "text": "Use one Solidity version."
              }
            },
            {
              "id": "3-1-dead-code",
              "name": "dead-code",
              "properties": {
                "precision": "high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Dead-code"
              },
              "help": {
                "text": "Remove unused functions."
              }
            },
            {
              "id": "3-0-solc-version",
              "name": "solc-version",
              "properties": {
                "precision": "very-high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Incorrect versions of Solidity"
              },
              "help": {
                "text": "\nDeploy with any of the following Solidity versions:\n- 0.5.16 - 0.5.17\n- 0.6.11 - 0.6.12\n- 0.7.5 - 0.7.6\n- 0.8.4 - 0.8.7\nUse a simple pragma version that allows any of these versions.\nConsider using the latest version of Solidity for testing."
              }
            },
            {
              "id": "3-0-low-level-calls",
              "name": "low-level-calls",
              "properties": {
                "precision": "very-high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Low-level calls"
              },
              "help": {
                "text": "Avoid low-level calls. Check the call success. If the call is meant for a contract, check for code existence."
              }
            },
            {
              "id": "3-0-naming-convention",
              "name": "naming-convention",
              "properties": {
                "precision": "very-high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Conformance to Solidity naming conventions"
              },
              "help": {
                "text": "Follow the Solidity [naming convention](https://solidity.readthedocs.io/en/v0.4.25/style-guide.html#naming-conventions)."
              }
            },
            {
              "id": "4-0-external-function",
              "name": "external-function",
              "properties": {
                "precision": "very-high",
                "security-severity": "0.0"
              },
              "shortDescription": {
                "text": "Public function that could be declared external"
              },
              "help": {
                "text": "Use the `external` attribute for functions never called from the contract."
              }
            }
          ]
        }
      },
      "results": [
        {
          "ruleId": "0-1-reentrancy-eth",
          "message": {
            "text": "Reentrancy in NFT.buyAGodInAuction(uint8) (src/contracts/NFT.sol#251-272):\n\tExternal calls:\n\t- _transferEth(ADDRESS.PLATFORM,msg.value) (src/contracts/NFT.sol#270)\n\t\t- (sent) = to.call{value: amount}() (src/contracts/NFT.sol#445)\n\tState variables written after the call(s):\n\t- AUCTIONS[day].IS_SOLD = true (src/contracts/NFT.sol#271)\n",
            "markdown": "Reentrancy in [NFT.buyAGodInAuction(uint8)](src/contracts/NFT.sol#L251-L272):\n\tExternal calls:\n\t- [_transferEth(ADDRESS.PLATFORM,msg.value)](src/contracts/NFT.sol#L270)\n\t\t- [(sent) = to.call{value: amount}()](src/contracts/NFT.sol#L445)\n\tState variables written after the call(s):\n\t- [AUCTIONS[day].IS_SOLD = true](src/contracts/NFT.sol#L271)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 251,
                  "endLine": 272
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "0023170f588be2582f22e67855e7420649111ae0d9475d970b92f7c5bf8cd315"
          }
        },
        {
          "ruleId": "1-1-divide-before-multiply",
          "message": {
            "text": "NFT._getAuctionPrice(NFT.Auction) (src/contracts/NFT.sol#274-284) performs a multiplication on the result of a division:\n\t-steps = elapsedTime / auction_.AUCTION_DROP_INTERVAL (src/contracts/NFT.sol#282)\n\t-auction_.START_PRICE - (steps * auction_.AUCTION_DROP_PER_STEP) (src/contracts/NFT.sol#283)\n",
            "markdown": "[NFT._getAuctionPrice(NFT.Auction)](src/contracts/NFT.sol#L274-L284) performs a multiplication on the result of a division:\n\t-[steps = elapsedTime / auction_.AUCTION_DROP_INTERVAL](src/contracts/NFT.sol#L282)\n\t-[auction_.START_PRICE - (steps * auction_.AUCTION_DROP_PER_STEP)](src/contracts/NFT.sol#L283)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 274,
                  "endLine": 284
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "7d421b070d59e09bc67a0d00f858deb722d43ef07f7bd4ad831c3cd03860cea8"
          }
        },
        {
          "ruleId": "1-1-reentrancy-no-eth",
          "message": {
            "text": "Reentrancy in DTERC721A._mint(address,uint256,bytes,bool) (src/contracts/DTERC721A.sol#412-451):\n\tExternal calls:\n\t- ! _checkContractOnERC721Received(address(0),to,updatedIndex ++,_data) (src/contracts/DTERC721A.sol#438)\n\t\t- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data) (src/contracts/DTERC721A.sol#635-645)\n\tState variables written after the call(s):\n\t- _currentIndex = updatedIndex (src/contracts/DTERC721A.sol#449)\n",
            "markdown": "Reentrancy in [DTERC721A._mint(address,uint256,bytes,bool)](src/contracts/DTERC721A.sol#L412-L451):\n\tExternal calls:\n\t- [! _checkContractOnERC721Received(address(0),to,updatedIndex ++,_data)](src/contracts/DTERC721A.sol#L438)\n\t\t- [IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data)](src/contracts/DTERC721A.sol#L635-L645)\n\tState variables written after the call(s):\n\t- [_currentIndex = updatedIndex](src/contracts/DTERC721A.sol#L449)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 412,
                  "endLine": 451
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "46bfdfff7901966640bcc1a109c2faa0daf571851ab8488b16acea37cb62a7b0"
          }
        },
        {
          "ruleId": "1-1-reentrancy-no-eth",
          "message": {
            "text": "Reentrancy in NFT.initializer(NFT.AuctionConfig[]) (src/contracts/NFT.sol#171-180):\n\tExternal calls:\n\t- _setupGodAuction(configs) (src/contracts/NFT.sol#176)\n\t\t- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data) (src/contracts/DTERC721A.sol#635-645)\n\tState variables written after the call(s):\n\t- STATE.AUCTION_IS_ACTIVE = true (src/contracts/NFT.sol#177)\n",
            "markdown": "Reentrancy in [NFT.initializer(NFT.AuctionConfig[])](src/contracts/NFT.sol#L171-L180):\n\tExternal calls:\n\t- [_setupGodAuction(configs)](src/contracts/NFT.sol#L176)\n\t\t- [IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data)](src/contracts/DTERC721A.sol#L635-L645)\n\tState variables written after the call(s):\n\t- [STATE.AUCTION_IS_ACTIVE = true](src/contracts/NFT.sol#L177)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 171,
                  "endLine": 180
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "79e69f7ae0a6bdceb5f59d18930f0ded7419908c2d1db647ecfe83074be2962e"
          }
        },
        {
          "ruleId": "1-1-unused-return",
          "message": {
            "text": "DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes) (src/contracts/DTERC721A.sol#629-646) ignores return value by IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data) (src/contracts/DTERC721A.sol#635-645)\n",
            "markdown": "[DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes)](src/contracts/DTERC721A.sol#L629-L646) ignores return value by [IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data)](src/contracts/DTERC721A.sol#L635-L645)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 629,
                  "endLine": 646
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "826a72c5afc0761ef687e5ab62d99e1199fbc81c4b904d2e4e628cc497c51507"
          }
        },
        {
          "ruleId": "2-0-variable-scope",
          "message": {
            "text": "Variable 'ECDSA.tryRecover(bytes32,bytes).r (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#62)' in ECDSA.tryRecover(bytes32,bytes) (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#57-86) potentially used before declaration: r = mload(uint256)(signature + 0x20) (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#79)\n",
            "markdown": "Variable '[ECDSA.tryRecover(bytes32,bytes).r](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L62)' in [ECDSA.tryRecover(bytes32,bytes)](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L57-L86) potentially used before declaration: [r = mload(uint256)(signature + 0x20)](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L79)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol"
                },
                "region": {
                  "startLine": 62,
                  "endLine": 62
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "10fadebc9594768c367651e13ad77e5290f5cff538571cfb418e4bf294f418e8"
          }
        },
        {
          "ruleId": "2-0-variable-scope",
          "message": {
            "text": "Variable 'DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes).retval (src/contracts/DTERC721A.sol#635)' in DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes) (src/contracts/DTERC721A.sol#629-646) potentially used before declaration: retval == IERC721Receiver(to).onERC721Received.selector (src/contracts/DTERC721A.sol#636)\n",
            "markdown": "Variable '[DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes).retval](src/contracts/DTERC721A.sol#L635)' in [DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes)](src/contracts/DTERC721A.sol#L629-L646) potentially used before declaration: [retval == IERC721Receiver(to).onERC721Received.selector](src/contracts/DTERC721A.sol#L636)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 635,
                  "endLine": 635
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "73c7c285a74f58b2d10c6d53defb6ac847af6b2c2b5dc8c3d1216677336b257a"
          }
        },
        {
          "ruleId": "2-0-variable-scope",
          "message": {
            "text": "Variable 'DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes).reason (src/contracts/DTERC721A.sol#637)' in DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes) (src/contracts/DTERC721A.sol#629-646) potentially used before declaration: reason.length == 0 (src/contracts/DTERC721A.sol#638)\n",
            "markdown": "Variable '[DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes).reason](src/contracts/DTERC721A.sol#L637)' in [DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes)](src/contracts/DTERC721A.sol#L629-L646) potentially used before declaration: [reason.length == 0](src/contracts/DTERC721A.sol#L638)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 637,
                  "endLine": 637
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "4d757eb925ec0bdcc8f7b7f60b8391eb0a4022efe877da52f49575327d644779"
          }
        },
        {
          "ruleId": "2-0-variable-scope",
          "message": {
            "text": "Variable 'DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes).reason (src/contracts/DTERC721A.sol#637)' in DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes) (src/contracts/DTERC721A.sol#629-646) potentially used before declaration: revert(uint256,uint256)(32 + reason,mload(uint256)(reason)) (src/contracts/DTERC721A.sol#642)\n",
            "markdown": "Variable '[DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes).reason](src/contracts/DTERC721A.sol#L637)' in [DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes)](src/contracts/DTERC721A.sol#L629-L646) potentially used before declaration: [revert(uint256,uint256)(32 + reason,mload(uint256)(reason))](src/contracts/DTERC721A.sol#L642)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 637,
                  "endLine": 637
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "ff172ef0fc2008af524bbe383e28dddbdbcb36700ca31ba18d8c7cd49aa6f8d6"
          }
        },
        {
          "ruleId": "2-1-reentrancy-benign",
          "message": {
            "text": "Reentrancy in NFT._setupGodAuction(NFT.AuctionConfig[]) (src/contracts/NFT.sol#293-316):\n\tExternal calls:\n\t- _safeMint(ADDRESS.DECENTRAL_TITAN,MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION) (src/contracts/NFT.sol#297)\n\t\t- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data) (src/contracts/DTERC721A.sol#635-645)\n\tState variables written after the call(s):\n\t- AUCTIONS[i + 1] = _auction (src/contracts/NFT.sol#313)\n\t- TOKEN_IS_GOD[i] = true (src/contracts/NFT.sol#314)\n",
            "markdown": "Reentrancy in [NFT._setupGodAuction(NFT.AuctionConfig[])](src/contracts/NFT.sol#L293-L316):\n\tExternal calls:\n\t- [_safeMint(ADDRESS.DECENTRAL_TITAN,MINTING_CONFIG.NUMBER_OF_TOKEN_FOR_AUCTION)](src/contracts/NFT.sol#L297)\n\t\t- [IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data)](src/contracts/DTERC721A.sol#L635-L645)\n\tState variables written after the call(s):\n\t- [AUCTIONS[i + 1] = _auction](src/contracts/NFT.sol#L313)\n\t- [TOKEN_IS_GOD[i] = true](src/contracts/NFT.sol#L314)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 293,
                  "endLine": 316
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "745321adcf6ba9ab75c6ee1b045af27cabbd91d744da8c50cdbdb09c9ff2731d"
          }
        },
        {
          "ruleId": "2-1-reentrancy-benign",
          "message": {
            "text": "Reentrancy in NFT.initializer(NFT.AuctionConfig[]) (src/contracts/NFT.sol#171-180):\n\tExternal calls:\n\t- _setupGodAuction(configs) (src/contracts/NFT.sol#176)\n\t\t- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data) (src/contracts/DTERC721A.sol#635-645)\n\tState variables written after the call(s):\n\t- _setRoyalties(ADDRESS.ROYALTY_DISTRIBUTOR_CONTRACT,MINTING_CONFIG.ROYALTY_FEE_PERCENT) (src/contracts/NFT.sol#179)\n\t\t- _ROYALTIES = RoyaltyInfo(recipient,uint8(value)) (src/contracts/NFT.sol#428)\n",
            "markdown": "Reentrancy in [NFT.initializer(NFT.AuctionConfig[])](src/contracts/NFT.sol#L171-L180):\n\tExternal calls:\n\t- [_setupGodAuction(configs)](src/contracts/NFT.sol#L176)\n\t\t- [IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,_data)](src/contracts/DTERC721A.sol#L635-L645)\n\tState variables written after the call(s):\n\t- [_setRoyalties(ADDRESS.ROYALTY_DISTRIBUTOR_CONTRACT,MINTING_CONFIG.ROYALTY_FEE_PERCENT)](src/contracts/NFT.sol#L179)\n\t\t- [_ROYALTIES = RoyaltyInfo(recipient,uint8(value))](src/contracts/NFT.sol#L428)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 171,
                  "endLine": 180
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "0a05de5c361a25058f7ce4d94afd26385364142c31a69115477b38272f053c23"
          }
        },
        {
          "ruleId": "2-1-reentrancy-events",
          "message": {
            "text": "Reentrancy in NFT.upgradeTokenRequestFee(uint16) (src/contracts/NFT.sol#373-381):\n\tExternal calls:\n\t- _transferEth(ADDRESS.PLATFORM,msg.value) (src/contracts/NFT.sol#379)\n\t\t- (sent) = to.call{value: amount}() (src/contracts/NFT.sol#445)\n\tEvent emitted after the call(s):\n\t- UpgradeRequestPayment(tokenId,msg.value) (src/contracts/NFT.sol#380)\n",
            "markdown": "Reentrancy in [NFT.upgradeTokenRequestFee(uint16)](src/contracts/NFT.sol#L373-L381):\n\tExternal calls:\n\t- [_transferEth(ADDRESS.PLATFORM,msg.value)](src/contracts/NFT.sol#L379)\n\t\t- [(sent) = to.call{value: amount}()](src/contracts/NFT.sol#L445)\n\tEvent emitted after the call(s):\n\t- [UpgradeRequestPayment(tokenId,msg.value)](src/contracts/NFT.sol#L380)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 373,
                  "endLine": 381
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "6358b2c53224f90cb9c6cc3351cfc5e8afdf5b1927425785598196ef803b0707"
          }
        },
        {
          "ruleId": "2-1-timestamp",
          "message": {
            "text": "NFT.buyAGodInAuction(uint8) (src/contracts/NFT.sol#251-272) uses timestamp for comparisons\n\tDangerous comparisons:\n\t- require(bool,string)(AUCTIONS[day].START_TIME <= block.timestamp,Not Started Yet) (src/contracts/NFT.sol#255)\n\t- require(bool,string)(AUCTIONS[day].EXPIRE_AT >= block.timestamp,Expired) (src/contracts/NFT.sol#256)\n\t- require(bool,string)(auction.END_PRICE <= currentPrice,Receive To Base Price) (src/contracts/NFT.sol#265)\n\t- require(bool,string)(currentPrice <= msg.value,Not Enough Ether) (src/contracts/NFT.sol#266)\n",
            "markdown": "[NFT.buyAGodInAuction(uint8)](src/contracts/NFT.sol#L251-L272) uses timestamp for comparisons\n\tDangerous comparisons:\n\t- [require(bool,string)(AUCTIONS[day].START_TIME <= block.timestamp,Not Started Yet)](src/contracts/NFT.sol#L255)\n\t- [require(bool,string)(AUCTIONS[day].EXPIRE_AT >= block.timestamp,Expired)](src/contracts/NFT.sol#L256)\n\t- [require(bool,string)(auction.END_PRICE <= currentPrice,Receive To Base Price)](src/contracts/NFT.sol#L265)\n\t- [require(bool,string)(currentPrice <= msg.value,Not Enough Ether)](src/contracts/NFT.sol#L266)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 251,
                  "endLine": 272
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "5063148edc89206b20f15ec442b3f72d8fb14559f982a180ff3bce8183d6043a"
          }
        },
        {
          "ruleId": "2-1-timestamp",
          "message": {
            "text": "NFT._getAuctionPrice(NFT.Auction) (src/contracts/NFT.sol#274-284) uses timestamp for comparisons\n\tDangerous comparisons:\n\t- block.timestamp < auction_.START_TIME (src/contracts/NFT.sol#275)\n\t- block.timestamp > auction_.EXPIRE_AT (src/contracts/NFT.sol#278)\n",
            "markdown": "[NFT._getAuctionPrice(NFT.Auction)](src/contracts/NFT.sol#L274-L284) uses timestamp for comparisons\n\tDangerous comparisons:\n\t- [block.timestamp < auction_.START_TIME](src/contracts/NFT.sol#L275)\n\t- [block.timestamp > auction_.EXPIRE_AT](src/contracts/NFT.sol#L278)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 274,
                  "endLine": 284
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "782e1bac69867715b9ea776745787e20767db47721993d5e1d1eeede491ceacd"
          }
        },
        {
          "ruleId": "3-0-assembly",
          "message": {
            "text": "Address.verifyCallResult(bool,bytes,string) (node_modules/@openzeppelin/contracts/utils/Address.sol#201-221) uses assembly\n\t- INLINE ASM (node_modules/@openzeppelin/contracts/utils/Address.sol#213-216)\n",
            "markdown": "[Address.verifyCallResult(bool,bytes,string)](node_modules/@openzeppelin/contracts/utils/Address.sol#L201-L221) uses assembly\n\t- [INLINE ASM](node_modules/@openzeppelin/contracts/utils/Address.sol#L213-L216)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Address.sol"
                },
                "region": {
                  "startLine": 201,
                  "endLine": 221
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "35871747c525efe5aeed3ee6e6ac7d19de1404d80cba7ebe954161c30eced4d8"
          }
        },
        {
          "ruleId": "3-0-assembly",
          "message": {
            "text": "ECDSA.tryRecover(bytes32,bytes) (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#57-86) uses assembly\n\t- INLINE ASM (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#67-71)\n\t- INLINE ASM (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#78-81)\n",
            "markdown": "[ECDSA.tryRecover(bytes32,bytes)](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L57-L86) uses assembly\n\t- [INLINE ASM](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L67-L71)\n\t- [INLINE ASM](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L78-L81)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol"
                },
                "region": {
                  "startLine": 57,
                  "endLine": 86
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "5bf401391a7793d738dd1fd7b6a6db3d4525d9e4e2dcb06655423667db0fde11"
          }
        },
        {
          "ruleId": "3-0-assembly",
          "message": {
            "text": "DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes) (src/contracts/DTERC721A.sol#629-646) uses assembly\n\t- INLINE ASM (src/contracts/DTERC721A.sol#641-643)\n",
            "markdown": "[DTERC721A._checkContractOnERC721Received(address,address,uint256,bytes)](src/contracts/DTERC721A.sol#L629-L646) uses assembly\n\t- [INLINE ASM](src/contracts/DTERC721A.sol#L641-L643)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 629,
                  "endLine": 646
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "e8c8343a1d06f8f442129844b8cdefebc3c22b6e48c4791ffbed31fffbf8e68c"
          }
        },
        {
          "ruleId": "3-0-pragma",
          "message": {
            "text": "Different versions of Solidity is used:\n\t- Version used: ['^0.8.0', '^0.8.1', '^0.8.4']\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#4)\n\t- ^0.8.1 (node_modules/@openzeppelin/contracts/utils/Address.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/utils/Context.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/utils/Strings.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol#4)\n\t- ^0.8.0 (node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol#4)\n\t- ^0.8.4 (src/contracts/DTERC721A.sol#4)\n\t- ^0.8.4 (src/contracts/DTOwnable.sol#2)\n\t- ^0.8.4 (src/contracts/IERC2981Royalties.sol#2)\n\t- ^0.8.4 (src/contracts/NFT.sol#4)\n",
            "markdown": "Different versions of Solidity is used:\n\t- Version used: ['^0.8.0', '^0.8.1', '^0.8.4']\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#L4)\n\t- [^0.8.1](node_modules/@openzeppelin/contracts/utils/Address.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/utils/Context.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/utils/Strings.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol#L4)\n\t- [^0.8.0](node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol#L4)\n\t- [^0.8.4](src/contracts/DTERC721A.sol#L4)\n\t- [^0.8.4](src/contracts/DTOwnable.sol#L2)\n\t- [^0.8.4](src/contracts/IERC2981Royalties.sol#L2)\n\t- [^0.8.4](src/contracts/NFT.sol#L4)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "7f0bd31c1f77b0fff91de3f3f123d7e68d825031f50ea655bd7b61a931fb6d08"
          }
        },
        {
          "ruleId": "3-1-dead-code",
          "message": {
            "text": "DTERC721A._baseURI() (src/contracts/DTERC721A.sol#288-290) is never used and should be removed\n",
            "markdown": "[DTERC721A._baseURI()](src/contracts/DTERC721A.sol#L288-L290) is never used and should be removed\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 288,
                  "endLine": 290
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "bee1b7110f331c874d2055f6ebf133bae9e6451328d8ac1b00fef4ad365d1f2a"
          }
        },
        {
          "ruleId": "3-1-dead-code",
          "message": {
            "text": "DTERC721A._numberBurned(address) (src/contracts/DTERC721A.sol#199-202) is never used and should be removed\n",
            "markdown": "[DTERC721A._numberBurned(address)](src/contracts/DTERC721A.sol#L199-L202) is never used and should be removed\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 199,
                  "endLine": 202
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "4f2cf1253c25e7df2b378fa89b63b3b8680ae2a87f71702f8544215ea9be4ddd"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "2c7efd54307eabb7ac3c63c6c2fb4704970b1d57998b2d3eeb1d0575e29be78f"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "b151eaea977ae1335b86997d4b8787b01ee7e82e48e1718232df668da82529e4"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "5106c52e320f91bc8dcdccc56e1a9bb1d7b604d42f94e56abd6d7c61d14525ee"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "d02bdbe9262b7d748cdb95d14ac00db4997fc71ee444cc13e6d1cfd29e71498d"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "7c6257fc3179e015e3f50299b475376ddc0974a3a8d2751bd7480388339a3a73"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.1 (node_modules/@openzeppelin/contracts/utils/Address.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.1](node_modules/@openzeppelin/contracts/utils/Address.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Address.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "5906f1667ddb1546c744db1c5ec0714512ac2139194ac59714f6577a5008fe49"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/utils/Context.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/utils/Context.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Context.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "21c670e40e414a2f849413afbbdb25adb81dae6585c4f38fc83730c17377e60f"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/utils/Strings.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/utils/Strings.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Strings.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "39bb6de244e9d295e9aa6c566b0b6e8f01ba481f4efc9e16952394697f339857"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "06845140c4de83a67b7ea1fa3eefa5eaca6813a74e80720101c31e3c3af14ffc"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "9aa52b2df4a9eaed2367df9ba879f35420395b80d0a76764766ed12bb8d78d84"
          }
        },
        {
          "ruleId": "3-0-solc-version",
          "message": {
            "text": "Pragma version^0.8.0 (node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol#4) allows old versions\n",
            "markdown": "Pragma version[^0.8.0](node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol#L4) allows old versions\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol"
                },
                "region": {
                  "startLine": 4,
                  "endLine": 4
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "e50a4771b0aca0892aba1b2286dd748b1627baee6c6a691176bc873aa48c94f1"
          }
        },
        {
          "ruleId": "3-0-low-level-calls",
          "message": {
            "text": "Low level call in Address.sendValue(address,uint256) (node_modules/@openzeppelin/contracts/utils/Address.sol#60-65):\n\t- (success) = recipient.call{value: amount}() (node_modules/@openzeppelin/contracts/utils/Address.sol#63)\n",
            "markdown": "Low level call in [Address.sendValue(address,uint256)](node_modules/@openzeppelin/contracts/utils/Address.sol#L60-L65):\n\t- [(success) = recipient.call{value: amount}()](node_modules/@openzeppelin/contracts/utils/Address.sol#L63)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Address.sol"
                },
                "region": {
                  "startLine": 60,
                  "endLine": 65
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "a45709b07c12b3e52a59e9b801f6f63b73382e5cec54b85cd8172ce2bc9d44b3"
          }
        },
        {
          "ruleId": "3-0-low-level-calls",
          "message": {
            "text": "Low level call in Address.functionCallWithValue(address,bytes,uint256,string) (node_modules/@openzeppelin/contracts/utils/Address.sol#128-139):\n\t- (success,returndata) = target.call{value: value}(data) (node_modules/@openzeppelin/contracts/utils/Address.sol#137)\n",
            "markdown": "Low level call in [Address.functionCallWithValue(address,bytes,uint256,string)](node_modules/@openzeppelin/contracts/utils/Address.sol#L128-L139):\n\t- [(success,returndata) = target.call{value: value}(data)](node_modules/@openzeppelin/contracts/utils/Address.sol#L137)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Address.sol"
                },
                "region": {
                  "startLine": 128,
                  "endLine": 139
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "b673e3527018708f76871ed62a1879b9035819e49d368aba92f27343cf591ab2"
          }
        },
        {
          "ruleId": "3-0-low-level-calls",
          "message": {
            "text": "Low level call in Address.functionStaticCall(address,bytes,string) (node_modules/@openzeppelin/contracts/utils/Address.sol#157-166):\n\t- (success,returndata) = target.staticcall(data) (node_modules/@openzeppelin/contracts/utils/Address.sol#164)\n",
            "markdown": "Low level call in [Address.functionStaticCall(address,bytes,string)](node_modules/@openzeppelin/contracts/utils/Address.sol#L157-L166):\n\t- [(success,returndata) = target.staticcall(data)](node_modules/@openzeppelin/contracts/utils/Address.sol#L164)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Address.sol"
                },
                "region": {
                  "startLine": 157,
                  "endLine": 166
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "c706e8e01049568550afd32aaf56e3f04f269e818d404e36dde611996851ece7"
          }
        },
        {
          "ruleId": "3-0-low-level-calls",
          "message": {
            "text": "Low level call in Address.functionDelegateCall(address,bytes,string) (node_modules/@openzeppelin/contracts/utils/Address.sol#184-193):\n\t- (success,returndata) = target.delegatecall(data) (node_modules/@openzeppelin/contracts/utils/Address.sol#191)\n",
            "markdown": "Low level call in [Address.functionDelegateCall(address,bytes,string)](node_modules/@openzeppelin/contracts/utils/Address.sol#L184-L193):\n\t- [(success,returndata) = target.delegatecall(data)](node_modules/@openzeppelin/contracts/utils/Address.sol#L191)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "node_modules/@openzeppelin/contracts/utils/Address.sol"
                },
                "region": {
                  "startLine": 184,
                  "endLine": 193
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "c944733a5fa81935f97104b39ea4f867f663e8d05b23c0ea00802aa0c991e46c"
          }
        },
        {
          "ruleId": "3-0-low-level-calls",
          "message": {
            "text": "Low level call in NFT._transferEth(address,uint256) (src/contracts/NFT.sol#443-447):\n\t- (sent) = to.call{value: amount}() (src/contracts/NFT.sol#445)\n",
            "markdown": "Low level call in [NFT._transferEth(address,uint256)](src/contracts/NFT.sol#L443-L447):\n\t- [(sent) = to.call{value: amount}()](src/contracts/NFT.sol#L445)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 443,
                  "endLine": 447
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "31a2ffd7717e78573dfd2d1f66f70834016476f42fa61188de1346d4ab1a4ed4"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Parameter DTERC721A.safeTransferFrom(address,address,uint256,bytes)._data (src/contracts/DTERC721A.sol#361) is not in mixedCase\n",
            "markdown": "Parameter [DTERC721A.safeTransferFrom(address,address,uint256,bytes)._data](src/contracts/DTERC721A.sol#L361) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 361,
                  "endLine": 361
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "b849b87781f9958a54791e5d00a3b55579fffe7a4ba334e2255db531acc91156"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable DTERC721A._currentIndex (src/contracts/DTERC721A.sol#75) is not in mixedCase\n",
            "markdown": "Variable [DTERC721A._currentIndex](src/contracts/DTERC721A.sol#L75) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 75,
                  "endLine": 75
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "79a5d3c30c0584a7ec13db4238fc82c6b56d637fd476610307f9660e50545b02"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable DTERC721A._burnCounter (src/contracts/DTERC721A.sol#78) is not in mixedCase\n",
            "markdown": "Variable [DTERC721A._burnCounter](src/contracts/DTERC721A.sol#L78) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 78,
                  "endLine": 78
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "c6f90891b951da0db09dd403290c43794763d0a8aa4ad122a9047d3bdd10578b"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable DTERC721A._ownerships (src/contracts/DTERC721A.sol#88) is not in mixedCase\n",
            "markdown": "Variable [DTERC721A._ownerships](src/contracts/DTERC721A.sol#L88) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 88,
                  "endLine": 88
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "4fc7d64622385d4f656fffb6307f71f09060743fe5977288ffc468a225a99e08"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Parameter NFT.updateCID(string,string).GodCid (src/contracts/NFT.sol#237) is not in mixedCase\n",
            "markdown": "Parameter [NFT.updateCID(string,string).GodCid](src/contracts/NFT.sol#L237) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 237,
                  "endLine": 237
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "c44b11fd4c0598eed22aa15484dbf43a80a5d61eff8660784efc6ef716fe855c"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Parameter NFT.updateCID(string,string).HumanCid (src/contracts/NFT.sol#237) is not in mixedCase\n",
            "markdown": "Parameter [NFT.updateCID(string,string).HumanCid](src/contracts/NFT.sol#L237) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 237,
                  "endLine": 237
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "46eceb09c2640b4f2532692839e4ae70243c2a86c78f1babc07453226e10cd31"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.MAX_SUPPLY (src/contracts/NFT.sol#105) is not in mixedCase\n",
            "markdown": "Variable [NFT.MAX_SUPPLY](src/contracts/NFT.sol#L105) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 105,
                  "endLine": 105
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "e7a6b2e17f6b9a4ddc88f34e8221ceb22c2df62304a4c860ffbb0d3bf47352ec"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.UPGRADE_REQUEST_FEE_IN_WEI (src/contracts/NFT.sol#106) is not in mixedCase\n",
            "markdown": "Variable [NFT.UPGRADE_REQUEST_FEE_IN_WEI](src/contracts/NFT.sol#L106) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 106,
                  "endLine": 106
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "a942a1376233c769951e2f388a28013b2f9b03fb9b5236737d38a7c990617f73"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.STATE (src/contracts/NFT.sol#107) is not in mixedCase\n",
            "markdown": "Variable [NFT.STATE](src/contracts/NFT.sol#L107) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 107,
                  "endLine": 107
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "af266a5264887f0f2681096d528214e608be2667154cb67f1f86b8f0c44628ea"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.ADDRESS (src/contracts/NFT.sol#108) is not in mixedCase\n",
            "markdown": "Variable [NFT.ADDRESS](src/contracts/NFT.sol#L108) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 108,
                  "endLine": 108
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "6018329a2c2ab532474f12300bca95c73f8600d371e72eb8ce8642d912625159"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.IPFS (src/contracts/NFT.sol#109) is not in mixedCase\n",
            "markdown": "Variable [NFT.IPFS](src/contracts/NFT.sol#L109) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 109,
                  "endLine": 109
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "0004e642def12c4dd61277a44a855fc60c903316decfe3452a3e6d4e9262365b"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.MINTING_CONFIG (src/contracts/NFT.sol#110) is not in mixedCase\n",
            "markdown": "Variable [NFT.MINTING_CONFIG](src/contracts/NFT.sol#L110) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 110,
                  "endLine": 110
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "b9b735f3bd03a117547bfcf181e0531c59f528a60b8f3450a7ade8ddba6d3072"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT._ROYALTIES (src/contracts/NFT.sol#111) is not in mixedCase\n",
            "markdown": "Variable [NFT._ROYALTIES](src/contracts/NFT.sol#L111) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 111,
                  "endLine": 111
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "1c10f1502b5bdfa890c422069279090a74a2c8ee61880359595bb7dff7e10a10"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.TOKEN_IS_UPGRADED (src/contracts/NFT.sol#114) is not in mixedCase\n",
            "markdown": "Variable [NFT.TOKEN_IS_UPGRADED](src/contracts/NFT.sol#L114) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 114,
                  "endLine": 114
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "c84a1830a12bb21bd46d54343ca01c367961cb01ca81d17ca113acdaeba4900d"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT._UPGRADED_TOKEN_CID (src/contracts/NFT.sol#115) is not in mixedCase\n",
            "markdown": "Variable [NFT._UPGRADED_TOKEN_CID](src/contracts/NFT.sol#L115) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 115,
                  "endLine": 115
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "9b6954ef84a34a6e2e092028ad22c7d0d8d9e55d725e6e1a9206d90d3e8ac596"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.TOKEN_IS_GOD (src/contracts/NFT.sol#116) is not in mixedCase\n",
            "markdown": "Variable [NFT.TOKEN_IS_GOD](src/contracts/NFT.sol#L116) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 116,
                  "endLine": 116
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "968af2f47cb2dd129476c8a79bbbd8975413f0ce3eee692a0dc8f48bdd675db0"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.AUCTIONS (src/contracts/NFT.sol#117) is not in mixedCase\n",
            "markdown": "Variable [NFT.AUCTIONS](src/contracts/NFT.sol#L117) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 117,
                  "endLine": 117
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "eab33fab437cd9a439a12a62a46532476c0147873da119763fe7978cc0160847"
          }
        },
        {
          "ruleId": "3-0-naming-convention",
          "message": {
            "text": "Variable NFT.UPGRADE_REQUEST_FEE_IS_PAID (src/contracts/NFT.sol#118) is not in mixedCase\n",
            "markdown": "Variable [NFT.UPGRADE_REQUEST_FEE_IS_PAID](src/contracts/NFT.sol#L118) is not in mixedCase\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/NFT.sol"
                },
                "region": {
                  "startLine": 118,
                  "endLine": 118
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "378148f70660c5f5298bdfa78f5a94ef2bf0ca7520cf6837dff44d67f1b54bcd"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "tokenByIndex(uint256) should be declared external:\n\t- DTERC721A.tokenByIndex(uint256) (src/contracts/DTERC721A.sol#127-130)\n",
            "markdown": "tokenByIndex(uint256) should be declared external:\n\t- [DTERC721A.tokenByIndex(uint256)](src/contracts/DTERC721A.sol#L127-L130)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 127,
                  "endLine": 130
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "95173f155eb922120c9ffabdf1bb97bf0af4dd78b073d7c91122f9cee45b0a3e"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "tokenOfOwnerByIndex(address,uint256) should be declared external:\n\t- DTERC721A.tokenOfOwnerByIndex(address,uint256) (src/contracts/DTERC721A.sol#137-155)\n",
            "markdown": "tokenOfOwnerByIndex(address,uint256) should be declared external:\n\t- [DTERC721A.tokenOfOwnerByIndex(address,uint256)](src/contracts/DTERC721A.sol#L137-L155)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 137,
                  "endLine": 155
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "e795dee85ecbaf96e6df6964eb84e95950b10fd7e11fe0e01dd5dc1fdc9ef9e3"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "name() should be declared external:\n\t- DTERC721A.name() (src/contracts/DTERC721A.sol#262-264)\n",
            "markdown": "name() should be declared external:\n\t- [DTERC721A.name()](src/contracts/DTERC721A.sol#L262-L264)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 262,
                  "endLine": 264
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "cc2571f40a060823ad38acd1ec2600cf61e2f6e697d14240e89c5dd6af74e0a9"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "symbol() should be declared external:\n\t- DTERC721A.symbol() (src/contracts/DTERC721A.sol#269-271)\n",
            "markdown": "symbol() should be declared external:\n\t- [DTERC721A.symbol()](src/contracts/DTERC721A.sol#L269-L271)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 269,
                  "endLine": 271
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "06c9e30432175126e781fc12ce564f7c0a56d3fbe60381c73e36ea7edcf703e7"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "tokenURI(uint256) should be declared external:\n\t- DTERC721A.tokenURI(uint256) (src/contracts/DTERC721A.sol#276-281)\n\t- NFT.tokenURI(uint256) (src/contracts/NFT.sol#401-415)\n",
            "markdown": "tokenURI(uint256) should be declared external:\n\t- [DTERC721A.tokenURI(uint256)](src/contracts/DTERC721A.sol#L276-L281)\n\t- [NFT.tokenURI(uint256)](src/contracts/NFT.sol#L401-L415)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 276,
                  "endLine": 281
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "70494366c0295a62fbfc9460764b6b556b50bf9e2dc33108a9ba1735b6a20cf3"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "approve(address,uint256) should be declared external:\n\t- DTERC721A.approve(address,uint256) (src/contracts/DTERC721A.sol#295-304)\n",
            "markdown": "approve(address,uint256) should be declared external:\n\t- [DTERC721A.approve(address,uint256)](src/contracts/DTERC721A.sol#L295-L304)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 295,
                  "endLine": 304
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "9e90846392411f407aa959f8c47b15d5e6aedd5eed5e0b0230ffed56a1db951e"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "setApprovalForAll(address,bool) should be declared external:\n\t- DTERC721A.setApprovalForAll(address,bool) (src/contracts/DTERC721A.sol#318-323)\n",
            "markdown": "setApprovalForAll(address,bool) should be declared external:\n\t- [DTERC721A.setApprovalForAll(address,bool)](src/contracts/DTERC721A.sol#L318-L323)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 318,
                  "endLine": 323
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "a81c94169afc3581088e6b1f139c0b72f04644525e876fec2ffd8ddca94a7f7a"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "transferFrom(address,address,uint256) should be declared external:\n\t- DTERC721A.transferFrom(address,address,uint256) (src/contracts/DTERC721A.sol#335-341)\n",
            "markdown": "transferFrom(address,address,uint256) should be declared external:\n\t- [DTERC721A.transferFrom(address,address,uint256)](src/contracts/DTERC721A.sol#L335-L341)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 335,
                  "endLine": 341
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "689b94f9fc1e5676e4c71055a4750a7f78f57de425f72f09a45d8cef80e3c494"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "safeTransferFrom(address,address,uint256) should be declared external:\n\t- DTERC721A.safeTransferFrom(address,address,uint256) (src/contracts/DTERC721A.sol#346-352)\n",
            "markdown": "safeTransferFrom(address,address,uint256) should be declared external:\n\t- [DTERC721A.safeTransferFrom(address,address,uint256)](src/contracts/DTERC721A.sol#L346-L352)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTERC721A.sol"
                },
                "region": {
                  "startLine": 346,
                  "endLine": 352
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "419f89aa2c154c261f60dfc7d8f1b9e4f93ce441194d2159aa42282f86e21e60"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "renounceOwnership() should be declared external:\n\t- DTOwnable.renounceOwnership() (src/contracts/DTOwnable.sol#53-55)\n",
            "markdown": "renounceOwnership() should be declared external:\n\t- [DTOwnable.renounceOwnership()](src/contracts/DTOwnable.sol#L53-L55)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTOwnable.sol"
                },
                "region": {
                  "startLine": 53,
                  "endLine": 55
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "7f898b40eb442f2e5cb1c383bcbbbea74f52aade67312d9e077df92f646fa7f9"
          }
        },
        {
          "ruleId": "4-0-external-function",
          "message": {
            "text": "transferOwnership(address) should be declared external:\n\t- DTOwnable.transferOwnership(address) (src/contracts/DTOwnable.sol#61-64)\n",
            "markdown": "transferOwnership(address) should be declared external:\n\t- [DTOwnable.transferOwnership(address)](src/contracts/DTOwnable.sol#L61-L64)\n"
          },
          "level": "warning",
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": {
                  "uri": "src/contracts/DTOwnable.sol"
                },
                "region": {
                  "startLine": 61,
                  "endLine": 64
                }
              }
            }
          ],
          "partialFingerprints": {
            "id": "84a47316a6116dce09bd31c0529fc7a9026216e740334ee5c91befc962258c9d"
          }
        }
      ]
    }
  ]
}