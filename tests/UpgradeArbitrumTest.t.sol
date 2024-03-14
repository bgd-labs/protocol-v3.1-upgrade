// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3ArbitrumAssets, AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';

import {DeploymentLibrary} from '../scripts/Deploy.s.sol';
import {UpgradePayloadTestWithStableSwap} from './UpgradePayloadTestWithStableSwap.sol';

contract UpgradeArbitrumTest is
  UpgradePayloadTestWithStableSwap(
    'arbitrum',
    187970620,
    0x62B8e137ee87Ab3CaEB2FEA3B88D04abeA7C5579,
    AaveV3ArbitrumAssets.USDC_UNDERLYING,
    AaveV3Arbitrum.ACL_ADMIN
  )
{
  function _getPayload() internal virtual override returns (address) {
    return DeploymentLibrary._deployArbitrum();
  }
}
