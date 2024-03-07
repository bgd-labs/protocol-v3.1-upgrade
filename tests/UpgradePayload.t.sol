// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3helpers.sol';
import {ProtocolV3TestBase, IPool as IOldPool} from 'aave-helpers/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {IPoolAddressesProvider} from 'aave-v3-factory/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPool} from 'aave-v3-factory/core/contracts/interfaces/IPool.sol';
import {IPoolConfigurator} from 'aave-v3-factory/core/contracts/interfaces/IPoolConfigurator.sol';

/**
 * Basetest to be executed on all networks
 */
abstract contract UpgradePayloadTest is ProtocolV3TestBase {
  IPoolAddressesProvider internal POOL_ADDRESSES_PROVIDER;
  UpgradePayload internal PAYLOAD;

  function _setUp(address payload) internal {
    PAYLOAD = UpgradePayload(payload);
    POOL_ADDRESSES_PROVIDER = PAYLOAD.POOL_ADDRESSES_PROVIDER();
  }

  function test_default() external {
    defaultTest(
      vm.toString(block.chainid),
      IOldPool(POOL_ADDRESSES_PROVIDER.getPool()),
      address(PAYLOAD)
    );
  }

  function test_upgrade() external {
    GovV3Helpers.executePayload(vm, address(PAYLOAD));
  }
}
