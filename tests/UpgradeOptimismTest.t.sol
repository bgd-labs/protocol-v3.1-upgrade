// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3OptimismAssets, AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';

import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {UpgradePayloadTestWithStableSwap} from './UpgradePayloadTestWithStableSwap.sol';

contract UpgradeOptimismTest is
  UpgradePayloadTestWithStableSwap(
    'optimism',
    121808033,
    0x583891495AF8624fbc88Cc5e8AA45C91d089A508,
    AaveV3OptimismAssets.USDC_UNDERLYING,
    1.5 * 1e3 // limit is 0.015%
  )
{
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployOptimism();
  }
}
