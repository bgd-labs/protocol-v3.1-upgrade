```diff
diff --git a/./downloads/MAINNET/POOL_IMPL.sol b/./downloads/FACTORY_LOCAL/POOL_IMPL.sol
index a6fb24f..9faf316 100644
--- a/./downloads/MAINNET/POOL_IMPL.sol
+++ b/./downloads/FACTORY_LOCAL/POOL_IMPL.sol

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol

 /**
  * @title Errors library
@@ -1189,9 +1189,16 @@ library Errors {
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

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/types/DataTypes.sol
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
@@ -1398,6 +1442,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -1412,6 +1458,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }

   struct ReserveConfigurationMap {
@@ -1428,13 +1476,14 @@ library DataTypes {
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
@@ -1634,7 +1683,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }

   struct InitReserveParams {
@@ -1648,7 +1698,7 @@ library DataTypes {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/interfaces/IReserveInterestRateStrategy.sol
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

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/math/MathUtils.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/MathUtils.sol

 /**
  * @title MathUtils library
@@ -2157,7 +2215,7 @@ library MathUtils {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol

 /**
  * @title IPool
@@ -2535,6 +2593,14 @@ interface IPool {
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
@@ -2679,6 +2745,22 @@ interface IPool {
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
@@ -2734,7 +2816,23 @@ interface IPool {
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
@@ -2839,6 +2937,22 @@ interface IPool {
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
@@ -2896,9 +3010,44 @@ interface IPool {
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

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol

 /**
  * @title ReserveConfiguration library
@@ -2925,6 +3074,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore

   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -2945,6 +3095,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;

   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -3440,6 +3591,31 @@ library ReserveConfiguration {
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
@@ -3506,7 +3682,7 @@ library ReserveConfiguration {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/ReserveLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ReserveLogic.sol

 /**
  * @title ReserveLogic library
@@ -4670,7 +4846,7 @@ library ReserveLogic {
     reserve.interestRateStrategyAddress = interestRateStrategyAddress;
   }

-  struct UpdateInterestRatesLocalVars {
+  struct UpdateInterestRatesAndVirtualBalanceLocalVars {
     uint256 nextLiquidityRate;
     uint256 nextStableRate;
     uint256 nextVariableRate;
@@ -4685,14 +4861,14 @@ library ReserveLogic {
    * @param liquidityAdded The amount of liquidity added to the protocol (supply or repay) in the previous action
    * @param liquidityTaken The amount of liquidity taken from the protocol (redeem or borrow)
    */
-  function updateInterestRates(
+  function updateInterestRatesAndVirtualBalance(
     DataTypes.ReserveData storage reserve,
     DataTypes.ReserveCache memory reserveCache,
     address reserveAddress,
     uint256 liquidityAdded,
     uint256 liquidityTaken
   ) internal {
-    UpdateInterestRatesLocalVars memory vars;
+    UpdateInterestRatesAndVirtualBalanceLocalVars memory vars;

     vars.totalVariableDebt = reserveCache.nextScaledVariableDebt.rayMul(
       reserveCache.nextVariableBorrowIndex
@@ -4712,7 +4888,8 @@ library ReserveLogic {
         averageStableBorrowRate: reserveCache.nextAvgStableBorrowRate,
         reserveFactor: reserveCache.reserveFactor,
         reserve: reserveAddress,
-        aToken: reserveCache.aTokenAddress
+        usingVirtualBalance: reserve.configuration.getIsVirtualAccActive(),
+        virtualUnderlyingBalance: reserve.virtualUnderlyingBalance
       })
     );

@@ -4720,6 +4897,16 @@ library ReserveLogic {
     reserve.currentStableBorrowRate = vars.nextStableRate.toUint128();
     reserve.currentVariableBorrowRate = vars.nextVariableRate.toUint128();

+    // Only affect virtual balance if the reserve uses it
+    if (reserve.configuration.getIsVirtualAccActive()) {
+      if (liquidityAdded > 0) {
+        reserve.virtualUnderlyingBalance += liquidityAdded.toUint128();
+      }
+      if (liquidityTaken > 0) {
+        reserve.virtualUnderlyingBalance -= liquidityTaken.toUint128();
+      }
+    }
+
     emit ReserveDataUpdated(
       reserveAddress,
       vars.nextLiquidityRate,
@@ -4877,7 +5064,7 @@ library ReserveLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/ValidationLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ValidationLogic.sol

 /**
  * @title ReserveLogic library
@@ -5327,7 +5514,8 @@ library ValidationLogic {
   function validateSupply(
     DataTypes.ReserveCache memory reserveCache,
     DataTypes.ReserveData storage reserve,
-    uint256 amount
+    uint256 amount,
+    address onBehalfOf
   ) internal view {
     require(amount != 0, Errors.INVALID_AMOUNT);

@@ -5337,6 +5525,7 @@ library ValidationLogic {
     require(isActive, Errors.RESERVE_INACTIVE);
     require(!isPaused, Errors.RESERVE_PAUSED);
     require(!isFrozen, Errors.RESERVE_FROZEN);
+    require(onBehalfOf != reserveCache.aTokenAddress, Errors.SUPPLY_TO_ATOKEN);

     uint256 supplyCap = reserveCache.reserveConfiguration.getSupplyCap();
     require(
@@ -5419,6 +5608,11 @@ library ValidationLogic {
     require(!vars.isPaused, Errors.RESERVE_PAUSED);
     require(!vars.isFrozen, Errors.RESERVE_FROZEN);
     require(vars.borrowingEnabled, Errors.BORROWING_NOT_ENABLED);
+    require(
+      !params.reserveCache.reserveConfiguration.getIsVirtualAccActive() ||
+        IERC20(params.reserveCache.aTokenAddress).totalSupply() >= params.amount,
+      Errors.INVALID_AMOUNT
+    );

     require(
       params.priceOracleSentinel == address(0) ||
@@ -5546,7 +5740,7 @@ library ValidationLogic {
         Errors.COLLATERAL_SAME_AS_BORROWING_CURRENCY
       );

-      vars.availableLiquidity = IERC20(params.asset).balanceOf(params.reserveCache.aTokenAddress);
+      vars.availableLiquidity = reservesData[params.asset].virtualUnderlyingBalance;

       //calculate the max available loan size in stable rate mode as a percentage of the
       //available liquidity
@@ -5622,12 +5816,11 @@ library ValidationLogic {
     uint256 variableDebt,
     DataTypes.InterestRateMode currentRateMode
   ) internal view {
-    (bool isActive, bool isFrozen, , bool stableRateEnabled, bool isPaused) = reserveCache
+    (bool isActive, , , bool stableRateEnabled, bool isPaused) = reserveCache
       .reserveConfiguration
       .getFlags();
     require(isActive, Errors.RESERVE_INACTIVE);
     require(!isPaused, Errors.RESERVE_PAUSED);
-    require(!isFrozen, Errors.RESERVE_FROZEN);

     if (currentRateMode == DataTypes.InterestRateMode.STABLE) {
       require(stableDebt != 0, Errors.NO_OUTSTANDING_STABLE_DEBT);
@@ -5685,7 +5878,8 @@ library ValidationLogic {
           averageStableBorrowRate: 0,
           reserveFactor: reserveCache.reserveFactor,
           reserve: reserveAddress,
-          aToken: reserveCache.aTokenAddress
+          usingVirtualBalance: reserve.configuration.getIsVirtualAccActive(),
+          virtualUnderlyingBalance: reserve.virtualUnderlyingBalance
         })
       );

@@ -5725,7 +5919,7 @@ library ValidationLogic {
   ) internal view {
     require(assets.length == amounts.length, Errors.INCONSISTENT_FLASHLOAN_PARAMS);
     for (uint256 i = 0; i < assets.length; i++) {
-      validateFlashloanSimple(reservesData[assets[i]]);
+      validateFlashloanSimple(reservesData[assets[i]], amounts[i]);
     }
   }

@@ -5733,11 +5927,19 @@ library ValidationLogic {
    * @notice Validates a flashloan action.
    * @param reserve The state of the reserve
    */
-  function validateFlashloanSimple(DataTypes.ReserveData storage reserve) internal view {
+  function validateFlashloanSimple(
+    DataTypes.ReserveData storage reserve,
+    uint256 amount
+  ) internal view {
     DataTypes.ReserveConfigurationMap memory configuration = reserve.configuration;
     require(!configuration.getPaused(), Errors.RESERVE_PAUSED);
     require(configuration.getActive(), Errors.RESERVE_INACTIVE);
     require(configuration.getFlashLoanEnabled(), Errors.FLASHLOAN_DISABLED);
+    require(
+      !configuration.getIsVirtualAccActive() ||
+        IERC20(reserve.aTokenAddress).totalSupply() >= amount,
+      Errors.INVALID_AMOUNT
+    );
   }

   struct ValidateLiquidationCallLocalVars {
@@ -5752,11 +5954,13 @@ library ValidationLogic {
    * @notice Validates the liquidation action.
    * @param userConfig The user configuration mapping
    * @param collateralReserve The reserve data of the collateral
+   * @param debtReserve The reserve data of the debt
    * @param params Additional parameters needed for the validation
    */
   function validateLiquidationCall(
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ReserveData storage collateralReserve,
+    DataTypes.ReserveData storage debtReserve,
     DataTypes.ValidateLiquidationCallParams memory params
   ) internal view {
     ValidateLiquidationCallLocalVars memory vars;
@@ -5780,6 +5984,12 @@ library ValidationLogic {
       Errors.PRICE_ORACLE_SENTINEL_CHECK_FAILED
     );

+    require(
+      collateralReserve.liquidationGracePeriodUntil < uint40(block.timestamp) &&
+        debtReserve.liquidationGracePeriodUntil < uint40(block.timestamp),
+      Errors.LIQUIDATION_GRACE_SENTINEL_CHECK_FAILED
+    );
+
     require(
       params.healthFactor < HEALTH_FACTOR_LIQUIDATION_THRESHOLD,
       Errors.HEALTH_FACTOR_NOT_BELOW_THRESHOLD
@@ -6016,7 +6226,7 @@ library ValidationLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/BridgeLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BridgeLogic.sol

 library BridgeLogic {
   using ReserveLogic for DataTypes.ReserveCache;
@@ -6067,7 +6277,7 @@ library BridgeLogic {

     reserve.updateState(reserveCache);

-    ValidationLogic.validateSupply(reserveCache, reserve, amount);
+    ValidationLogic.validateSupply(reserveCache, reserve, amount, onBehalfOf);

     uint256 unbackedMintCap = reserveCache.reserveConfiguration.getUnbackedMintCap();
     uint256 reserveDecimals = reserveCache.reserveConfiguration.getDecimals();
@@ -6079,7 +6289,7 @@ library BridgeLogic {
       Errors.UNBACKED_MINT_CAP_EXCEEDED
     );

-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);

     bool isFirstSupply = IAToken(reserveCache.aTokenAddress).mint(
       msg.sender,
@@ -6143,7 +6353,7 @@ library BridgeLogic {
     reserve.accruedToTreasury += feeToProtocol.rayDiv(reserveCache.nextLiquidityIndex).toUint128();

     reserve.unbacked -= backingAmount.toUint128();
-    reserve.updateInterestRates(reserveCache, asset, added, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, added, 0);

     IERC20(asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, added);

@@ -6153,7 +6363,7 @@ library BridgeLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/PoolLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/PoolLogic.sol

 /**
  * @title PoolLogic library
@@ -6265,6 +6475,20 @@ library PoolLogic {
     emit IsolationModeTotalDebtUpdated(asset, 0);
   }

+  /**
+   * @notice Sets the liquidation grace period of the asset
+   * @param reservesData The state of all the reserves
+   * @param asset The address of the underlying asset to set the liquidationGracePeriod
+   * @param until Timestamp when the liquidation grace period will end
+   */
+  function executeSetLiquidationGracePeriod(
+    mapping(address => DataTypes.ReserveData) storage reservesData,
+    address asset,
+    uint40 until
+  ) external {
+    reservesData[asset].liquidationGracePeriodUntil = until;
+  }
+
   /**
    * @notice Drop a reserve
    * @param reservesData The state of all the reserves
@@ -6329,7 +6553,7 @@ library PoolLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/SupplyLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/SupplyLogic.sol

 /**
  * @title SupplyLogic library
@@ -6378,9 +6602,9 @@ library SupplyLogic {

     reserve.updateState(reserveCache);

-    ValidationLogic.validateSupply(reserveCache, reserve, params.amount);
+    ValidationLogic.validateSupply(reserveCache, reserve, params.amount, params.onBehalfOf);

-    reserve.updateInterestRates(reserveCache, params.asset, params.amount, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, params.asset, params.amount, 0);

     IERC20(params.asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, params.amount);

@@ -6431,6 +6655,8 @@ library SupplyLogic {
     DataTypes.ReserveData storage reserve = reservesData[params.asset];
     DataTypes.ReserveCache memory reserveCache = reserve.cache();

+    require(params.to != reserveCache.aTokenAddress, Errors.WITHDRAW_TO_ATOKEN);
+
     reserve.updateState(reserveCache);

     uint256 userBalance = IAToken(reserveCache.aTokenAddress).scaledBalanceOf(msg.sender).rayMul(
@@ -6445,7 +6671,7 @@ library SupplyLogic {

     ValidationLogic.validateWithdraw(reserveCache, amountToWithdraw, userBalance);

-    reserve.updateInterestRates(reserveCache, params.asset, 0, amountToWithdraw);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, params.asset, 0, amountToWithdraw);

     bool isCollateral = userConfig.isUsingAsCollateral(reserve.id);

@@ -6504,8 +6730,9 @@ library SupplyLogic {
     ValidationLogic.validateTransfer(reserve);

     uint256 reserveId = reserve.id;
+    uint256 scaledAmount = params.amount.rayDiv(reserve.getNormalizedIncome());

-    if (params.from != params.to && params.amount != 0) {
+    if (params.from != params.to && scaledAmount != 0) {
       DataTypes.UserConfigurationMap storage fromConfig = usersConfig[params.from];

       if (fromConfig.isUsingAsCollateral(reserveId)) {
@@ -6614,7 +6841,7 @@ library SupplyLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol

 /**
  * @title BorrowLogic library
@@ -6653,6 +6880,7 @@ library BorrowLogic {
     DataTypes.InterestRateMode interestRateMode
   );
   event IsolationModeTotalDebtUpdated(address indexed asset, uint256 totalDebt);
+  event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);

   /**
    * @notice Implements the borrow feature. Borrowing allows users that provided collateral to draw liquidity from the
@@ -6671,7 +6899,7 @@ library BorrowLogic {
     mapping(uint8 => DataTypes.EModeCategory) storage eModeCategories,
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ExecuteBorrowParams memory params
-  ) public {
+  ) external {
     DataTypes.ReserveData storage reserve = reservesData[params.asset];
     DataTypes.ReserveCache memory reserveCache = reserve.cache();

@@ -6743,7 +6971,7 @@ library BorrowLogic {
       );
     }

-    reserve.updateInterestRates(
+    reserve.updateInterestRatesAndVirtualBalance(
       reserveCache,
       params.asset,
       0,
@@ -6825,7 +7053,7 @@ library BorrowLogic {
       ).burn(params.onBehalfOf, paybackAmount, reserveCache.nextVariableBorrowIndex);
     }

-    reserve.updateInterestRates(
+    reserve.updateInterestRatesAndVirtualBalance(
       reserveCache,
       params.asset,
       params.useATokens ? 0 : paybackAmount,
@@ -6851,6 +7079,11 @@ library BorrowLogic {
         paybackAmount,
         reserveCache.nextLiquidityIndex
       );
+      // in case of aToken repayment the msg.sender must always repay on behalf of itself
+      if (IAToken(reserveCache.aTokenAddress).scaledBalanceOf(msg.sender) == 0) {
+        userConfig.setUsingAsCollateral(reserve.id, false);
+        emit ReserveUsedAsCollateralDisabled(params.asset, msg.sender);
+      }
     } else {
       IERC20(params.asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, paybackAmount);
       IAToken(reserveCache.aTokenAddress).handleRepayment(
@@ -6892,7 +7125,7 @@ library BorrowLogic {
     (, reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = stableDebtToken
       .mint(user, user, stableDebt, reserve.currentStableBorrowRate);

-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);

     emit RebalanceStableBorrowRate(asset, user);
   }
@@ -6909,16 +7142,14 @@ library BorrowLogic {
     DataTypes.ReserveData storage reserve,
     DataTypes.UserConfigurationMap storage userConfig,
     address asset,
+    address user,
     DataTypes.InterestRateMode interestRateMode
   ) external {
     DataTypes.ReserveCache memory reserveCache = reserve.cache();

     reserve.updateState(reserveCache);

-    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(
-      msg.sender,
-      reserveCache
-    );
+    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(user, reserveCache);

     ValidationLogic.validateSwapRateMode(
       reserve,
@@ -6932,28 +7163,28 @@ library BorrowLogic {
     if (interestRateMode == DataTypes.InterestRateMode.STABLE) {
       (reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = IStableDebtToken(
         reserveCache.stableDebtTokenAddress
-      ).burn(msg.sender, stableDebt);
+      ).burn(user, stableDebt);

       (, reserveCache.nextScaledVariableDebt) = IVariableDebtToken(
         reserveCache.variableDebtTokenAddress
-      ).mint(msg.sender, msg.sender, stableDebt, reserveCache.nextVariableBorrowIndex);
+      ).mint(user, user, stableDebt, reserveCache.nextVariableBorrowIndex);
     } else {
       reserveCache.nextScaledVariableDebt = IVariableDebtToken(
         reserveCache.variableDebtTokenAddress
-      ).burn(msg.sender, variableDebt, reserveCache.nextVariableBorrowIndex);
+      ).burn(user, variableDebt, reserveCache.nextVariableBorrowIndex);

       (, reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = IStableDebtToken(
         reserveCache.stableDebtTokenAddress
-      ).mint(msg.sender, msg.sender, variableDebt, reserve.currentStableBorrowRate);
+      ).mint(user, user, variableDebt, reserve.currentStableBorrowRate);
     }

-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);

-    emit SwapBorrowRateMode(asset, msg.sender, interestRateMode);
+    emit SwapBorrowRateMode(asset, user, interestRateMode);
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/LiquidationLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/LiquidationLogic.sol

 /**
  * @title LiquidationLogic library
@@ -7066,6 +7297,7 @@ library LiquidationLogic {
     ValidationLogic.validateLiquidationCall(
       userConfig,
       collateralReserve,
+      debtReserve,
       DataTypes.ValidateLiquidationCallParams({
         debtReserveCache: vars.debtReserveCache,
         totalDebt: vars.userTotalDebt,
@@ -7114,7 +7346,7 @@ library LiquidationLogic {

     _burnDebtTokens(params, vars);

-    debtReserve.updateInterestRates(
+    debtReserve.updateInterestRatesAndVirtualBalance(
       vars.debtReserveCache,
       params.debtAsset,
       vars.actualDebtToLiquidate,
@@ -7191,7 +7423,7 @@ library LiquidationLogic {
   ) internal {
     DataTypes.ReserveCache memory collateralReserveCache = collateralReserve.cache();
     collateralReserve.updateState(collateralReserveCache);
-    collateralReserve.updateInterestRates(
+    collateralReserve.updateInterestRatesAndVirtualBalance(
       collateralReserveCache,
       params.collateralAsset,
       0,
@@ -7462,7 +7694,7 @@ library LiquidationLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/FlashLoanLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/FlashLoanLogic.sol

 /**
  * @title FlashLoanLogic library
@@ -7541,6 +7773,13 @@ library FlashLoanLogic {
         DataTypes.InterestRateMode.NONE
         ? vars.currentAmount.percentMul(vars.flashloanPremiumTotal)
         : 0;
+
+      if (reservesData[params.assets[vars.i]].configuration.getIsVirtualAccActive()) {
+        reservesData[params.assets[vars.i]].virtualUnderlyingBalance -= vars
+          .currentAmount
+          .toUint128();
+      }
+
       IAToken(reservesData[params.assets[vars.i]].aTokenAddress).transferUnderlyingTo(
         params.receiverAddress,
         vars.currentAmount
@@ -7634,10 +7873,15 @@ library FlashLoanLogic {
     // is altered to (validation -> user payload -> cache -> updateState -> changeState -> updateRates) for flashloans.
     // This is done to protect against reentrance and rate manipulation within the user specified payload.

-    ValidationLogic.validateFlashloanSimple(reserve);
+    ValidationLogic.validateFlashloanSimple(reserve, params.amount);

     IFlashLoanSimpleReceiver receiver = IFlashLoanSimpleReceiver(params.receiverAddress);
     uint256 totalPremium = params.amount.percentMul(params.flashLoanPremiumTotal);
+
+    if (reserve.configuration.getIsVirtualAccActive()) {
+      reserve.virtualUnderlyingBalance -= params.amount.toUint128();
+    }
+
     IAToken(reserve.aTokenAddress).transferUnderlyingTo(params.receiverAddress, params.amount);

     require(
@@ -7690,7 +7934,7 @@ library FlashLoanLogic {
       .rayDiv(reserveCache.nextLiquidityIndex)
       .toUint128();

-    reserve.updateInterestRates(reserveCache, params.asset, amountPlusPremium, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, params.asset, amountPlusPremium, 0);

     IERC20(params.asset).safeTransferFrom(
       params.receiverAddress,
@@ -7716,7 +7960,7 @@ library FlashLoanLogic {
   }
 }

-// downloads/MAINNET/POOL_IMPL/Pool/lib/aave-v3-factory/src/core/contracts/protocol/pool/Pool.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/pool/Pool.sol

 /**
  * @title Pool contract
@@ -7735,10 +7979,9 @@ library FlashLoanLogic {
  * @dev All admin functions are callable by the PoolConfigurator contract defined also in the
  *   PoolAddressesProvider
  */
-contract Pool is VersionedInitializable, PoolStorage, IPool {
+abstract contract Pool is VersionedInitializable, PoolStorage, IPool {
   using ReserveLogic for DataTypes.ReserveData;

-  uint256 public constant POOL_REVISION = 0x3;
   IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;

   /**
@@ -7786,10 +8029,6 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
     );
   }

-  function getRevision() internal pure virtual override returns (uint256) {
-    return POOL_REVISION;
-  }
-
   /**
    * @dev Constructor.
    * @param provider The address of the PoolAddressesProvider contract
@@ -7805,10 +8044,7 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
    * @dev Caching the address of the PoolAddressesProvider in order to reduce gas consumption on subsequent operations
    * @param provider The address of the PoolAddressesProvider
    */
-  function initialize(IPoolAddressesProvider provider) external virtual initializer {
-    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
-    _maxStableRateBorrowSizePercent = 0.25e4;
-  }
+  function initialize(IPoolAddressesProvider provider) external virtual;

   /// @inheritdoc IPool
   function mintUnbacked(
@@ -7869,15 +8105,17 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
     bytes32 permitR,
     bytes32 permitS
   ) public virtual override {
-    IERC20WithPermit(asset).permit(
-      msg.sender,
-      address(this),
-      amount,
-      deadline,
-      permitV,
-      permitR,
-      permitS
-    );
+    try
+      IERC20WithPermit(asset).permit(
+        msg.sender,
+        address(this),
+        amount,
+        deadline,
+        permitV,
+        permitR,
+        permitS
+      )
+    {} catch {}
     SupplyLogic.executeSupply(
       _reserves,
       _reservesList,
@@ -7977,7 +8215,7 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
     bytes32 permitR,
     bytes32 permitS
   ) public virtual override returns (uint256) {
-    {
+    try
       IERC20WithPermit(asset).permit(
         msg.sender,
         address(this),
@@ -7986,8 +8224,9 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
         permitV,
         permitR,
         permitS
-      );
-    }
+      )
+    {} catch {}
+
     {
       DataTypes.ExecuteRepayParams memory params = DataTypes.ExecuteRepayParams({
         asset: asset,
@@ -8027,10 +8266,22 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
       _reserves[asset],
       _usersConfig[msg.sender],
       asset,
+      msg.sender,
       DataTypes.InterestRateMode(interestRateMode)
     );
   }

+  /// @inheritdoc IPool
+  function swapToVariable(address asset, address user) public virtual override {
+    BorrowLogic.executeSwapBorrowRateMode(
+      _reserves[asset],
+      _usersConfig[user],
+      asset,
+      user,
+      DataTypes.InterestRateMode.STABLE
+    );
+  }
+
   /// @inheritdoc IPool
   function rebalanceStableBorrowRate(address asset, address user) public virtual override {
     BorrowLogic.executeRebalanceStableBorrowRate(_reserves[asset], asset, user);
@@ -8146,12 +8397,44 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }

   /// @inheritdoc IPool
-  function getReserveData(
+  function getReserveDataExtended(
     address asset
-  ) external view virtual override returns (DataTypes.ReserveData memory) {
+  ) external view returns (DataTypes.ReserveData memory) {
     return _reserves[asset];
   }

+  /// @inheritdoc IPool
+  function getReserveData(
+    address asset
+  ) external view virtual override returns (DataTypes.ReserveDataLegacy memory) {
+    DataTypes.ReserveData memory reserve = _reserves[asset];
+    DataTypes.ReserveDataLegacy memory res;
+
+    res.configuration = reserve.configuration;
+    res.liquidityIndex = reserve.liquidityIndex;
+    res.currentLiquidityRate = reserve.currentLiquidityRate;
+    res.variableBorrowIndex = reserve.variableBorrowIndex;
+    res.currentVariableBorrowRate = reserve.currentVariableBorrowRate;
+    res.currentStableBorrowRate = reserve.currentStableBorrowRate;
+    res.lastUpdateTimestamp = reserve.lastUpdateTimestamp;
+    res.id = reserve.id;
+    res.aTokenAddress = reserve.aTokenAddress;
+    res.stableDebtTokenAddress = reserve.stableDebtTokenAddress;
+    res.variableDebtTokenAddress = reserve.variableDebtTokenAddress;
+    res.interestRateStrategyAddress = reserve.interestRateStrategyAddress;
+    res.accruedToTreasury = reserve.accruedToTreasury;
+    res.unbacked = reserve.unbacked;
+    res.isolationModeTotalDebt = reserve.isolationModeTotalDebt;
+    return res;
+  }
+
+  /// @inheritdoc IPool
+  function getVirtualUnderlyingBalance(
+    address asset
+  ) external view virtual override returns (uint128) {
+    return _reserves[asset].virtualUnderlyingBalance;
+  }
+
   /// @inheritdoc IPool
   function getUserAccountData(
     address user
@@ -8336,9 +8619,26 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   ) external virtual override onlyPoolConfigurator {
     require(asset != address(0), Errors.ZERO_ADDRESS_NOT_VALID);
     require(_reserves[asset].id != 0 || _reservesList[0] == asset, Errors.ASSET_NOT_LISTED);
+
     _reserves[asset].interestRateStrategyAddress = rateStrategyAddress;
   }

+  /// @inheritdoc IPool
+  function syncIndexesState(address asset) external virtual override onlyPoolConfigurator {
+    DataTypes.ReserveData storage reserve = _reserves[asset];
+    DataTypes.ReserveCache memory reserveCache = reserve.cache();
+
+    reserve.updateState(reserveCache);
+  }
+
+  /// @inheritdoc IPool
+  function syncRatesState(address asset) external virtual override onlyPoolConfigurator {
+    DataTypes.ReserveData storage reserve = _reserves[asset];
+    DataTypes.ReserveCache memory reserveCache = reserve.cache();
+
+    ReserveLogic.updateInterestRatesAndVirtualBalance(reserve, reserveCache, asset, 0, 0);
+  }
+
   /// @inheritdoc IPool
   function setConfiguration(
     address asset,
@@ -8410,6 +8710,20 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
     PoolLogic.executeResetIsolationModeTotalDebt(_reserves, asset);
   }

+  /// @inheritdoc IPool
+  function getLiquidationGracePeriod(address asset) external virtual override returns (uint40) {
+    return _reserves[asset].liquidationGracePeriodUntil;
+  }
+
+  /// @inheritdoc IPool
+  function setLiquidationGracePeriod(
+    address asset,
+    uint40 until
+  ) external virtual override onlyPoolConfigurator {
+    require(_reserves[asset].id != 0 || _reservesList[0] == asset, Errors.ASSET_NOT_LISTED);
+    PoolLogic.executeSetLiquidationGracePeriod(_reserves, asset, until);
+  }
+
   /// @inheritdoc IPool
   function rescueTokens(
     address token,
@@ -8439,4 +8753,63 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
       })
     );
   }
+
+  /// @inheritdoc IPool
+  function getFlashLoanLogic() external pure returns (address) {
+    return address(FlashLoanLogic);
+  }
+
+  /// @inheritdoc IPool
+  function getBorrowLogic() external pure returns (address) {
+    return address(BorrowLogic);
+  }
+
+  /// @inheritdoc IPool
+  function getBridgeLogic() external pure returns (address) {
+    return address(BridgeLogic);
+  }
+
+  /// @inheritdoc IPool
+  function getEModeLogic() external pure returns (address) {
+    return address(EModeLogic);
+  }
+
+  /// @inheritdoc IPool
+  function getLiquidationLogic() external pure returns (address) {
+    return address(LiquidationLogic);
+  }
+
+  /// @inheritdoc IPool
+  function getPoolLogic() external pure returns (address) {
+    return address(PoolLogic);
+  }
+
+  /// @inheritdoc IPool
+  function getSupplyLogic() external pure returns (address) {
+    return address(SupplyLogic);
+  }
+}
+
+// lib/aave-v3-origin/src/core/instances/PoolInstance.sol
+
+contract PoolInstance is Pool {
+  uint256 public constant POOL_REVISION = 4;
+
+  constructor(IPoolAddressesProvider provider) Pool(provider) {}
+
+  /**
+   * @notice Initializes the Pool.
+   * @dev Function is invoked by the proxy contract when the Pool contract is added to the
+   * PoolAddressesProvider of the market.
+   * @dev Caching the address of the PoolAddressesProvider in order to reduce gas consumption on subsequent operations
+   * @param provider The address of the PoolAddressesProvider
+   */
+  function initialize(IPoolAddressesProvider provider) external virtual override initializer {
+    require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
+    _maxStableRateBorrowSizePercent = 0.25e4;
+  }
+
+  function getRevision() internal pure virtual override returns (uint256) {
+    return POOL_REVISION;
+  }
 }
```
