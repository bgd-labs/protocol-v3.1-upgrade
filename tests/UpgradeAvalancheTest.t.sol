// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AaveV3AvalancheAssets, AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';

import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {UpgradePayloadTestWithStableSwap} from './UpgradePayloadTestWithStableSwap.sol';

contract UpgradeAvalancheTest is
  UpgradePayloadTestWithStableSwap(
    'avalanche',
    42590450,
    0x82E8936b187d83FD6eb2B7Dab5B19556e9DEFF1C,
    AaveV3AvalancheAssets.USDt_UNDERLYING,
    AaveV3Avalanche.ACL_ADMIN
  )
{
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployAvalanche();
  }
}
