```diff
diff --git a/./downloads/MAINNET/DEFAULT_INTEREST_RATE_STRATEGY.sol b/./downloads/FACTORY_LOCAL/DEFAULT_INTEREST_RATE_STRATEGY.sol
index 6efde60..8f5069b 100644
--- a/./downloads/MAINNET/DEFAULT_INTEREST_RATE_STRATEGY.sol
+++ b/./downloads/FACTORY_LOCAL/DEFAULT_INTEREST_RATE_STRATEGY.sol

-// downloads/MAINNET/DEFAULT_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IReserveInterestRateStrategy.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IReserveInterestRateStrategy.sol

 /**
  * @title IReserveInterestRateStrategy
- * @author Aave
- * @notice Interface for the calculation of the interest rates
+ * @author BGD Labs
+ * @notice Basic interface for any rate strategy used by the Aave protocol
  */
 interface IReserveInterestRateStrategy {
+  /**
+   * @notice Sets interest rate data for an Aave rate strategy
+   * @param reserve The reserve to update
+   * @param rateData The abi encoded reserve interest rate data to apply to the given reserve
+   *   Abstracted this way as rate strategies can be custom
+   */
+  function setInterestRateParams(address reserve, bytes calldata rateData) external;
+
   /**
    * @notice Calculates the interest rates depending on the reserve's state and configurations
    * @param params The parameters needed to calculate interest rates
-   * @return liquidityRate The liquidity rate expressed in rays
-   * @return stableBorrowRate The stable borrow rate expressed in rays
-   * @return variableBorrowRate The variable borrow rate expressed in rays
+   * @return liquidityRate The liquidity rate expressed in ray
+   * @return stableBorrowRate The stable borrow rate expressed in ray
+   * @return variableBorrowRate The variable borrow rate expressed in ray
    */
   function calculateInterestRates(
     DataTypes.CalculateInterestRatesParams memory params
   ) external view returns (uint256, uint256, uint256);
 }

-// downloads/MAINNET/DEFAULT_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IDefaultInterestRateStrategy.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IDefaultInterestRateStrategyV2.sol

 /**
- * @title IDefaultInterestRateStrategy
- * @author Aave
- * @notice Defines the basic interface of the DefaultReserveInterestRateStrategy
+ * @title IDefaultInterestRateStrategyV2
+ * @author BGD Labs
+ * @notice Interface of the default interest rate strategy used by the Aave protocol
  */
-interface IDefaultInterestRateStrategy is IReserveInterestRateStrategy {
-  /**
-   * @notice Returns the usage ratio at which the pool aims to obtain most competitive borrow rates.
-   * @return The optimal usage ratio, expressed in ray.
-   */
-  function OPTIMAL_USAGE_RATIO() external view returns (uint256);
-
-  /**
-   * @notice Returns the optimal stable to total debt ratio of the reserve.
-   * @return The optimal stable to total debt ratio, expressed in ray.
-   */
-  function OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO() external view returns (uint256);
-
-  /**
-   * @notice Returns the excess usage ratio above the optimal.
-   * @dev It's always equal to 1-optimal usage ratio (added as constant for gas optimizations)
-   * @return The max excess usage ratio, expressed in ray.
-   */
-  function MAX_EXCESS_USAGE_RATIO() external view returns (uint256);
-
-  /**
-   * @notice Returns the excess stable debt ratio above the optimal.
-   * @dev It's always equal to 1-optimal stable to total debt ratio (added as constant for gas optimizations)
-   * @return The max excess stable to total debt ratio, expressed in ray.
-   */
-  function MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO() external view returns (uint256);
-
-  /**
-   * @notice Returns the address of the PoolAddressesProvider
-   * @return The address of the PoolAddressesProvider contract
-   */
-  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
-
-  /**
-   * @notice Returns the variable rate slope below optimal usage ratio
-   * @dev It's the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
-   * @return The variable rate slope, expressed in ray
-   */
-  function getVariableRateSlope1() external view returns (uint256);
-
-  /**
-   * @notice Returns the variable rate slope above optimal usage ratio
-   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
-   * @return The variable rate slope, expressed in ray
-   */
-  function getVariableRateSlope2() external view returns (uint256);
-
-  /**
-   * @notice Returns the stable rate slope below optimal usage ratio
-   * @dev It's the stable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
-   * @return The stable rate slope, expressed in ray
-   */
-  function getStableRateSlope1() external view returns (uint256);
-
-  /**
-   * @notice Returns the stable rate slope above optimal usage ratio
-   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
-   * @return The stable rate slope, expressed in ray
-   */
-  function getStableRateSlope2() external view returns (uint256);
-
-  /**
-   * @notice Returns the stable rate excess offset
-   * @dev It's an additional premium applied to the stable when stable debt > OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO
-   * @return The stable rate excess offset, expressed in ray
-   */
-  function getStableRateExcessOffset() external view returns (uint256);
-
-  /**
-   * @notice Returns the base stable borrow rate
-   * @return The base stable borrow rate, expressed in ray
-   */
-  function getBaseStableBorrowRate() external view returns (uint256);
-
-  /**
-   * @notice Returns the base variable borrow rate
-   * @return The base variable borrow rate, expressed in ray
-   */
-  function getBaseVariableBorrowRate() external view returns (uint256);
-
-  /**
-   * @notice Returns the maximum variable borrow rate
-   * @return The maximum variable borrow rate, expressed in ray
-   */
-  function getMaxVariableBorrowRate() external view returns (uint256);
-}
-
-// downloads/MAINNET/DEFAULT_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol
-
-/**
- * @title DefaultReserveInterestRateStrategy contract
- * @author Aave
- * @notice Implements the calculation of the interest rates depending on the reserve state
- * @dev The model of interest rate is based on 2 slopes, one before the `OPTIMAL_USAGE_RATIO`
- * point of usage and another from that one to 100%.
- * - An instance of this same contract, can't be used across different Aave markets, due to the caching
- *   of the PoolAddressesProvider
- */
-contract DefaultReserveInterestRateStrategy is IDefaultInterestRateStrategy {
-  using WadRayMath for uint256;
-  using PercentageMath for uint256;
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  uint256 public immutable OPTIMAL_USAGE_RATIO;
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  uint256 public immutable OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO;
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  uint256 public immutable MAX_EXCESS_USAGE_RATIO;
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  uint256 public immutable MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO;
-
-  IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
-
-  // Base variable borrow rate when usage rate = 0. Expressed in ray
-  uint256 internal immutable _baseVariableBorrowRate;
-
-  // Slope of the variable interest curve when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO. Expressed in ray
-  uint256 internal immutable _variableRateSlope1;
-
-  // Slope of the variable interest curve when usage ratio > OPTIMAL_USAGE_RATIO. Expressed in ray
-  uint256 internal immutable _variableRateSlope2;
-
-  // Slope of the stable interest curve when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO. Expressed in ray
-  uint256 internal immutable _stableRateSlope1;
-
-  // Slope of the stable interest curve when usage ratio > OPTIMAL_USAGE_RATIO. Expressed in ray
-  uint256 internal immutable _stableRateSlope2;
-
-  // Premium on top of `_variableRateSlope1` for base stable borrowing rate
-  uint256 internal immutable _baseStableRateOffset;
-
-  // Additional premium applied to stable rate when stable debt surpass `OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO`
-  uint256 internal immutable _stableRateExcessOffset;
-
-  /**
-   * @dev Constructor.
-   * @param provider The address of the PoolAddressesProvider contract
-   * @param optimalUsageRatio The optimal usage ratio
-   * @param baseVariableBorrowRate The base variable borrow rate
-   * @param variableRateSlope1 The variable rate slope below optimal usage ratio
-   * @param variableRateSlope2 The variable rate slope above optimal usage ratio
-   * @param stableRateSlope1 The stable rate slope below optimal usage ratio
-   * @param stableRateSlope2 The stable rate slope above optimal usage ratio
-   * @param baseStableRateOffset The premium on top of variable rate for base stable borrowing rate
-   * @param stableRateExcessOffset The premium on top of stable rate when there stable debt surpass the threshold
-   * @param optimalStableToTotalDebtRatio The optimal stable debt to total debt ratio of the reserve
-   */
-  constructor(
-    IPoolAddressesProvider provider,
-    uint256 optimalUsageRatio,
-    uint256 baseVariableBorrowRate,
-    uint256 variableRateSlope1,
-    uint256 variableRateSlope2,
-    uint256 stableRateSlope1,
-    uint256 stableRateSlope2,
-    uint256 baseStableRateOffset,
-    uint256 stableRateExcessOffset,
-    uint256 optimalStableToTotalDebtRatio
-  ) {
-    require(WadRayMath.RAY >= optimalUsageRatio, Errors.INVALID_OPTIMAL_USAGE_RATIO);
-    require(
-      WadRayMath.RAY >= optimalStableToTotalDebtRatio,
-      Errors.INVALID_OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO
-    );
-    OPTIMAL_USAGE_RATIO = optimalUsageRatio;
-    MAX_EXCESS_USAGE_RATIO = WadRayMath.RAY - optimalUsageRatio;
-    OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO = optimalStableToTotalDebtRatio;
-    MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO = WadRayMath.RAY - optimalStableToTotalDebtRatio;
-    ADDRESSES_PROVIDER = provider;
-    _baseVariableBorrowRate = baseVariableBorrowRate;
-    _variableRateSlope1 = variableRateSlope1;
-    _variableRateSlope2 = variableRateSlope2;
-    _stableRateSlope1 = stableRateSlope1;
-    _stableRateSlope2 = stableRateSlope2;
-    _baseStableRateOffset = baseStableRateOffset;
-    _stableRateExcessOffset = stableRateExcessOffset;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getVariableRateSlope1() external view returns (uint256) {
-    return _variableRateSlope1;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getVariableRateSlope2() external view returns (uint256) {
-    return _variableRateSlope2;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getStableRateSlope1() external view returns (uint256) {
-    return _stableRateSlope1;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getStableRateSlope2() external view returns (uint256) {
-    return _stableRateSlope2;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getStableRateExcessOffset() external view returns (uint256) {
-    return _stableRateExcessOffset;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getBaseStableBorrowRate() public view returns (uint256) {
-    return _variableRateSlope1 + _baseStableRateOffset;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getBaseVariableBorrowRate() external view override returns (uint256) {
-    return _baseVariableBorrowRate;
-  }
-
-  /// @inheritdoc IDefaultInterestRateStrategy
-  function getMaxVariableBorrowRate() external view override returns (uint256) {
-    return _baseVariableBorrowRate + _variableRateSlope1 + _variableRateSlope2;
-  }
-
+interface IDefaultInterestRateStrategyV2 is IReserveInterestRateStrategy {
   struct CalcInterestRatesLocalVars {
     uint256 availableLiquidity;
     uint256 totalDebt;
     uint256 currentVariableBorrowRate;
-    uint256 currentStableBorrowRate;
     uint256 currentLiquidityRate;
     uint256 borrowUsageRatio;
     uint256 supplyUsageRatio;
-    uint256 stableToTotalDebtRatio;
     uint256 availableLiquidityPlusDebt;
   }

+  /**
+   * @notice Holds the interest rate data for a given reserve
+   *
+   * @dev Since values are in bps, they are multiplied by 1e23 in order to become rays with 27 decimals. This
+   * in turn means that the maximum supported interest rate is 4294967295 (2**32-1) bps or 42949672.95%.
+   *
+   * @param optimalUsageRatio The optimal usage ratio, in bps
+   * @param baseVariableBorrowRate The base variable borrow rate, in bps
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio, in bps
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio, in bps
+   */
+  struct InterestRateData {
+    uint16 optimalUsageRatio;
+    uint32 baseVariableBorrowRate;
+    uint32 variableRateSlope1;
+    uint32 variableRateSlope2;
+  }
+
+  /**
+   * @notice The interest rate data, where all values are in ray (fixed-point 27 decimal numbers) for a given reserve,
+   * used in in-memory calculations.
+   *
+   * @param optimalUsageRatio The optimal usage ratio
+   * @param baseVariableBorrowRate The base variable borrow rate
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio
+   */
+  struct InterestRateDataRay {
+    uint256 optimalUsageRatio;
+    uint256 baseVariableBorrowRate;
+    uint256 variableRateSlope1;
+    uint256 variableRateSlope2;
+  }
+
+  /**
+   * @notice emitted when new interest rate data is set in a reserve
+   *
+   * @param reserve address of the reserve that has new interest rate data set
+   * @param optimalUsageRatio The optimal usage ratio, in bps
+   * @param baseVariableBorrowRate The base variable borrow rate, in bps
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio, in bps
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio, in bps
+   */
+  event RateDataUpdate(
+    address indexed reserve,
+    uint256 optimalUsageRatio,
+    uint256 baseVariableBorrowRate,
+    uint256 variableRateSlope1,
+    uint256 variableRateSlope2
+  );
+
+  /**
+   * @notice Returns the address of the PoolAddressesProvider
+   * @return The address of the PoolAddressesProvider contract
+   */
+  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
+
+  /**
+   * @notice Returns the maximum value achievable for variable borrow rate, in bps
+   * @return The maximum rate
+   */
+  function MAX_BORROW_RATE() external view returns (uint256);
+
+  /**
+   * @notice Returns the minimum optimal point, in bps
+   * @return The optimal point
+   */
+  function MIN_OPTIMAL_POINT() external view returns (uint256);
+
+  /**
+   * @notice Returns the maximum optimal point, in bps
+   * @return The optimal point
+   */
+  function MAX_OPTIMAL_POINT() external view returns (uint256);
+
+  /**
+   * notice Returns the full InterestRateData object for the given reserve, in ray
+   *
+   * @param reserve The reserve to get the data of
+   *
+   * @return The InterestRateDataRay object for the given reserve
+   */
+  function getInterestRateData(address reserve) external view returns (InterestRateDataRay memory);
+
+  /**
+   * notice Returns the full InterestRateDataRay object for the given reserve, in bps
+   *
+   * @param reserve The reserve to get the data of
+   *
+   * @return The InterestRateData object for the given reserve
+   */
+  function getInterestRateDataBps(address reserve) external view returns (InterestRateData memory);
+
+  /**
+   * @notice Returns the optimal usage rate for the given reserve in ray
+   *
+   * @param reserve The reserve to get the optimal usage rate of
+   *
+   * @return The optimal usage rate is the level of borrow / collateral at which the borrow rate
+   */
+  function getOptimalUsageRatio(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the variable rate slope below optimal usage ratio in ray
+   * @dev It's the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
+   *
+   * @param reserve The reserve to get the variable rate slope 1 of
+   *
+   * @return The variable rate slope
+   */
+  function getVariableRateSlope1(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the variable rate slope above optimal usage ratio in ray
+   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
+   *
+   * @param reserve The reserve to get the variable rate slope 2 of
+   *
+   * @return The variable rate slope
+   */
+  function getVariableRateSlope2(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the base variable borrow rate, in ray
+   *
+   * @param reserve The reserve to get the base variable borrow rate of
+   *
+   * @return The base variable borrow rate
+   */
+  function getBaseVariableBorrowRate(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the maximum variable borrow rate, in ray
+   *
+   * @param reserve The reserve to get the maximum variable borrow rate of
+   *
+   * @return The maximum variable borrow rate
+   */
+  function getMaxVariableBorrowRate(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Sets interest rate data for an Aave rate strategy
+   * @param reserve The reserve to update
+   * @param rateData The reserve interest rate data to apply to the given reserve
+   *   Being specific to this custom implementation, with custom struct type,
+   *   overloading the function on the generic interface
+   */
+  function setInterestRateParams(address reserve, InterestRateData calldata rateData) external;
+}
+
+// lib/aave-v3-origin/src/core/contracts/protocol/pool/DefaultReserveInterestRateStrategyV2.sol
+
+/**
+ * @title DefaultReserveInterestRateStrategyV2 contract
+ * @author BGD Labs
+ * @notice Default interest rate strategy used by the Aave protocol
+ * @dev Strategies are pool-specific: each contract CAN'T be used across different Aave pools
+ *   due to the caching of the PoolAddressesProvider and the usage of underlying addresses as
+ *   index of the _interestRateData
+ */
+contract DefaultReserveInterestRateStrategyV2 is IDefaultInterestRateStrategyV2 {
+  using WadRayMath for uint256;
+  using PercentageMath for uint256;
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  uint256 public constant MAX_BORROW_RATE = 1000_00;
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  uint256 public constant MIN_OPTIMAL_POINT = 1_00;
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  uint256 public constant MAX_OPTIMAL_POINT = 99_00;
+
+  /// @dev Underlying asset listed on the Aave pool => rate data
+  mapping(address reserve => InterestRateData) internal _interestRateData;
+
+  /**
+   * @param provider The address of the PoolAddressesProvider of the associated Aave pool
+   */
+  constructor(address provider) {
+    require(provider != address(0), Errors.INVALID_ADDRESSES_PROVIDER);
+    ADDRESSES_PROVIDER = IPoolAddressesProvider(provider);
+  }
+
+  modifier onlyPoolConfigurator() {
+    require(
+      msg.sender == ADDRESSES_PROVIDER.getPoolConfigurator(),
+      Errors.CALLER_NOT_POOL_CONFIGURATOR
+    );
+    _;
+  }
+
+  /// @inheritdoc IReserveInterestRateStrategy
+  function setInterestRateParams(
+    address reserve,
+    bytes calldata rateData
+  ) external onlyPoolConfigurator {
+    _setInterestRateParams(reserve, abi.decode(rateData, (InterestRateData)));
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function setInterestRateParams(
+    address reserve,
+    InterestRateData calldata rateData
+  ) external onlyPoolConfigurator {
+    _setInterestRateParams(reserve, rateData);
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getInterestRateData(address reserve) external view returns (InterestRateDataRay memory) {
+    return _rayifyRateData(_interestRateData[reserve]);
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getInterestRateDataBps(address reserve) external view returns (InterestRateData memory) {
+    return _interestRateData[reserve];
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getOptimalUsageRatio(address reserve) external view returns (uint256) {
+    return _bpsToRay(uint256(_interestRateData[reserve].optimalUsageRatio));
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getVariableRateSlope1(address reserve) external view returns (uint256) {
+    return _bpsToRay(uint256(_interestRateData[reserve].variableRateSlope1));
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getVariableRateSlope2(address reserve) external view returns (uint256) {
+    return _bpsToRay(uint256(_interestRateData[reserve].variableRateSlope2));
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getBaseVariableBorrowRate(address reserve) external view override returns (uint256) {
+    return _bpsToRay(uint256(_interestRateData[reserve].baseVariableBorrowRate));
+  }
+
+  /// @inheritdoc IDefaultInterestRateStrategyV2
+  function getMaxVariableBorrowRate(address reserve) external view override returns (uint256) {
+    return
+      _bpsToRay(
+        uint256(
+          _interestRateData[reserve].baseVariableBorrowRate +
+            _interestRateData[reserve].variableRateSlope1 +
+            _interestRateData[reserve].variableRateSlope2
+        )
+      );
+  }
+
   /// @inheritdoc IReserveInterestRateStrategy
   function calculateInterestRates(
     DataTypes.CalculateInterestRatesParams memory params
-  ) public view override returns (uint256, uint256, uint256) {
+  ) external view virtual override returns (uint256, uint256, uint256) {
+    InterestRateDataRay memory rateData = _rayifyRateData(_interestRateData[params.reserve]);
+
+    // @note This is a short circuit to allow mintable assets, which by definition cannot be supplied
+    // and thus do not use virtual underlying balances.
+    if (!params.usingVirtualBalance) {
+      return (0, 0, rateData.baseVariableBorrowRate);
+    }
+
     CalcInterestRatesLocalVars memory vars;

     vars.totalDebt = params.totalStableDebt + params.totalVariableDebt;

     vars.currentLiquidityRate = 0;
-    vars.currentVariableBorrowRate = _baseVariableBorrowRate;
-    vars.currentStableBorrowRate = getBaseStableBorrowRate();
+    vars.currentVariableBorrowRate = rateData.baseVariableBorrowRate;

     if (vars.totalDebt != 0) {
-      vars.stableToTotalDebtRatio = params.totalStableDebt.rayDiv(vars.totalDebt);
       vars.availableLiquidity =
-        IERC20(params.reserve).balanceOf(params.aToken) +
+        params.virtualUnderlyingBalance +
         params.liquidityAdded -
         params.liquidityTaken;

@@ -1143,34 +1240,23 @@ contract DefaultReserveInterestRateStrategy is IDefaultInterestRateStrategy {
       vars.supplyUsageRatio = vars.totalDebt.rayDiv(
         vars.availableLiquidityPlusDebt + params.unbacked
       );
+    } else {
+      return (0, 0, vars.currentVariableBorrowRate);
     }

-    if (vars.borrowUsageRatio > OPTIMAL_USAGE_RATIO) {
-      uint256 excessBorrowUsageRatio = (vars.borrowUsageRatio - OPTIMAL_USAGE_RATIO).rayDiv(
-        MAX_EXCESS_USAGE_RATIO
+    if (vars.borrowUsageRatio > rateData.optimalUsageRatio) {
+      uint256 excessBorrowUsageRatio = (vars.borrowUsageRatio - rateData.optimalUsageRatio).rayDiv(
+        WadRayMath.RAY - rateData.optimalUsageRatio
       );

-      vars.currentStableBorrowRate +=
-        _stableRateSlope1 +
-        _stableRateSlope2.rayMul(excessBorrowUsageRatio);
-
       vars.currentVariableBorrowRate +=
-        _variableRateSlope1 +
-        _variableRateSlope2.rayMul(excessBorrowUsageRatio);
+        rateData.variableRateSlope1 +
+        rateData.variableRateSlope2.rayMul(excessBorrowUsageRatio);
     } else {
-      vars.currentStableBorrowRate += _stableRateSlope1.rayMul(vars.borrowUsageRatio).rayDiv(
-        OPTIMAL_USAGE_RATIO
-      );
-
-      vars.currentVariableBorrowRate += _variableRateSlope1.rayMul(vars.borrowUsageRatio).rayDiv(
-        OPTIMAL_USAGE_RATIO
-      );
-    }
-
-    if (vars.stableToTotalDebtRatio > OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO) {
-      uint256 excessStableDebtRatio = (vars.stableToTotalDebtRatio -
-        OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO).rayDiv(MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO);
-      vars.currentStableBorrowRate += _stableRateExcessOffset.rayMul(excessStableDebtRatio);
+      vars.currentVariableBorrowRate += rateData
+        .variableRateSlope1
+        .rayMul(vars.borrowUsageRatio)
+        .rayDiv(rateData.optimalUsageRatio);
     }

     vars.currentLiquidityRate = _getOverallBorrowRate(
@@ -1182,11 +1268,7 @@ contract DefaultReserveInterestRateStrategy is IDefaultInterestRateStrategy {
         PercentageMath.PERCENTAGE_FACTOR - params.reserveFactor
       );

-    return (
-      vars.currentLiquidityRate,
-      vars.currentStableBorrowRate,
-      vars.currentVariableBorrowRate
-    );
+    return (vars.currentLiquidityRate, 0, vars.currentVariableBorrowRate);
   }

   /**
@@ -1206,8 +1288,6 @@ contract DefaultReserveInterestRateStrategy is IDefaultInterestRateStrategy {
   ) internal pure returns (uint256) {
     uint256 totalDebt = totalStableDebt + totalVariableDebt;

-    if (totalDebt == 0) return 0;
-
     uint256 weightedVariableRate = totalVariableDebt.wadToRay().rayMul(currentVariableBorrowRate);

     uint256 weightedStableRate = totalStableDebt.wadToRay().rayMul(currentAverageStableBorrowRate);
@@ -1218,4 +1298,67 @@ contract DefaultReserveInterestRateStrategy is IDefaultInterestRateStrategy {

     return overallBorrowRate;
   }
+
+  /**
+   * @dev Doing validations and data update for an asset
+   * @param reserve address of the underlying asset of the reserve
+   * @param rateData Encoded eserve interest rate data to apply
+   */
+  function _setInterestRateParams(address reserve, InterestRateData memory rateData) internal {
+    require(reserve != address(0), Errors.ZERO_ADDRESS_NOT_VALID);
+
+    require(
+      rateData.optimalUsageRatio <= MAX_OPTIMAL_POINT &&
+        rateData.optimalUsageRatio >= MIN_OPTIMAL_POINT,
+      Errors.INVALID_OPTIMAL_USAGE_RATIO
+    );
+
+    require(
+      rateData.variableRateSlope1 <= rateData.variableRateSlope2,
+      Errors.SLOPE_2_MUST_BE_GTE_SLOPE_1
+    );
+
+    // The maximum rate should not be above certain threshold
+    require(
+      uint256(rateData.baseVariableBorrowRate) +
+        uint256(rateData.variableRateSlope1) +
+        uint256(rateData.variableRateSlope2) <=
+        MAX_BORROW_RATE,
+      Errors.INVALID_MAXRATE
+    );
+
+    _interestRateData[reserve] = rateData;
+    emit RateDataUpdate(
+      reserve,
+      rateData.optimalUsageRatio,
+      rateData.baseVariableBorrowRate,
+      rateData.variableRateSlope1,
+      rateData.variableRateSlope2
+    );
+  }
+
+  /**
+   * @dev Transforms an InterestRateData struct to an InterestRateDataRay struct by multiplying all values
+   * by 1e23, turning them into ray values
+   *
+   * @param data The InterestRateData struct to transform
+   *
+   * @return The resulting InterestRateDataRay struct
+   */
+  function _rayifyRateData(
+    InterestRateData memory data
+  ) internal pure returns (InterestRateDataRay memory) {
+    return
+      InterestRateDataRay({
+        optimalUsageRatio: _bpsToRay(uint256(data.optimalUsageRatio)),
+        baseVariableBorrowRate: _bpsToRay(uint256(data.baseVariableBorrowRate)),
+        variableRateSlope1: _bpsToRay(uint256(data.variableRateSlope1)),
+        variableRateSlope2: _bpsToRay(uint256(data.variableRateSlope2))
+      });
+  }
+
+  // @dev helper function added here, as generally the protocol doesn't use bps
+  function _bpsToRay(uint256 n) internal pure returns (uint256) {
+    return n * 1e23;
+  }
 }
```
