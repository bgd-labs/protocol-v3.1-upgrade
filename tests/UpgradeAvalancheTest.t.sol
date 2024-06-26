// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AaveV3AvalancheAssets, AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';

import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {UpgradePayloadTestWithStableSwap} from './UpgradePayloadTestWithStableSwap.sol';

contract UpgradeAvalancheTest is
  UpgradePayloadTestWithStableSwap(
    'avalanche',
    47199325,
    0x82E8936b187d83FD6eb2B7Dab5B19556e9DEFF1C,
    AaveV3AvalancheAssets.USDt_UNDERLYING,
    5 * 1e3 // limit raised to 0.05%, because of FRAX(0.016%) and MAI(0.05%)
  )
{
  function test_proofOfReserveExecutor_riskAdmin_removed() public proposalExecuted {
    assertFalse(AaveV3Avalanche.ACL_MANAGER.isRiskAdmin(PAYLOAD.PROOF_OF_RESERVE_EXECUTOR()));
  }

  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployAvalanche();
  }
}
