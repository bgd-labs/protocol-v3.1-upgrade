// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {L2PoolInstance} from 'aave-v3-origin/core/instances/L2PoolInstance.sol';
import {PoolInstanceWithCustomInitialize, Errors} from './PoolInstance.sol';
import {L2Pool, IPoolAddressesProvider} from 'aave-v3-origin/core/contracts/protocol/pool/L2Pool.sol';

/**
 * @notice L2Pool instance with custom initialize for existing pools
 */
contract L2PoolInstanceWithCustomInitialize is L2Pool, PoolInstanceWithCustomInitialize {
  constructor(IPoolAddressesProvider provider) PoolInstanceWithCustomInitialize(provider) {}
}
