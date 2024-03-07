// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradeBaseTest is UpgradePayloadTest('base', 11509265) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployBase();
  }
}
