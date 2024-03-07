// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3helpers.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

contract UpgradePolygonTest is UpgradePayloadTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 54337710);
    _setUp(
      address(AaveV3Polygon.POOL_ADDRESSES_PROVIDER),
      address(AaveV3Polygon.POOL),
      address(AaveV3Polygon.POOL_CONFIGURATOR)
    );
  }
}
