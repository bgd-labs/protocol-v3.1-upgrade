// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

contract PoolInstance is Pool {
  uint256 public constant POOL_REVISION = 3;

  constructor(IPoolAddressesProvider provider) Pool(provider) {}

  function initialize(IPoolAddressesProvider provider) external virtual override initializer {
    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
  }

  function getRevision() internal pure virtual override returns (uint256) {
    return POOL_REVISION;
  }
}
