// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {PoolInstance} from 'aave-v3-factory/core/instances/PoolInstance.sol';
import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

/**
 * @notice Pool instance with custom initialize for existing pools
 */
contract PoolInstanceWithCustomInitialize is PoolInstance {
  constructor(IPoolAddressesProvider provider) PoolInstance(provider) {}

  function initialize(IPoolAddressesProvider provider) external virtual override initializer {
    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
    _maxStableRateBorrowSizePercent = 0.25e4;
    // TODO: virtual accounting
  }
}
