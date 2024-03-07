// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradePolygonTest is UpgradePayloadTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 54337710);
    _setUp(DeploymentLibrary._deployPolygon());
  }
}
