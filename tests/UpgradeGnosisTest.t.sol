// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradeGnosisTest is
  UpgradePayloadTest(
    'gnosis',
    34659705,
    1.5 * 1e3 // limit is 0.015%
  )
{
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployGnosis();
  }
}
