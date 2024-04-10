// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PoolInstance} from 'aave-v3-origin/core/instances/PoolInstance.sol';
import {IPoolAddressesProvider, Errors} from 'aave-v3-origin/core/contracts/protocol/pool/Pool.sol';

import {PoolRevisionFourInitialize} from './PoolRevisionFourInitialize.sol';

/**
 * @notice Pool instance with custom initialize for existing pools
 */
contract PoolInstanceWithCustomInitialize is PoolInstance {
  constructor(IPoolAddressesProvider provider) PoolInstance(provider) {}

  function initialize(IPoolAddressesProvider provider) external virtual override initializer {
    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
    PoolRevisionFourInitialize.initialize(_reservesCount, _reservesList, _reserves);
  }
}
