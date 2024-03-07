// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UpgradePayloadTest} from './UpgradePayload.t.sol';
import {DeploymentLibrary} from '../scripts/Deploy.s.sol';

contract UpgradeArbitrumTest is UpgradePayloadTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 187970620);
    _setUp(DeploymentLibrary._deployArbitrum());
  }
}
