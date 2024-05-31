// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPool, DataTypes} from 'aave-v3-origin/core/contracts/interfaces/IPool.sol';
import {IPoolConfigurator} from 'aave-v3-origin/core/contracts/interfaces/IPoolConfigurator.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/core/instances/PoolConfiguratorInstance.sol';
import {DefaultReserveInterestRateStrategyV2} from 'aave-v3-origin/core/contracts/protocol/pool/DefaultReserveInterestRateStrategyV2.sol';
import {IDefaultInterestRateStrategyV2} from 'aave-v3-origin/core/contracts/interfaces/IDefaultInterestRateStrategyV2.sol';
import {AaveV3EthereumAssets, IACLManager} from 'aave-address-book/AaveV3Ethereum.sol';

interface ILegacyDefaultInterestRateStrategy {
  /**
   * @notice Returns the usage ratio at which the pool aims to obtain most competitive borrow rates.
   * @return The optimal usage ratio, expressed in ray.
   */
  function OPTIMAL_USAGE_RATIO() external view returns (uint256);

  /**
   * @notice Returns the variable rate slope below optimal usage ratio
   * @dev It's the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
   * @return The variable rate slope, expressed in ray
   */
  function getVariableRateSlope1() external view returns (uint256);

  /**
   * @notice Returns the variable rate slope above optimal usage ratio
   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
   * @return The variable rate slope, expressed in ray
   */
  function getVariableRateSlope2() external view returns (uint256);

  /**
   * @notice Returns the base variable borrow rate
   * @return The base variable borrow rate, expressed in ray
   */
  function getBaseVariableBorrowRate() external view returns (uint256);
}

contract UpgradePayload is IProposalGenericExecutor {
  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  IPoolConfigurator public immutable CONFIGURATOR;
  DefaultReserveInterestRateStrategyV2 public immutable DEFAULT_IR;

  address public immutable POOL_IMPL;
  address public immutable POOL_DATA_PROVIDER;
  address public immutable PROOF_OF_RESERVE_EXECUTOR;

  constructor(
    address poolAddressesProvider,
    address pool,
    address configurator,
    address poolImpl,
    address poolDataProvider,
    address proofOfReserveExecutor
  ) {
    POOL_ADDRESSES_PROVIDER = IPoolAddressesProvider(poolAddressesProvider);
    POOL = IPool(pool);
    CONFIGURATOR = IPoolConfigurator(configurator);
    DEFAULT_IR = new DefaultReserveInterestRateStrategyV2(address(poolAddressesProvider));
    POOL_IMPL = poolImpl;
    POOL_DATA_PROVIDER = poolDataProvider;
    PROOF_OF_RESERVE_EXECUTOR = proofOfReserveExecutor;
  }

  function execute() external {
    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(address(new PoolConfiguratorInstance()));
    POOL_ADDRESSES_PROVIDER.setPoolImpl(POOL_IMPL);
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(POOL_DATA_PROVIDER);

    address[] memory reserves = POOL.getReservesList();
    for (uint256 i = 0; i < reserves.length; i++) {
      DataTypes.ReserveData memory reserveData = POOL.getReserveDataExtended(reserves[i]);
      uint256 currentUOpt;

      if (reserves[i] == AaveV3EthereumAssets.GHO_UNDERLYING) {
        currentUOpt = DEFAULT_IR.MAX_OPTIMAL_POINT();
      } else {
        currentUOpt =
          ILegacyDefaultInterestRateStrategy(reserveData.interestRateStrategyAddress)
            .OPTIMAL_USAGE_RATIO() /
          1e23;
      }

      CONFIGURATOR.setReserveInterestRateStrategyAddress(
        reserves[i],
        address(DEFAULT_IR),
        abi.encode(
          IDefaultInterestRateStrategyV2.InterestRateData({
            optimalUsageRatio: uint16(currentUOpt),
            baseVariableBorrowRate: uint32(
              ILegacyDefaultInterestRateStrategy(reserveData.interestRateStrategyAddress)
                .getBaseVariableBorrowRate() / 1e23
            ),
            variableRateSlope1: uint32(
              ILegacyDefaultInterestRateStrategy(reserveData.interestRateStrategyAddress)
                .getVariableRateSlope1() / 1e23
            ),
            variableRateSlope2: uint32(
              ILegacyDefaultInterestRateStrategy(reserveData.interestRateStrategyAddress)
                .getVariableRateSlope2() / 1e23
            )
          })
        )
      );
    }

    if (PROOF_OF_RESERVE_EXECUTOR != address(0)) {
      IACLManager(POOL_ADDRESSES_PROVIDER.getACLManager()).removeRiskAdmin(
        PROOF_OF_RESERVE_EXECUTOR
      );
    }
  }
}
