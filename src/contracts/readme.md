## security test

for security static test run the following command:

```
virtualenv  -p python3 venv

pip3 install -r requirements.txt

source venv/bin/activate

first use flatten to collect all file in one file
and clean the file (remove extra SPDX move error from source to here)

slither src/contracts/example_merged.sol

```

---

for local test with HardHat

```
npx hardhat run scripts/setup.ts --network localhost
npx hardhat console --network localhost

const SampleContract = await ethers.getContractFactory('SampleContract');
const sampleContractInstance = await Greeter.attach(ContractAddress);

await sampleContractInstance.changeStateMethod(some input);
```

---

for running solidity linter run the following command:

```
 npx solhint src/contracts/example.sol --fix
```

---

for exporting abi

```
npx hardhat export-abi
```

---

for showing test coverage

```
npx hardhat coverage
```

---

## Naming Convention in solidity :

``` 
Types: 
    lowercase, 
    lower_case_with_underscores, 
    UPPERCASE, 
    UPPER_CASE_WITH_UNDERSCORES, 
    CapitalizedWords, 
    mixedCase, 
    Capitalized_Words_With_Underscores
```

```
Names to Avoid: 
    l - Lowercase letter el, 
    O - Uppercase letter oh, 
    I - Uppercase letter eye. 

Never use any of these for single letter variable names. They are often indistinguishable from the numerals one and zero.
```

```
Contracts and libraries should be named using the CapWords style. 

Contract and library names should also match their filenames. If a contract file includes multiple contracts and/or libraries, then the filename should match the core contract. This is not recommended however if it can be avoided. 

Examples: SimpleToken, SmartBank, CertificateHashRepository, Player, Congress, Owned.
```


```
Structs should be named using the CapWords style. 

Examples: MyCoin, Position, PositionXY.
```

```
Events should be named using the CapWords style. 

Examples: Deposit, Transfer, Approval, BeforeTransfer, AfterTransfer.
```

```
Functions should use mixedCase. 

Examples: getBalance, transfer, verifyOwner, addMember, changeOwner.

Function arguments should use mixedCase. 

Examples: initialSupply, account, recipientAddress, senderAddress, newOwner.
```

```
Local and state variable names should use mixedCase. 

Examples: totalSupply, remainingSupply, balancesOf, creatorAddress, isPreSale, tokenExchangeRate.
```

```
Constants should be named with all capital letters with underscores separating words. 

Examples: MAX_BLOCKS, TOKEN_NAME, TOKEN_TICKER, CONTRACT_VERSION.
```

```
Modifier names should use mixedCase. 

Examples: onlyBy, onlyAfter, onlyDuringThePreSale.
```

```
Enums, in the style of simple type declarations, should be named using the CapWords style. 

Examples: TokenGroup, Frame, HashStyle, CharacterLocation.
```

```
Avoiding Naming Collisions: single_trailing_underscore_. This convention is suggested when the desired name collides with that of a built-in or otherwise reserved name.
```
---

```
 The best-practices for layout within a contract is the following order: 
    - state variables, 
    - events, 
    - modifiers, 
    - constructor and functions
        - receive function (if exists)
        - fallback function (if exists)
        - external functions
        - public functions
        - internal functions
        - private functions
        - place the view and pure functions last in each function group

 ```