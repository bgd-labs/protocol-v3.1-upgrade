// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradeMetisTest is UpgradePayloadTest('metis', 14812943) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployMetis();
  }
}
