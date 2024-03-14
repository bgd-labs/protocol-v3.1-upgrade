// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3PolygonAssets, AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';

import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {UpgradePayloadTestWithStableSwap} from './UpgradePayloadTestWithStableSwap.sol';

contract UpgradePolygonTest is
  UpgradePayloadTestWithStableSwap(
    'polygon',
    54337710,
    0xc5543b3a2973dd3b9d156376E1e8E7d0dCAc3664,
    AaveV3PolygonAssets.DAI_UNDERLYING,
    AaveV3Polygon.ACL_ADMIN
  )
{
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployPolygon();
  }
}
