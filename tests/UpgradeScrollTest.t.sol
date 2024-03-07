// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradePolygonTest is UpgradePayloadTest('scroll', 3921934) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployScroll();
  }
}
