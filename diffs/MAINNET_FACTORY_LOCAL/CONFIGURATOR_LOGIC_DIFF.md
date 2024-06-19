```diff
diff --git a/./downloads/MAINNET/CONFIGURATOR_LOGIC.sol b/./downloads/FACTORY_LOCAL/CONFIGURATOR_LOGIC.sol
index e8cfc59..de4ae84 100644

-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol

 /**
  * @title ConfiguratorLogic library
@@ -2635,7 +2937,11 @@ library ConfiguratorLogic {
   function executeInitReserve(
     IPool pool,
     ConfiguratorInputTypes.InitReserveInput calldata input
-  ) public {
+  ) external {
+    // It is an assumption that the asset listed is non-malicious, and the external call doesn't create re-entrancies
+    uint8 underlyingAssetDecimals = IERC20Detailed(input.underlyingAsset).decimals();
+    require(underlyingAssetDecimals > 5, Errors.INVALID_DECIMALS);
+
     address aTokenProxyAddress = _initTokenWithProxy(
       input.aTokenImpl,
       abi.encodeWithSelector(
@@ -2644,7 +2950,7 @@ library ConfiguratorLogic {
         input.treasury,
         input.underlyingAsset,
         input.incentivesController,
-        input.underlyingAssetDecimals,
+        underlyingAssetDecimals,
         input.aTokenName,
         input.aTokenSymbol,
         input.params
@@ -2658,7 +2964,7 @@ library ConfiguratorLogic {
         pool,
         input.underlyingAsset,
         input.incentivesController,
-        input.underlyingAssetDecimals,
+        underlyingAssetDecimals,
         input.stableDebtTokenName,
         input.stableDebtTokenSymbol,
         input.params
@@ -2672,7 +2978,7 @@ library ConfiguratorLogic {
         pool,
         input.underlyingAsset,
         input.incentivesController,
-        input.underlyingAssetDecimals,
+        underlyingAssetDecimals,
         input.variableDebtTokenName,
         input.variableDebtTokenSymbol,
         input.params
@@ -2689,14 +2995,20 @@ library ConfiguratorLogic {

     DataTypes.ReserveConfigurationMap memory currentConfig = DataTypes.ReserveConfigurationMap(0);

-    currentConfig.setDecimals(input.underlyingAssetDecimals);
+    currentConfig.setDecimals(underlyingAssetDecimals);

     currentConfig.setActive(true);
     currentConfig.setPaused(false);
     currentConfig.setFrozen(false);
+    currentConfig.setVirtualAccActive(input.useVirtualBalance);

     pool.setConfiguration(input.underlyingAsset, currentConfig);

+    IReserveInterestRateStrategy(input.interestRateStrategyAddress).setInterestRateParams(
+      input.underlyingAsset,
+      input.interestRateData
+    );
+
     emit ReserveInitialized(
       input.underlyingAsset,
       aTokenProxyAddress,
@@ -2715,8 +3027,8 @@ library ConfiguratorLogic {
   function executeUpdateAToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateATokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);

     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();

@@ -2746,8 +3058,8 @@ library ConfiguratorLogic {
   function executeUpdateStableDebtToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);

     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();

@@ -2784,8 +3096,8 @@ library ConfiguratorLogic {
   function executeUpdateVariableDebtToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);

     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();

```
