```diff
diff --git a/./downloads/MAINNET/BORROW_LOGIC.sol b/./downloads/FACTORY_LOCAL/BORROW_LOGIC.sol
index 4581361..f55a4cc 100644
--- a/./downloads/MAINNET/BORROW_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/BORROW_LOGIC.sol

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
