// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradeArbitrumTest is UpgradePayloadTest('arbitrum', 187970620) {
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployArbitrum();
  }
}
