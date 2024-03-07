// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {L2PoolInstance} from 'aave-v3-factory/core/instances/L2PoolInstance.sol';
import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

/**
 * @notice L2Pool instance with custom initialize for existing pools
 */
contract L2PoolInstanceWithCustomInitialize is L2PoolInstance {
  constructor(IPoolAddressesProvider provider) L2PoolInstance(provider) {}

  function initialize(IPoolAddressesProvider provider) external virtual override initializer {
    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
    // TODO: virtual accounting
  }
}
