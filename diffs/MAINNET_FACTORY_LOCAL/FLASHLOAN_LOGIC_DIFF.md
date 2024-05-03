```diff
diff --git a/./downloads/MAINNET/FLASHLOAN_LOGIC.sol b/./downloads/FACTORY_LOCAL/FLASHLOAN_LOGIC.sol
index dd9c0ae..76c23f9 100644
--- a/./downloads/MAINNET/FLASHLOAN_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/FLASHLOAN_LOGIC.sol

-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/FlashLoanLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/FlashLoanLogic.sol

 /**
  * @title FlashLoanLogic library
@@ -6280,6 +6494,13 @@ library FlashLoanLogic {
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
@@ -6373,10 +6594,15 @@ library FlashLoanLogic {
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
@@ -6429,7 +6655,7 @@ library FlashLoanLogic {
       .rayDiv(reserveCache.nextLiquidityIndex)
       .toUint128();

-    reserve.updateInterestRates(reserveCache, params.asset, amountPlusPremium, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, params.asset, amountPlusPremium, 0);

     IERC20(params.asset).safeTransferFrom(
       params.receiverAddress,
```
