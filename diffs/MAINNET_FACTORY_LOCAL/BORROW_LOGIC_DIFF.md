```diff
diff --git a/./downloads/MAINNET/BORROW_LOGIC.sol b/./downloads/FACTORY_LOCAL/BORROW_LOGIC.sol
index 4581361..f55a4cc 100644
--- a/./downloads/MAINNET/BORROW_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/BORROW_LOGIC.sol

-// downloads/MAINNET/BORROW_LOGIC/BorrowLogic/src/core/contracts/protocol/libraries/types/DataTypes.sol
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
@@ -1321,6 +1365,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -1335,6 +1381,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }

   struct ReserveConfigurationMap {
@@ -1351,13 +1399,14 @@ library DataTypes {
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
@@ -1492,6 +1541,7 @@ library DataTypes {
     uint256 maxStableRateBorrowSizePercent;
     uint256 reservesCount;
     address addressesProvider;
+    address pool;
     uint8 userEModeCategory;
     bool isAuthorizedFlashBorrower;
   }
@@ -1556,7 +1606,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }

   struct InitReserveParams {
@@ -1570,7 +1621,7 @@ library DataTypes {
   }
 }

-// downloads/MAINNET/BORROW_LOGIC/BorrowLogic/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol

 /**
  * @title ReserveConfiguration library
@@ -2809,6 +2966,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore

   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -2829,6 +2987,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;

   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -3324,6 +3483,31 @@ library ReserveConfiguration {
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
@@ -3390,7 +3574,7 @@ library ReserveConfiguration {
   }
 }

-// downloads/MAINNET/BORROW_LOGIC/BorrowLogic/src/core/contracts/protocol/libraries/logic/ReserveLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ReserveLogic.sol

 /**
  * @title ReserveLogic library
@@ -4488,7 +4672,7 @@ library ReserveLogic {
     reserve.interestRateStrategyAddress = interestRateStrategyAddress;
   }

-  struct UpdateInterestRatesLocalVars {
+  struct UpdateInterestRatesAndVirtualBalanceLocalVars {
     uint256 nextLiquidityRate;
     uint256 nextStableRate;
     uint256 nextVariableRate;
@@ -4503,14 +4687,14 @@ library ReserveLogic {
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
@@ -4530,7 +4714,8 @@ library ReserveLogic {
         averageStableBorrowRate: reserveCache.nextAvgStableBorrowRate,
         reserveFactor: reserveCache.reserveFactor,
         reserve: reserveAddress,
-        aToken: reserveCache.aTokenAddress
+        usingVirtualBalance: reserve.configuration.getIsVirtualAccActive(),
+        virtualUnderlyingBalance: reserve.virtualUnderlyingBalance
       })
     );

@@ -4538,6 +4723,16 @@ library ReserveLogic {
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
@@ -4695,7 +4890,7 @@ library ReserveLogic {
   }
 }

-// downloads/MAINNET/BORROW_LOGIC/BorrowLogic/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol

 /**
  * @title BorrowLogic library
@@ -5827,6 +6045,7 @@ library BorrowLogic {
     DataTypes.InterestRateMode interestRateMode
   );
   event IsolationModeTotalDebtUpdated(address indexed asset, uint256 totalDebt);
+  event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);

   /**
    * @notice Implements the borrow feature. Borrowing allows users that provided collateral to draw liquidity from the
@@ -5845,7 +6064,7 @@ library BorrowLogic {
     mapping(uint8 => DataTypes.EModeCategory) storage eModeCategories,
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ExecuteBorrowParams memory params
-  ) public {
+  ) external {
     DataTypes.ReserveData storage reserve = reservesData[params.asset];
     DataTypes.ReserveCache memory reserveCache = reserve.cache();

@@ -5917,7 +6136,7 @@ library BorrowLogic {
       );
     }

-    reserve.updateInterestRates(
+    reserve.updateInterestRatesAndVirtualBalance(
       reserveCache,
       params.asset,
       0,
@@ -5999,7 +6218,7 @@ library BorrowLogic {
       ).burn(params.onBehalfOf, paybackAmount, reserveCache.nextVariableBorrowIndex);
     }

-    reserve.updateInterestRates(
+    reserve.updateInterestRatesAndVirtualBalance(
       reserveCache,
       params.asset,
       params.useATokens ? 0 : paybackAmount,
@@ -6025,6 +6244,11 @@ library BorrowLogic {
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
@@ -6066,7 +6290,7 @@ library BorrowLogic {
     (, reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = stableDebtToken
       .mint(user, user, stableDebt, reserve.currentStableBorrowRate);

-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);

     emit RebalanceStableBorrowRate(asset, user);
   }
@@ -6083,16 +6307,14 @@ library BorrowLogic {
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
@@ -6106,23 +6328,23 @@ library BorrowLogic {
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
```
