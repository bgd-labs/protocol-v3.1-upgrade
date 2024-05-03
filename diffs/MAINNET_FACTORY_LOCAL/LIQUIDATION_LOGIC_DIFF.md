```diff
diff --git a/./downloads/MAINNET/LIQUIDATION_LOGIC.sol b/./downloads/FACTORY_LOCAL/LIQUIDATION_LOGIC.sol
index db76198..3bed26d 100644
--- a/./downloads/MAINNET/LIQUIDATION_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/LIQUIDATION_LOGIC.sol

-// downloads/MAINNET/LIQUIDATION_LOGIC/LiquidationLogic/src/core/contracts/protocol/libraries/logic/LiquidationLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/LiquidationLogic.sol

 /**
  * @title LiquidationLogic library
@@ -5901,6 +6119,7 @@ library LiquidationLogic {
     ValidationLogic.validateLiquidationCall(
       userConfig,
       collateralReserve,
+      debtReserve,
       DataTypes.ValidateLiquidationCallParams({
         debtReserveCache: vars.debtReserveCache,
         totalDebt: vars.userTotalDebt,
@@ -5949,7 +6168,7 @@ library LiquidationLogic {

     _burnDebtTokens(params, vars);

-    debtReserve.updateInterestRates(
+    debtReserve.updateInterestRatesAndVirtualBalance(
       vars.debtReserveCache,
       params.debtAsset,
       vars.actualDebtToLiquidate,
@@ -6026,7 +6245,7 @@ library LiquidationLogic {
   ) internal {
     DataTypes.ReserveCache memory collateralReserveCache = collateralReserve.cache();
     collateralReserve.updateState(collateralReserveCache);
-    collateralReserve.updateInterestRates(
+    collateralReserve.updateInterestRatesAndVirtualBalance(
       collateralReserveCache,
       params.collateralAsset,
       0,
```
