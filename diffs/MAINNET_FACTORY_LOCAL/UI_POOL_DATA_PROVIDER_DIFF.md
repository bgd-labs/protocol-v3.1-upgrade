```diff
diff --git a/./downloads/MAINNET/UI_POOL_DATA_PROVIDER.sol b/./downloads/FACTORY_LOCAL/UI_POOL_DATA_PROVIDER.sol
index 46a04a2..dd4d3da 100644
--- a/./downloads/MAINNET/UI_POOL_DATA_PROVIDER.sol
+++ b/./downloads/FACTORY_LOCAL/UI_POOL_DATA_PROVIDER.sol
@@ -1,26 +1,7 @@
-// SPDX-License-Identifier: AGPL-3.0
+// SPDX-License-Identifier: BUSL-1.1
 pragma solidity ^0.8.0 ^0.8.10;
 
-// downloads/MAINNET/UI_POOL_DATA_PROVIDER/UiPoolDataProviderV3/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol
-
-interface IEACAggregatorProxy {
-  function decimals() external view returns (uint8);
-
-  function latestAnswer() external view returns (int256);
-
-  function latestTimestamp() external view returns (uint256);
-
-  function latestRound() external view returns (uint256);
-
-  function getAnswer(uint256 roundId) external view returns (int256);
-
-  function getTimestamp(uint256 roundId) external view returns (uint256);
-
-  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
-  event NewRound(uint256 indexed roundId, address indexed startedBy);
-}
-
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
 
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
@@ -96,7 +77,7 @@ interface IERC20 {
   event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveIncentivesController.sol
 
 /**
  * @title IAaveIncentivesController
@@ -115,7 +96,7 @@ interface IAaveIncentivesController {
   function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolAddressesProvider.sol
 
 /**
  * @title IPoolAddressesProvider
@@ -342,7 +323,7 @@ interface IPoolAddressesProvider {
   function setPoolDataProvider(address newDataProvider) external;
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IPriceOracleGetter.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPriceOracleGetter.sol
 
 /**
  * @title IPriceOracleGetter
@@ -372,7 +353,7 @@ interface IPriceOracleGetter {
   function getAssetPrice(address asset) external view returns (uint256);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IScaledBalanceToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IScaledBalanceToken.sol
 
 /**
  * @title IScaledBalanceToken
@@ -444,7 +425,7 @@ interface IScaledBalanceToken {
   function getPreviousIndex(address user) external view returns (uint256);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol
 
 /**
  * @title Errors library
@@ -542,70 +523,16 @@ library Errors {
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
   string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
+  string public constant INVALID_MAXRATE = '92'; // The expect maximum borrow rate is invalid
+  string public constant WITHDRAW_TO_ATOKEN = '93'; // Withdrawing to the aToken is not allowed
+  string public constant SUPPLY_TO_ATOKEN = '94'; // Supplying to the aToken is not allowed
+  string public constant SLOPE_2_MUST_BE_GTE_SLOPE_1 = '95'; // Variable interest rate slope 2 can not be lower than slope 1
+  string public constant CALLER_NOT_RISK_OR_POOL_OR_EMERGENCY_ADMIN = '96'; // 'The caller of the function is not a risk, pool or emergency admin'
+  string public constant LIQUIDATION_GRACE_SENTINEL_CHECK_FAILED = '97'; // 'Liquidation grace sentinel validation failed'
+  string public constant INVALID_GRACE_PERIOD = '98'; // Grace period above a valid range
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/libraries/math/PercentageMath.sol
-
-/**
- * @title PercentageMath library
- * @author Aave
- * @notice Provides functions to perform percentage calculations
- * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
- * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- */
-library PercentageMath {
-  // Maximum percentage factor (100.00%)
-  uint256 internal constant PERCENTAGE_FACTOR = 1e4;
-
-  // Half percentage factor (50.00%)
-  uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;
-
-  /**
-   * @notice Executes a percentage multiplication
-   * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
-   * @param value The value of which the percentage needs to be calculated
-   * @param percentage The percentage of the value to be calculated
-   * @return result value percentmul percentage
-   */
-  function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
-    // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
-    assembly {
-      if iszero(
-        or(
-          iszero(percentage),
-          iszero(gt(value, div(sub(not(0), HALF_PERCENTAGE_FACTOR), percentage)))
-        )
-      ) {
-        revert(0, 0)
-      }
-
-      result := div(add(mul(value, percentage), HALF_PERCENTAGE_FACTOR), PERCENTAGE_FACTOR)
-    }
-  }
-
-  /**
-   * @notice Executes a percentage division
-   * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
-   * @param value The value of which the percentage needs to be calculated
-   * @param percentage The percentage of the value to be calculated
-   * @return result value percentdiv percentage
-   */
-  function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
-    // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
-    assembly {
-      if or(
-        iszero(percentage),
-        iszero(iszero(gt(value, div(sub(not(0), div(percentage, 2)), PERCENTAGE_FACTOR))))
-      ) {
-        revert(0, 0)
-      }
-
-      result := div(add(mul(value, PERCENTAGE_FACTOR), div(percentage, 2)), percentage)
-    }
-  }
-}
-
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/WadRayMath.sol
 
 /**
  * @title WadRayMath library
@@ -731,9 +658,46 @@ library WadRayMath {
   }
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/types/DataTypes.sol
 
 library DataTypes {
+  /**
+   * This exists specifically to maintain the `getReserveData()` interface, since the new, internal
+   * `ReserveData` struct includes the reserve's `virtualUnderlyingBalance`.
+   */
+  struct ReserveDataLegacy {
+    //stores the reserve configuration
+    ReserveConfigurationMap configuration;
+    //the liquidity index. Expressed in ray
+    uint128 liquidityIndex;
+    //the current supply rate. Expressed in ray
+    uint128 currentLiquidityRate;
+    //variable borrow index. Expressed in ray
+    uint128 variableBorrowIndex;
+    //the current variable borrow rate. Expressed in ray
+    uint128 currentVariableBorrowRate;
+    //the current stable borrow rate. Expressed in ray
+    uint128 currentStableBorrowRate;
+    //timestamp of last update
+    uint40 lastUpdateTimestamp;
+    //the id of the reserve. Represents the position in the list of the active reserves
+    uint16 id;
+    //aToken address
+    address aTokenAddress;
+    //stableDebtToken address
+    address stableDebtTokenAddress;
+    //variableDebtToken address
+    address variableDebtTokenAddress;
+    //address of the interest rate strategy
+    address interestRateStrategyAddress;
+    //the current treasury balance, scaled
+    uint128 accruedToTreasury;
+    //the outstanding unbacked aTokens minted through the bridging feature
+    uint128 unbacked;
+    //the outstanding debt borrowed against this asset in isolation mode
+    uint128 isolationModeTotalDebt;
+  }
+
   struct ReserveData {
     //stores the reserve configuration
     ReserveConfigurationMap configuration;
@@ -751,6 +715,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -765,6 +731,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }
 
   struct ReserveConfigurationMap {
@@ -781,13 +749,14 @@ library DataTypes {
     //bit 62: siloed borrowing enabled
     //bit 63: flashloaning enabled
     //bit 64-79: reserve factor
-    //bit 80-115 borrow cap in whole tokens, borrowCap == 0 => no cap
-    //bit 116-151 supply cap in whole tokens, supplyCap == 0 => no cap
-    //bit 152-167 liquidation protocol fee
-    //bit 168-175 eMode category
-    //bit 176-211 unbacked mint cap in whole tokens, unbackedMintCap == 0 => minting disabled
-    //bit 212-251 debt ceiling for isolation mode with (ReserveConfiguration::DEBT_CEILING_DECIMALS) decimals
-    //bit 252-255 unused
+    //bit 80-115: borrow cap in whole tokens, borrowCap == 0 => no cap
+    //bit 116-151: supply cap in whole tokens, supplyCap == 0 => no cap
+    //bit 152-167: liquidation protocol fee
+    //bit 168-175: eMode category
+    //bit 176-211: unbacked mint cap in whole tokens, unbackedMintCap == 0 => minting disabled
+    //bit 212-251: debt ceiling for isolation mode with (ReserveConfiguration::DEBT_CEILING_DECIMALS) decimals
+    //bit 252: virtual accounting is enabled for the reserve
+    //bit 253-255 unused
 
     uint256 data;
   }
@@ -922,6 +891,7 @@ library DataTypes {
     uint256 maxStableRateBorrowSizePercent;
     uint256 reservesCount;
     address addressesProvider;
+    address pool;
     uint8 userEModeCategory;
     bool isAuthorizedFlashBorrower;
   }
@@ -986,7 +956,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }
 
   struct InitReserveParams {
@@ -1000,123 +971,26 @@ library DataTypes {
   }
 }
 
-// downloads/MAINNET/UI_POOL_DATA_PROVIDER/UiPoolDataProviderV3/@aave/periphery-v3/contracts/misc/interfaces/IERC20DetailedBytes.sol
-
-interface IERC20DetailedBytes is IERC20 {
-  function name() external view returns (bytes32);
-
-  function symbol() external view returns (bytes32);
+// lib/aave-v3-origin/src/periphery/contracts/misc/interfaces/IEACAggregatorProxy.sol
 
+interface IEACAggregatorProxy {
   function decimals() external view returns (uint8);
-}
-
-// downloads/MAINNET/UI_POOL_DATA_PROVIDER/UiPoolDataProviderV3/@aave/periphery-v3/contracts/misc/interfaces/IUiPoolDataProviderV3.sol
-
-interface IUiPoolDataProviderV3 {
-  struct InterestRates {
-    uint256 variableRateSlope1;
-    uint256 variableRateSlope2;
-    uint256 stableRateSlope1;
-    uint256 stableRateSlope2;
-    uint256 baseStableBorrowRate;
-    uint256 baseVariableBorrowRate;
-    uint256 optimalUsageRatio;
-  }
 
-  struct AggregatedReserveData {
-    address underlyingAsset;
-    string name;
-    string symbol;
-    uint256 decimals;
-    uint256 baseLTVasCollateral;
-    uint256 reserveLiquidationThreshold;
-    uint256 reserveLiquidationBonus;
-    uint256 reserveFactor;
-    bool usageAsCollateralEnabled;
-    bool borrowingEnabled;
-    bool stableBorrowRateEnabled;
-    bool isActive;
-    bool isFrozen;
-    // base data
-    uint128 liquidityIndex;
-    uint128 variableBorrowIndex;
-    uint128 liquidityRate;
-    uint128 variableBorrowRate;
-    uint128 stableBorrowRate;
-    uint40 lastUpdateTimestamp;
-    address aTokenAddress;
-    address stableDebtTokenAddress;
-    address variableDebtTokenAddress;
-    address interestRateStrategyAddress;
-    //
-    uint256 availableLiquidity;
-    uint256 totalPrincipalStableDebt;
-    uint256 averageStableRate;
-    uint256 stableDebtLastUpdateTimestamp;
-    uint256 totalScaledVariableDebt;
-    uint256 priceInMarketReferenceCurrency;
-    address priceOracle;
-    uint256 variableRateSlope1;
-    uint256 variableRateSlope2;
-    uint256 stableRateSlope1;
-    uint256 stableRateSlope2;
-    uint256 baseStableBorrowRate;
-    uint256 baseVariableBorrowRate;
-    uint256 optimalUsageRatio;
-    // v3 only
-    bool isPaused;
-    bool isSiloedBorrowing;
-    uint128 accruedToTreasury;
-    uint128 unbacked;
-    uint128 isolationModeTotalDebt;
-    bool flashLoanEnabled;
-    //
-    uint256 debtCeiling;
-    uint256 debtCeilingDecimals;
-    uint8 eModeCategoryId;
-    uint256 borrowCap;
-    uint256 supplyCap;
-    // eMode
-    uint16 eModeLtv;
-    uint16 eModeLiquidationThreshold;
-    uint16 eModeLiquidationBonus;
-    address eModePriceSource;
-    string eModeLabel;
-    bool borrowableInIsolation;
-  }
+  function latestAnswer() external view returns (int256);
 
-  struct UserReserveData {
-    address underlyingAsset;
-    uint256 scaledATokenBalance;
-    bool usageAsCollateralEnabledOnUser;
-    uint256 stableBorrowRate;
-    uint256 scaledVariableDebt;
-    uint256 principalStableDebt;
-    uint256 stableBorrowLastUpdateTimestamp;
-  }
+  function latestTimestamp() external view returns (uint256);
 
-  struct BaseCurrencyInfo {
-    uint256 marketReferenceCurrencyUnit;
-    int256 marketReferenceCurrencyPriceInUsd;
-    int256 networkBaseTokenPriceInUsd;
-    uint8 networkBaseTokenPriceDecimals;
-  }
+  function latestRound() external view returns (uint256);
 
-  function getReservesList(
-    IPoolAddressesProvider provider
-  ) external view returns (address[] memory);
+  function getAnswer(uint256 roundId) external view returns (int256);
 
-  function getReservesData(
-    IPoolAddressesProvider provider
-  ) external view returns (AggregatedReserveData[] memory, BaseCurrencyInfo memory);
+  function getTimestamp(uint256 roundId) external view returns (uint256);
 
-  function getUserReservesData(
-    IPoolAddressesProvider provider,
-    address user
-  ) external view returns (UserReserveData[] memory, uint8);
+  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
+  event NewRound(uint256 indexed roundId, address indexed startedBy);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
 
 interface IERC20Detailed is IERC20 {
   function name() external view returns (string memory);
@@ -1126,7 +1000,7 @@ interface IERC20Detailed is IERC20 {
   function decimals() external view returns (uint8);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IPoolDataProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolDataProvider.sol
 
 /**
  * @title IPoolDataProvider
@@ -1365,29 +1239,170 @@ interface IPoolDataProvider {
    * @return True if FlashLoans are enabled, false otherwise
    */
   function getFlashLoanEnabled(address asset) external view returns (bool);
+
+  /**
+   * @notice Returns whether virtual accounting is enabled/not for a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return True if active, false otherwise
+   */
+  function getIsVirtualAccActive(address asset) external view returns (bool);
+
+  /**
+   * @notice Returns the virtual underlying balance of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The reserve virtual underlying balance
+   */
+  function getVirtualUnderlyingBalance(address asset) external view returns (uint256);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IReserveInterestRateStrategy.sol
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
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IAaveOracle.sol
+// lib/aave-v3-origin/src/periphery/contracts/misc/interfaces/IERC20DetailedBytes.sol
+
+interface IERC20DetailedBytes is IERC20 {
+  function name() external view returns (bytes32);
+
+  function symbol() external view returns (bytes32);
+
+  function decimals() external view returns (uint8);
+}
+
+// lib/aave-v3-origin/src/periphery/contracts/misc/interfaces/IUiPoolDataProviderV3.sol
+
+interface IUiPoolDataProviderV3 {
+  struct InterestRates {
+    uint256 variableRateSlope1;
+    uint256 variableRateSlope2;
+    uint256 stableRateSlope1;
+    uint256 stableRateSlope2;
+    uint256 baseStableBorrowRate;
+    uint256 baseVariableBorrowRate;
+    uint256 optimalUsageRatio;
+  }
+
+  struct AggregatedReserveData {
+    address underlyingAsset;
+    string name;
+    string symbol;
+    uint256 decimals;
+    uint256 baseLTVasCollateral;
+    uint256 reserveLiquidationThreshold;
+    uint256 reserveLiquidationBonus;
+    uint256 reserveFactor;
+    bool usageAsCollateralEnabled;
+    bool borrowingEnabled;
+    bool stableBorrowRateEnabled;
+    bool isActive;
+    bool isFrozen;
+    // base data
+    uint128 liquidityIndex;
+    uint128 variableBorrowIndex;
+    uint128 liquidityRate;
+    uint128 variableBorrowRate;
+    uint128 stableBorrowRate;
+    uint40 lastUpdateTimestamp;
+    address aTokenAddress;
+    address stableDebtTokenAddress;
+    address variableDebtTokenAddress;
+    address interestRateStrategyAddress;
+    //
+    uint256 availableLiquidity;
+    uint256 totalPrincipalStableDebt;
+    uint256 averageStableRate;
+    uint256 stableDebtLastUpdateTimestamp;
+    uint256 totalScaledVariableDebt;
+    uint256 priceInMarketReferenceCurrency;
+    address priceOracle;
+    uint256 variableRateSlope1;
+    uint256 variableRateSlope2;
+    uint256 stableRateSlope1;
+    uint256 stableRateSlope2;
+    uint256 baseStableBorrowRate;
+    uint256 baseVariableBorrowRate;
+    uint256 optimalUsageRatio;
+    // v3 only
+    bool isPaused;
+    bool isSiloedBorrowing;
+    uint128 accruedToTreasury;
+    uint128 unbacked;
+    uint128 isolationModeTotalDebt;
+    bool flashLoanEnabled;
+    //
+    uint256 debtCeiling;
+    uint256 debtCeilingDecimals;
+    uint8 eModeCategoryId;
+    uint256 borrowCap;
+    uint256 supplyCap;
+    // eMode
+    uint16 eModeLtv;
+    uint16 eModeLiquidationThreshold;
+    uint16 eModeLiquidationBonus;
+    address eModePriceSource;
+    string eModeLabel;
+    bool borrowableInIsolation;
+    // v3.1
+    bool virtualAccActive;
+    uint128 virtualUnderlyingBalance;
+  }
+
+  struct UserReserveData {
+    address underlyingAsset;
+    uint256 scaledATokenBalance;
+    bool usageAsCollateralEnabledOnUser;
+    uint256 stableBorrowRate;
+    uint256 scaledVariableDebt;
+    uint256 principalStableDebt;
+    uint256 stableBorrowLastUpdateTimestamp;
+  }
+
+  struct BaseCurrencyInfo {
+    uint256 marketReferenceCurrencyUnit;
+    int256 marketReferenceCurrencyPriceInUsd;
+    int256 networkBaseTokenPriceInUsd;
+    uint8 networkBaseTokenPriceDecimals;
+  }
+
+  function getReservesList(
+    IPoolAddressesProvider provider
+  ) external view returns (address[] memory);
+
+  function getReservesData(
+    IPoolAddressesProvider provider
+  ) external view returns (AggregatedReserveData[] memory, BaseCurrencyInfo memory);
+
+  function getUserReservesData(
+    IPoolAddressesProvider provider,
+    address user
+  ) external view returns (UserReserveData[] memory, uint8);
+}
+
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveOracle.sol
 
 /**
  * @title IAaveOracle
@@ -1455,7 +1470,7 @@ interface IAaveOracle is IPriceOracleGetter {
   function getFallbackOracle() external view returns (address);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol
 
 /**
  * @title IPool
@@ -1833,6 +1848,14 @@ interface IPool {
    */
   function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
 
+  /**
+   * @notice Allows a borrower to swap his debt between stable and variable mode,
+   * @dev introduce in a flavor stable rate deprecation
+   * @param asset The address of the underlying asset borrowed
+   * @param user The address of the user to be swapped
+   */
+  function swapToVariable(address asset, address user) external;
+
   /**
    * @notice Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
    * - Users can be rebalanced if the following conditions are satisfied:
@@ -1977,6 +2000,22 @@ interface IPool {
     address rateStrategyAddress
   ) external;
 
+  /**
+   * @notice Accumulates interest to all indexes of the reserve
+   * @dev Only callable by the PoolConfigurator contract
+   * @dev To be used when required by the configurator, for example when updating interest rates strategy data
+   * @param asset The address of the underlying asset of the reserve
+   */
+  function syncIndexesState(address asset) external;
+
+  /**
+   * @notice Updates interest rates on the reserve data
+   * @dev Only callable by the PoolConfigurator contract
+   * @dev To be used when required by the configurator, for example when updating interest rates strategy data
+   * @param asset The address of the underlying asset of the reserve
+   */
+  function syncRatesState(address asset) external;
+
   /**
    * @notice Sets the configuration bitmap of the reserve as a whole
    * @dev Only callable by the PoolConfigurator contract
@@ -2032,7 +2071,23 @@ interface IPool {
    * @param asset The address of the underlying asset of the reserve
    * @return The state and configuration data of the reserve
    */
-  function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
+  function getReserveData(address asset) external view returns (DataTypes.ReserveDataLegacy memory);
+
+  /**
+   * @notice Returns the state and configuration of the reserve, including extra data included with Aave v3.1
+   * @param asset The address of the underlying asset of the reserve
+   * @return The state and configuration data of the reserve with virtual accounting
+   */
+  function getReserveDataExtended(
+    address asset
+  ) external view returns (DataTypes.ReserveData memory);
+
+  /**
+   * @notice Returns the virtual underlying balance of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The reserve virtual underlying balance
+   */
+  function getVirtualUnderlyingBalance(address asset) external view returns (uint128);
 
   /**
    * @notice Validates and finalizes an aToken transfer
@@ -2060,6 +2115,13 @@ interface IPool {
    */
   function getReservesList() external view returns (address[] memory);
 
+  /**
+   * @notice Returns the number of initialized reserves
+   * @dev It includes dropped reserves
+   * @return The count
+   */
+  function getReservesCount() external view returns (uint256);
+
   /**
    * @notice Returns the address of the underlying asset of a reserve by the reserve id as stored in the DataTypes.ReserveData struct
    * @param id The id of the reserve as stored in the DataTypes.ReserveData struct
@@ -2130,6 +2192,22 @@ interface IPool {
    */
   function resetIsolationModeTotalDebt(address asset) external;
 
+  /**
+   * @notice Sets the liquidation grace period of the given asset
+   * @dev To enable a liquidation grace period, a timestamp in the future should be set,
+   *      To disable a liquidation grace period, any timestamp in the past works, like 0
+   * @param asset The address of the underlying asset to set the liquidationGracePeriod
+   * @param until Timestamp when the liquidation grace period will end
+   **/
+  function setLiquidationGracePeriod(address asset, uint40 until) external;
+
+  /**
+   * @notice Returns the liquidation grace period of the given asset
+   * @param asset The address of the underlying asset
+   * @return Timestamp when the liquidation grace period will end
+   **/
+  function getLiquidationGracePeriod(address asset) external returns (uint40);
+
   /**
    * @notice Returns the percentage of available liquidity that can be borrowed at once at stable rate
    * @return The percentage of available liquidity to borrow, expressed in bps
@@ -2187,9 +2265,44 @@ interface IPool {
    *   0 if the action is executed directly by the user, without any middle-man
    */
   function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
+
+  /**
+   * @notice Gets the address of the external FlashLoanLogic
+   */
+  function getFlashLoanLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external BorrowLogic
+   */
+  function getBorrowLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external BridgeLogic
+   */
+  function getBridgeLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external EModeLogic
+   */
+  function getEModeLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external LiquidationLogic
+   */
+  function getLiquidationLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external PoolLogic
+   */
+  function getPoolLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external SupplyLogic
+   */
+  function getSupplyLogic() external returns (address);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
 
 /**
  * @title ReserveConfiguration library
@@ -2216,6 +2329,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
 
   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -2236,6 +2350,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;
 
   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -2731,6 +2846,31 @@ library ReserveConfiguration {
     return (self.data & ~FLASHLOAN_ENABLED_MASK) != 0;
   }
 
+  /**
+   * @notice Sets the virtual account active/not state of the reserve
+   * @param self The reserve configuration
+   * @param active The active state
+   */
+  function setVirtualAccActive(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool active
+  ) internal pure {
+    self.data =
+      (self.data & VIRTUAL_ACC_ACTIVE) |
+      (uint256(active ? 1 : 0) << VIRTUAL_ACC_START_BIT_POSITION);
+  }
+
+  /**
+   * @notice Gets the virtual account active/not state of the reserve
+   * @param self The reserve configuration
+   * @return The active state
+   */
+  function getIsVirtualAccActive(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
+    return (self.data & ~VIRTUAL_ACC_ACTIVE) != 0;
+  }
+
   /**
    * @notice Gets the configuration flags of the reserve
    * @param self The reserve configuration
@@ -2797,39 +2937,74 @@ library ReserveConfiguration {
   }
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IDefaultInterestRateStrategy.sol
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
+interface IDefaultInterestRateStrategyV2 is IReserveInterestRateStrategy {
+  struct CalcInterestRatesLocalVars {
+    uint256 availableLiquidity;
+    uint256 totalDebt;
+    uint256 currentVariableBorrowRate;
+    uint256 currentLiquidityRate;
+    uint256 borrowUsageRatio;
+    uint256 supplyUsageRatio;
+    uint256 availableLiquidityPlusDebt;
+  }
 
   /**
-   * @notice Returns the optimal stable to total debt ratio of the reserve.
-   * @return The optimal stable to total debt ratio, expressed in ray.
+   * @notice Holds the interest rate data for a given reserve
+   *
+   * @dev Since values are in bps, they are multiplied by 1e23 in order to become rays with 27 decimals. This
+   * in turn means that the maximum supported interest rate is 4294967295 (2**32-1) bps or 42949672.95%.
+   *
+   * @param optimalUsageRatio The optimal usage ratio, in bps
+   * @param baseVariableBorrowRate The base variable borrow rate, in bps
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio, in bps
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio, in bps
    */
-  function OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO() external view returns (uint256);
+  struct InterestRateData {
+    uint16 optimalUsageRatio;
+    uint32 baseVariableBorrowRate;
+    uint32 variableRateSlope1;
+    uint32 variableRateSlope2;
+  }
 
   /**
-   * @notice Returns the excess usage ratio above the optimal.
-   * @dev It's always equal to 1-optimal usage ratio (added as constant for gas optimizations)
-   * @return The max excess usage ratio, expressed in ray.
+   * @notice The interest rate data, where all values are in ray (fixed-point 27 decimal numbers) for a given reserve,
+   * used in in-memory calculations.
+   *
+   * @param optimalUsageRatio The optimal usage ratio
+   * @param baseVariableBorrowRate The base variable borrow rate
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio
    */
-  function MAX_EXCESS_USAGE_RATIO() external view returns (uint256);
+  struct InterestRateDataRay {
+    uint256 optimalUsageRatio;
+    uint256 baseVariableBorrowRate;
+    uint256 variableRateSlope1;
+    uint256 variableRateSlope2;
+  }
 
   /**
-   * @notice Returns the excess stable debt ratio above the optimal.
-   * @dev It's always equal to 1-optimal stable to total debt ratio (added as constant for gas optimizations)
-   * @return The max excess stable to total debt ratio, expressed in ray.
+   * @notice emitted when new interest rate data is set in a reserve
+   *
+   * @param reserve address of the reserve that has new interest rate data set
+   * @param optimalUsageRatio The optimal usage ratio, in bps
+   * @param baseVariableBorrowRate The base variable borrow rate, in bps
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio, in bps
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio, in bps
    */
-  function MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO() external view returns (uint256);
+  event RateDataUpdate(
+    address indexed reserve,
+    uint256 optimalUsageRatio,
+    uint256 baseVariableBorrowRate,
+    uint256 variableRateSlope1,
+    uint256 variableRateSlope2
+  );
 
   /**
    * @notice Returns the address of the PoolAddressesProvider
@@ -2838,60 +3013,99 @@ interface IDefaultInterestRateStrategy is IReserveInterestRateStrategy {
   function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
 
   /**
-   * @notice Returns the variable rate slope below optimal usage ratio
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
    * @dev It's the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
-   * @return The variable rate slope, expressed in ray
+   *
+   * @param reserve The reserve to get the variable rate slope 1 of
+   *
+   * @return The variable rate slope
    */
-  function getVariableRateSlope1() external view returns (uint256);
+  function getVariableRateSlope1(address reserve) external view returns (uint256);
 
   /**
-   * @notice Returns the variable rate slope above optimal usage ratio
+   * @notice Returns the variable rate slope above optimal usage ratio in ray
    * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
-   * @return The variable rate slope, expressed in ray
+   *
+   * @param reserve The reserve to get the variable rate slope 2 of
+   *
+   * @return The variable rate slope
    */
-  function getVariableRateSlope2() external view returns (uint256);
+  function getVariableRateSlope2(address reserve) external view returns (uint256);
 
   /**
-   * @notice Returns the stable rate slope below optimal usage ratio
-   * @dev It's the stable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
-   * @return The stable rate slope, expressed in ray
+   * @notice Returns the base variable borrow rate, in ray
+   *
+   * @param reserve The reserve to get the base variable borrow rate of
+   *
+   * @return The base variable borrow rate
    */
-  function getStableRateSlope1() external view returns (uint256);
+  function getBaseVariableBorrowRate(address reserve) external view returns (uint256);
 
   /**
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
+   * @notice Returns the maximum variable borrow rate, in ray
+   *
+   * @param reserve The reserve to get the maximum variable borrow rate of
+   *
+   * @return The maximum variable borrow rate
    */
-  function getBaseVariableBorrowRate() external view returns (uint256);
+  function getMaxVariableBorrowRate(address reserve) external view returns (uint256);
 
   /**
-   * @notice Returns the maximum variable borrow rate
-   * @return The maximum variable borrow rate, expressed in ray
+   * @notice Sets interest rate data for an Aave rate strategy
+   * @param reserve The reserve to update
+   * @param rateData The reserve interest rate data to apply to the given reserve
+   *   Being specific to this custom implementation, with custom struct type,
+   *   overloading the function on the generic interface
    */
-  function getMaxVariableBorrowRate() external view returns (uint256);
+  function setInterestRateParams(address reserve, InterestRateData calldata rateData) external;
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/libraries/configuration/UserConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/UserConfiguration.sol
 
 /**
  * @title UserConfiguration library
@@ -3123,7 +3337,7 @@ library UserConfiguration {
   }
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IInitializableAToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableAToken.sol
 
 /**
  * @title IInitializableAToken
@@ -3176,7 +3390,7 @@ interface IInitializableAToken {
   ) external;
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IInitializableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableDebtToken.sol
 
 /**
  * @title IInitializableDebtToken
@@ -3225,7 +3439,7 @@ interface IInitializableDebtToken {
   ) external;
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IStableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IStableDebtToken.sol
 
 /**
  * @title IStableDebtToken
@@ -3362,7 +3576,7 @@ interface IStableDebtToken is IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IVariableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IVariableDebtToken.sol
 
 /**
  * @title IVariableDebtToken
@@ -3405,7 +3619,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/interfaces/IAToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAToken.sol
 
 /**
  * @title IAToken
@@ -3539,254 +3753,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
   function rescueTokens(address token, address to, uint256 amount) external;
 }
 
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol
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
-  struct CalcInterestRatesLocalVars {
-    uint256 availableLiquidity;
-    uint256 totalDebt;
-    uint256 currentVariableBorrowRate;
-    uint256 currentStableBorrowRate;
-    uint256 currentLiquidityRate;
-    uint256 borrowUsageRatio;
-    uint256 supplyUsageRatio;
-    uint256 stableToTotalDebtRatio;
-    uint256 availableLiquidityPlusDebt;
-  }
-
-  /// @inheritdoc IReserveInterestRateStrategy
-  function calculateInterestRates(
-    DataTypes.CalculateInterestRatesParams memory params
-  ) public view override returns (uint256, uint256, uint256) {
-    CalcInterestRatesLocalVars memory vars;
-
-    vars.totalDebt = params.totalStableDebt + params.totalVariableDebt;
-
-    vars.currentLiquidityRate = 0;
-    vars.currentVariableBorrowRate = _baseVariableBorrowRate;
-    vars.currentStableBorrowRate = getBaseStableBorrowRate();
-
-    if (vars.totalDebt != 0) {
-      vars.stableToTotalDebtRatio = params.totalStableDebt.rayDiv(vars.totalDebt);
-      vars.availableLiquidity =
-        IERC20(params.reserve).balanceOf(params.aToken) +
-        params.liquidityAdded -
-        params.liquidityTaken;
-
-      vars.availableLiquidityPlusDebt = vars.availableLiquidity + vars.totalDebt;
-      vars.borrowUsageRatio = vars.totalDebt.rayDiv(vars.availableLiquidityPlusDebt);
-      vars.supplyUsageRatio = vars.totalDebt.rayDiv(
-        vars.availableLiquidityPlusDebt + params.unbacked
-      );
-    }
-
-    if (vars.borrowUsageRatio > OPTIMAL_USAGE_RATIO) {
-      uint256 excessBorrowUsageRatio = (vars.borrowUsageRatio - OPTIMAL_USAGE_RATIO).rayDiv(
-        MAX_EXCESS_USAGE_RATIO
-      );
-
-      vars.currentStableBorrowRate +=
-        _stableRateSlope1 +
-        _stableRateSlope2.rayMul(excessBorrowUsageRatio);
-
-      vars.currentVariableBorrowRate +=
-        _variableRateSlope1 +
-        _variableRateSlope2.rayMul(excessBorrowUsageRatio);
-    } else {
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
-    }
-
-    vars.currentLiquidityRate = _getOverallBorrowRate(
-      params.totalStableDebt,
-      params.totalVariableDebt,
-      vars.currentVariableBorrowRate,
-      params.averageStableBorrowRate
-    ).rayMul(vars.supplyUsageRatio).percentMul(
-        PercentageMath.PERCENTAGE_FACTOR - params.reserveFactor
-      );
-
-    return (
-      vars.currentLiquidityRate,
-      vars.currentStableBorrowRate,
-      vars.currentVariableBorrowRate
-    );
-  }
-
-  /**
-   * @dev Calculates the overall borrow rate as the weighted average between the total variable debt and total stable
-   * debt
-   * @param totalStableDebt The total borrowed from the reserve at a stable rate
-   * @param totalVariableDebt The total borrowed from the reserve at a variable rate
-   * @param currentVariableBorrowRate The current variable borrow rate of the reserve
-   * @param currentAverageStableBorrowRate The current weighted average of all the stable rate loans
-   * @return The weighted averaged borrow rate
-   */
-  function _getOverallBorrowRate(
-    uint256 totalStableDebt,
-    uint256 totalVariableDebt,
-    uint256 currentVariableBorrowRate,
-    uint256 currentAverageStableBorrowRate
-  ) internal pure returns (uint256) {
-    uint256 totalDebt = totalStableDebt + totalVariableDebt;
-
-    if (totalDebt == 0) return 0;
-
-    uint256 weightedVariableRate = totalVariableDebt.wadToRay().rayMul(currentVariableBorrowRate);
-
-    uint256 weightedStableRate = totalStableDebt.wadToRay().rayMul(currentAverageStableBorrowRate);
-
-    uint256 overallBorrowRate = (weightedVariableRate + weightedStableRate).rayDiv(
-      totalDebt.wadToRay()
-    );
-
-    return overallBorrowRate;
-  }
-}
-
-// lib/aave-helpers/lib/aave-address-book/lib/aave-v3-core/contracts/misc/AaveProtocolDataProvider.sol
+// lib/aave-v3-origin/src/core/contracts/misc/AaveProtocolDataProvider.sol
 
 /**
  * @title AaveProtocolDataProvider
@@ -3840,7 +3807,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     address[] memory reserves = pool.getReservesList();
     TokenData[] memory aTokens = new TokenData[](reserves.length);
     for (uint256 i = 0; i < reserves.length; i++) {
-      DataTypes.ReserveData memory reserveData = pool.getReserveData(reserves[i]);
+      DataTypes.ReserveDataLegacy memory reserveData = pool.getReserveData(reserves[i]);
       aTokens[i] = TokenData({
         symbol: IERC20Detailed(reserveData.aTokenAddress).symbol(),
         tokenAddress: reserveData.aTokenAddress
@@ -3946,7 +3913,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       uint40 lastUpdateTimestamp
     )
   {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
 
@@ -3968,7 +3935,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
 
   /// @inheritdoc IPoolDataProvider
   function getATokenTotalSupply(address asset) external view override returns (uint256) {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
     return IERC20Detailed(reserve.aTokenAddress).totalSupply();
@@ -3976,7 +3943,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
 
   /// @inheritdoc IPoolDataProvider
   function getTotalDebt(address asset) external view override returns (uint256) {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
     return
@@ -4004,7 +3971,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       bool usageAsCollateralEnabled
     )
   {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
 
@@ -4037,7 +4004,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       address variableDebtTokenAddress
     )
   {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
 
@@ -4052,7 +4019,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   function getInterestRateStrategyAddress(
     address asset
   ) external view override returns (address irStrategyAddress) {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
 
@@ -4066,9 +4033,22 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
 
     return configuration.getFlashLoanEnabled();
   }
+
+  /// @inheritdoc IPoolDataProvider
+  function getIsVirtualAccActive(address asset) external view override returns (bool) {
+    DataTypes.ReserveConfigurationMap memory configuration = IPool(ADDRESSES_PROVIDER.getPool())
+      .getConfiguration(asset);
+
+    return configuration.getIsVirtualAccActive();
+  }
+
+  /// @inheritdoc IPoolDataProvider
+  function getVirtualUnderlyingBalance(address asset) external view override returns (uint256) {
+    return IPool(ADDRESSES_PROVIDER.getPool()).getVirtualUnderlyingBalance(asset);
+  }
 }
 
-// downloads/MAINNET/UI_POOL_DATA_PROVIDER/UiPoolDataProviderV3/@aave/periphery-v3/contracts/misc/UiPoolDataProviderV3.sol
+// lib/aave-v3-origin/src/periphery/contracts/misc/UiPoolDataProviderV3.sol
 
 contract UiPoolDataProviderV3 is IUiPoolDataProviderV3 {
   using WadRayMath for uint256;
@@ -4088,31 +4068,16 @@ contract UiPoolDataProviderV3 is IUiPoolDataProviderV3 {
     marketReferenceCurrencyPriceInUsdProxyAggregator = _marketReferenceCurrencyPriceInUsdProxyAggregator;
   }
 
-  function getInterestRateStrategySlopes(
-    DefaultReserveInterestRateStrategy interestRateStrategy
-  ) internal view returns (InterestRates memory) {
-    InterestRates memory interestRates;
-    interestRates.variableRateSlope1 = interestRateStrategy.getVariableRateSlope1();
-    interestRates.variableRateSlope2 = interestRateStrategy.getVariableRateSlope2();
-    interestRates.stableRateSlope1 = interestRateStrategy.getStableRateSlope1();
-    interestRates.stableRateSlope2 = interestRateStrategy.getStableRateSlope2();
-    interestRates.baseStableBorrowRate = interestRateStrategy.getBaseStableBorrowRate();
-    interestRates.baseVariableBorrowRate = interestRateStrategy.getBaseVariableBorrowRate();
-    interestRates.optimalUsageRatio = interestRateStrategy.OPTIMAL_USAGE_RATIO();
-
-    return interestRates;
-  }
-
   function getReservesList(
     IPoolAddressesProvider provider
-  ) public view override returns (address[] memory) {
+  ) external view override returns (address[] memory) {
     IPool pool = IPool(provider.getPool());
     return pool.getReservesList();
   }
 
   function getReservesData(
     IPoolAddressesProvider provider
-  ) public view override returns (AggregatedReserveData[] memory, BaseCurrencyInfo memory) {
+  ) external view override returns (AggregatedReserveData[] memory, BaseCurrencyInfo memory) {
     IAaveOracle oracle = IAaveOracle(provider.getPriceOracle());
     IPool pool = IPool(provider.getPool());
     AaveProtocolDataProvider poolDataProvider = AaveProtocolDataProvider(
@@ -4127,7 +4092,9 @@ contract UiPoolDataProviderV3 is IUiPoolDataProviderV3 {
       reserveData.underlyingAsset = reserves[i];
 
       // reserve current state
-      DataTypes.ReserveData memory baseData = pool.getReserveData(reserveData.underlyingAsset);
+      DataTypes.ReserveDataLegacy memory baseData = pool.getReserveData(
+        reserveData.underlyingAsset
+      );
       //the liquidity index. Expressed in ray
       reserveData.liquidityIndex = baseData.liquidityIndex;
       //variable borrow index. Expressed in ray
@@ -4192,17 +4159,20 @@ contract UiPoolDataProviderV3 is IUiPoolDataProviderV3 {
         reserveData.isPaused
       ) = reserveConfigurationMap.getFlags();
 
-      InterestRates memory interestRates = getInterestRateStrategySlopes(
-        DefaultReserveInterestRateStrategy(reserveData.interestRateStrategyAddress)
-      );
-
-      reserveData.variableRateSlope1 = interestRates.variableRateSlope1;
-      reserveData.variableRateSlope2 = interestRates.variableRateSlope2;
-      reserveData.stableRateSlope1 = interestRates.stableRateSlope1;
-      reserveData.stableRateSlope2 = interestRates.stableRateSlope2;
-      reserveData.baseStableBorrowRate = interestRates.baseStableBorrowRate;
-      reserveData.baseVariableBorrowRate = interestRates.baseVariableBorrowRate;
-      reserveData.optimalUsageRatio = interestRates.optimalUsageRatio;
+      // interest rates
+      try
+        IDefaultInterestRateStrategyV2(reserveData.interestRateStrategyAddress).getInterestRateData(
+          reserveData.underlyingAsset
+        )
+      returns (IDefaultInterestRateStrategyV2.InterestRateDataRay memory res) {
+        reserveData.baseVariableBorrowRate = res.baseVariableBorrowRate;
+        reserveData.variableRateSlope1 = res.variableRateSlope1;
+        reserveData.variableRateSlope2 = res.variableRateSlope2;
+        reserveData.optimalUsageRatio = res.optimalUsageRatio;
+      } catch {}
+      reserveData.stableRateSlope1 = 0;
+      reserveData.stableRateSlope2 = 0;
+      reserveData.baseStableBorrowRate = 0;
 
       // v3 only
       reserveData.eModeCategoryId = uint8(eModeCategoryId);
@@ -4234,6 +4204,22 @@ contract UiPoolDataProviderV3 is IUiPoolDataProviderV3 {
       reserveData.eModeLabel = categoryData.label;
 
       reserveData.borrowableInIsolation = reserveConfigurationMap.getBorrowableInIsolation();
+
+      try poolDataProvider.getIsVirtualAccActive(reserveData.underlyingAsset) returns (
+        bool virtualAccActive
+      ) {
+        reserveData.virtualAccActive = virtualAccActive;
+      } catch (bytes memory) {
+        reserveData.virtualAccActive = false;
+      }
+
+      try pool.getVirtualUnderlyingBalance(reserveData.underlyingAsset) returns (
+        uint128 virtualUnderlyingBalance
+      ) {
+        reserveData.virtualUnderlyingBalance = virtualUnderlyingBalance;
+      } catch (bytes memory) {
+        reserveData.virtualUnderlyingBalance = 0;
+      }
     }
 
     BaseCurrencyInfo memory baseCurrencyInfo;
@@ -4270,7 +4256,7 @@ contract UiPoolDataProviderV3 is IUiPoolDataProviderV3 {
     );
 
     for (uint256 i = 0; i < reserves.length; i++) {
-      DataTypes.ReserveData memory baseData = pool.getReserveData(reserves[i]);
+      DataTypes.ReserveDataLegacy memory baseData = pool.getReserveData(reserves[i]);
 
       // user reserve data
       userReservesData[i].underlyingAsset = reserves[i];
```
