# Protocol v 3.1 Upgrade

The repository contains contracts for upgrade existing instances of Aave protocol from v3.0.2 to v3.1.0.

## PoolInstanceWithCustomInitialize
Extends `PoolInstance` contract, includes initialization of the Virtual Accounting values on all existing reserves.

The logic to calculate this value is:
```
  (aTokenTotalSupply + accruedToTreasury) - (sTokenTotalSupply + vTokenTotalSupply)
```
Where `accruedToTreasury` is amount of fees accrued, but not minted as aToken at the moment of execution.
To avoid the situation when balance of underlying is lower than virtual accounting,
it's possible because aave generates certain imprecision overtime, we cap virtual accounting value to this value.

Virtual balance for GHO is not enabled, because it has custom implementation and getting minted on the borrow event.

## Upgrade payload


## Dependencies

- Foundry, [how-to install](https://book.getfoundry.sh/getting-started/installation)

## Setup

```sh
cp .env.example .env
forge install

# optional, to install prettier
npm i
```

## Tests

- Tests for all: `forge test`

## License

Copyright © 2024, Aave DAO, represented by its governance smart contracts.

Created by [BGD Labs](https://bgdlabs.com/).

The default license of this repository is [BUSL1.1](./LICENSE), but all interfaces are open source, MIT-licensed.

**IMPORTANT**. The BUSL1.1 license of this repository allows for any usage of the software,
if respecting the *Additional Use Grant* limitations, forbidding any use case damaging anyhow the Aave DAO's interests.
