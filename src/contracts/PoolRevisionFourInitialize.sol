// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DataTypes, PoolLogic} from 'aave-v3-origin/core/contracts/protocol/pool/Pool.sol';
import {IERC20} from 'aave-v3-origin/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import {SafeCast} from 'aave-v3-origin/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol';
import {WadRayMath} from 'aave-v3-origin/core/contracts/protocol/libraries/math/WadRayMath.sol';
import {MathUtils} from 'aave-v3-origin/core/contracts/protocol/libraries/math/MathUtils.sol';
import {ReserveConfiguration} from 'aave-v3-origin/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol';

import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

library PoolRevisionFourInitialize {
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

  function initialize(
    uint256 reservesCount,
    mapping(uint256 => address) storage _reservesList,
    mapping(address => DataTypes.ReserveData) storage _reserves
  ) external {
    address[] memory reserves = new address[](reservesCount);
    for (uint256 i = 0; i < reservesCount; i++) {
      reserves[i] = _reservesList[i];
    }
    //    PoolLogic.executeMintToTreasury(_reserves, reserves);

    for (uint256 i = 0; i < reservesCount; i++) {
      address currentReserveAddress = reserves[i];
      // if this reserve was dropped already - skip
      // GHO is the special case
      if (
        currentReserveAddress == address(0) ||
        currentReserveAddress == AaveV3EthereumAssets.GHO_UNDERLYING
      ) {
        continue;
      }

      DataTypes.ReserveData storage currentReserve = _reserves[currentReserveAddress];
      address currentAToken = currentReserve.aTokenAddress;
      uint256 balanceOfUnderlying = IERC20(currentReserveAddress).balanceOf(currentAToken);
      uint256 aTokenTotalSupply = IERC20(currentAToken).totalSupply();
      uint256 vTokenTotalSupply = IERC20(currentReserve.variableDebtTokenAddress).totalSupply();
      uint256 sTokenTotalSupply = IERC20(currentReserve.stableDebtTokenAddress).totalSupply();

      // calculate current accruedToTreasury
      uint256 cumulatedLiquidityInterest = MathUtils.calculateLinearInterest(
        currentReserve.currentLiquidityRate,
        currentReserve.lastUpdateTimestamp
      );
      uint256 nextLiquidityIndex = WadRayMath.rayMul(
        cumulatedLiquidityInterest,
        currentReserve.liquidityIndex
      );
      uint256 accruedToTreasury = WadRayMath.rayMul(
        currentReserve.accruedToTreasury,
        nextLiquidityIndex
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
