// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3helpers.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {Pool, IPoolAddressesProvider, Errors} from 'aave-v3-factory/core/contracts/protocol/pool/Pool.sol';

abstract contract UpgradePayloadTest is Test {
  UpgradePayload internal payload;

  function test_upgrade() external {
    GovV3Helpers.executePayload(vm, address(payload));
  }
}

contract UpgradeEthereumTest is UpgradePayloadTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19215132);
    payload = new UpgradePayload(
      IPoolAddressesProvider(address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER)) // TODO: remove workaround once factory repo is public
    );
  }
}
