```diff
diff --git a/./downloads/MAINNET/CONFIGURATOR_LOGIC.sol b/./downloads/FACTORY_LOCAL/CONFIGURATOR_LOGIC.sol
index e8cfc59..c167c74 100644
--- a/./downloads/MAINNET/CONFIGURATOR_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/CONFIGURATOR_LOGIC.sol

-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol

 library ConfiguratorInputTypes {
   struct InitReserveInput {
@@ -648,6 +663,7 @@ library ConfiguratorInputTypes {
     address stableDebtTokenImpl;
     address variableDebtTokenImpl;
     uint8 underlyingAssetDecimals;
+    bool useVirtualBalance;
     address interestRateStrategyAddress;
     address underlyingAsset;
     address treasury;
@@ -659,6 +675,7 @@ library ConfiguratorInputTypes {
     string stableDebtTokenName;
     string stableDebtTokenSymbol;
     bytes params;
+    bytes interestRateData;
   }

   struct UpdateATokenInput {
@@ -681,9 +698,46 @@ library ConfiguratorInputTypes {
   }
 }

-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol

 /**
  * @title ConfiguratorLogic library
@@ -2635,7 +2849,7 @@ library ConfiguratorLogic {
   function executeInitReserve(
     IPool pool,
     ConfiguratorInputTypes.InitReserveInput calldata input
-  ) public {
+  ) external {
     address aTokenProxyAddress = _initTokenWithProxy(
       input.aTokenImpl,
       abi.encodeWithSelector(
@@ -2694,9 +2908,15 @@ library ConfiguratorLogic {
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
@@ -2715,8 +2935,8 @@ library ConfiguratorLogic {
   function executeUpdateAToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateATokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);

     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();

@@ -2746,8 +2966,8 @@ library ConfiguratorLogic {
   function executeUpdateStableDebtToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);

     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();

@@ -2784,8 +3004,8 @@ library ConfiguratorLogic {
   function executeUpdateVariableDebtToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);

     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();

```
