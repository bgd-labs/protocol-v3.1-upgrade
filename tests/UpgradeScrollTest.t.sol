// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradeScrollTest is
  UpgradePayloadTest(
    'scroll',
    6837096,
    1.5 * 1e3 // limit is 0.015%
  )
{
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployScroll();
  }
}
