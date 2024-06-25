// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BaseTest, IERC20} from './BaseTest.t.sol';
import {DeploymentLibrary} from '../../scripts/Deploy.s.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {VersionedInitializable} from 'aave-v3-origin/core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';

// The current state of this test contract is on the protocol version 3.0.2.
// To test the protocol on the upgraded state, please add `proposalExecuted` modifier to your test or call the internal method `_executePayload()` on your tests.
// The `proposalExecutor` modifier is to be used if the test only needs to do checks without a pre-execution state.
// While adding manually the _executePayload() gives more flexibility to for example initialize some data before the update and check changes done by the update itself.
// The protocol contracts could be accessed via `AaveV3Ethereum` and the listed assets via `AaveV3EthereumAssets` from the aave-address-book.
// command to test: make test-contract filter=EthereumBaseTest
contract EthereumBaseTest is BaseTest('mainnet', 20160113) {
  // code to test the protocol pool could be added below.
  function test_pool() public proposalExecuted {
    address user = address(62409);
    uint256 amount = 1000e6;

    deal2(AaveV3EthereumAssets.USDC_UNDERLYING, user, amount);

    vm.startPrank(user);
    IERC20(AaveV3EthereumAssets.USDC_UNDERLYING).approve(address(AaveV3Ethereum.POOL), amount);
    AaveV3Ethereum.POOL.deposit(
      AaveV3EthereumAssets.USDC_UNDERLYING,
      amount,
      user,
      0
    );
    vm.stopPrank();
    assertGe(IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).balanceOf(user), amount);
  }

  // code to test the protocol pool configurator could be added below.
  function test_pool_configurator() public proposalExecuted {
    vm.startPrank(GovernanceV3Ethereum.EXECUTOR_LVL_1);
    AaveV3Ethereum.POOL_CONFIGURATOR.setReservePause(AaveV3EthereumAssets.USDC_UNDERLYING, true);
    vm.stopPrank();

    AAVE_PROTOCOL_DATA_PROVIDER.getPaused(AaveV3EthereumAssets.USDC_UNDERLYING);
  }

  // code to test the protocol protocol data provider could be added below.
  function test_data_provider() public {
    assertEq(POOL_ADDRESSES_PROVIDER.getPoolDataProvider(), address(AaveV3Ethereum.AAVE_PROTOCOL_DATA_PROVIDER));

    _executePayload();

    // this is updated protocol data provider contract after v3.1 upgrade is complete
    assertEq(POOL_ADDRESSES_PROVIDER.getPoolDataProvider(), address(AAVE_PROTOCOL_DATA_PROVIDER));
  }

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployEthereum();
  }
}
