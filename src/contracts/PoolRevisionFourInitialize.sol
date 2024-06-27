// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DataTypes} from 'aave-v3-origin/core/contracts/protocol/pool/Pool.sol';
import {IERC20} from 'aave-v3-origin/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import {SafeCast} from 'aave-v3-origin/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol';
import {WadRayMath} from 'aave-v3-origin/core/contracts/protocol/libraries/math/WadRayMath.sol';
import {MathUtils} from 'aave-v3-origin/core/contracts/protocol/libraries/math/MathUtils.sol';
import {ReserveConfiguration} from 'aave-v3-origin/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol';
import {ReserveLogic} from 'aave-v3-origin/core/contracts/protocol/libraries/logic/ReserveLogic.sol';

import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

library PoolRevisionFourInitialize {
  using ReserveLogic for DataTypes.ReserveCache;
  using ReserveLogic for DataTypes.ReserveData;
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

  function initialize(
    uint256 reservesCount,
    mapping(uint256 => address) storage _reservesList,
    mapping(address => DataTypes.ReserveData) storage _reserves
  ) external {
    for (uint256 i = 0; i < reservesCount; i++) {
      address currentReserveAddress = _reservesList[i];
      // if this reserve was dropped already - skip
      // GHO is the special case
      if (
        currentReserveAddress == address(0) ||
        currentReserveAddress == AaveV3EthereumAssets.GHO_UNDERLYING
      ) {
        continue;
      }

      DataTypes.ReserveData storage currentReserve = _reserves[currentReserveAddress];
      DataTypes.ReserveCache memory reserveCache = currentReserve.cache();
      currentReserve.updateState(reserveCache);

      uint256 balanceOfUnderlying = IERC20(currentReserveAddress).balanceOf(
        reserveCache.aTokenAddress
      );
      uint256 aTokenTotalSupply = IERC20(reserveCache.aTokenAddress).totalSupply();
      uint256 vTokenTotalSupply = IERC20(reserveCache.variableDebtTokenAddress).totalSupply();
      uint256 sTokenTotalSupply = IERC20(reserveCache.stableDebtTokenAddress).totalSupply();

      // calculate current accruedToTreasury
      uint256 accruedToTreasury = WadRayMath.rayMul(
        currentReserve.accruedToTreasury,
        reserveCache.nextLiquidityIndex
      );

      uint256 currentVirtualBalance = (aTokenTotalSupply + accruedToTreasury) -
        (sTokenTotalSupply + vTokenTotalSupply);
      if (balanceOfUnderlying < currentVirtualBalance) {
        currentVirtualBalance = balanceOfUnderlying;
      }
      currentReserve.virtualUnderlyingBalance = SafeCast.toUint128(currentVirtualBalance);

      DataTypes.ReserveConfigurationMap memory currentConfiguration = currentReserve.configuration;
      currentConfiguration.setVirtualAccActive(true);
      currentReserve.configuration = currentConfiguration;
    }
  }
}
