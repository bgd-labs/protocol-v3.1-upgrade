```diff
diff --git a/./downloads/MAINNET/UI_POOL_DATA_PROVIDER.sol b/./downloads/FACTORY_LOCAL/UI_POOL_DATA_PROVIDER.sol
index 46a04a2..dd4d3da 100644
--- a/./downloads/MAINNET/UI_POOL_DATA_PROVIDER.sol
+++ b/./downloads/FACTORY_LOCAL/UI_POOL_DATA_PROVIDER.sol

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
