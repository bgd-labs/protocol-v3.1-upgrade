// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3helpers.sol';
import {ProtocolV3TestBase, IPool} from 'aave-helpers/ProtocolV3TestBase.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

/**
 * Basetest to be executed on all networks
 */
abstract contract UpgradePayloadTest is ProtocolV3TestBase {
  IPoolAddressesProvider internal immutable POOL_ADDRESSES_PROVIDER;
  UpgradePayload internal immutable PAYLOAD;

  constructor(address poolAddressProvider) {
    POOL_ADDRESSES_PROVIDER = IPoolAddressesProvider(poolAddressProvider);
    PAYLOAD = new UpgradePayload(IPoolAddressesProvider(poolAddressProvider));
    // needed as setup is invoked afterwards to the fork changes
    vm.makePersistent(address(PAYLOAD));
  }

  function test_default() external {
    defaultTest(
      vm.toString(block.chainid),
      IPool(POOL_ADDRESSES_PROVIDER.getPool()),
      address(PAYLOAD)
    );
  }

  function test_upgrade() external {
    GovV3Helpers.executePayload(vm, address(PAYLOAD));
  }
}
