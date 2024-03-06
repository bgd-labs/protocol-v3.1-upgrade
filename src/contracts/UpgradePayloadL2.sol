// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {IPoolAddressesProvider} from 'aave-v3-factory/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-factory/core/instances/PoolConfiguratorInstance.sol';
import {L2PoolInstance} from 'aave-v3-factory/core/instances/L2PoolInstance.sol';

contract L2UpgradePayload is IProposalGenericExecutor {
  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;

  constructor(IPoolAddressesProvider poolAddressesProvider) {
    POOL_ADDRESSES_PROVIDER = poolAddressesProvider;
  }

  function execute() external {
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(address(new PoolConfiguratorInstance()));
    POOL_ADDRESSES_PROVIDER.setPoolImpl(address(new L2PoolInstance(POOL_ADDRESSES_PROVIDER)));
  }
}
