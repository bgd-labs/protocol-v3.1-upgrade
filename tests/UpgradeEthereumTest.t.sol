// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3helpers.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

contract UpgradeEthereumTest is
  UpgradePayloadTest(address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER))
{
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19376575);
  }
}
