# Aave v3.1 upgrade

This repository contains contracts to upgrade existing instances of Aave protocol from v3.0.2 to v3.1.0.

<br>

## Dependencies

- Foundry, [how-to install](https://book.getfoundry.sh/getting-started/installation) (we recommend also update to the last version with `foundryup`).

## Setup

```sh
cp .env.example .env
forge install

# optional, to install prettier
yarn install
```

## Tests

`forge test`


<br>

## Specification

<br>

### [PoolInstanceWithCustomInitialize](./src/contracts/PoolInstanceWithCustomInitialize.sol)

Extends `PoolInstance` contract, and includes the initialization of the virtual Accounting values on all existing reserves (apart from GHO).

The logic to calculate this value is:
```
  (aTokenTotalSupply + accruedToTreasury) - (sTokenTotalSupply + vTokenTotalSupply)
```

Where `accruedToTreasury` is amount of fees accrued, but not minted as aToken at the moment of execution.

To avoid the situation when balance of underlying is lower than virtual accounting (possible due to how Aave calculates borrow interest versus supply interest), we cap virtual accounting value to the balance.

Virtual balance for GHO is not enabled, because it has custom implementation based on minting, instead of supplied liquidity.

For L2s instances, an additional [L2PoolInstanceWithCustomInitialize](./src/contracts/L2PoolInstanceWithCustomInitialize.sol) is included, introducing the `L2PoolInstance` contract in the inheritance chain.

<br>

### Upgrade payload

The payload for the upgrade does the following:

- Upgrades the `PoolConfigurator` implementation.
- Upgrades the `Pool` implementation.
- Connects the new `PoolDataProvider` to the `PoolAddressesProvider`.
- For all assets (including GHO, as the new rate strategy is compatible), updates the rate strategy, and initialises the rate data using each current configuration on-chain.

<br>


## License

Copyright © 2024, BGD Labs.

This repository is [MIT-licensed](./LICENSE).
