```diff
diff --git a/./downloads/MAINNET/SUPPLY_LOGIC.sol b/./downloads/FACTORY_LOCAL/SUPPLY_LOGIC.sol
index f189e0e..8107b1e 100644
--- a/./downloads/MAINNET/SUPPLY_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/SUPPLY_LOGIC.sol

-// downloads/MAINNET/SUPPLY_LOGIC/SupplyLogic/src/core/contracts/protocol/libraries/logic/SupplyLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/SupplyLogic.sol

 /**
  * @title SupplyLogic library
@@ -5753,9 +5971,9 @@ library SupplyLogic {

     reserve.updateState(reserveCache);

-    ValidationLogic.validateSupply(reserveCache, reserve, params.amount);
+    ValidationLogic.validateSupply(reserveCache, reserve, params.amount, params.onBehalfOf);

-    reserve.updateInterestRates(reserveCache, params.asset, params.amount, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, params.asset, params.amount, 0);

     IERC20(params.asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, params.amount);

@@ -5806,6 +6024,8 @@ library SupplyLogic {
     DataTypes.ReserveData storage reserve = reservesData[params.asset];
     DataTypes.ReserveCache memory reserveCache = reserve.cache();

+    require(params.to != reserveCache.aTokenAddress, Errors.WITHDRAW_TO_ATOKEN);
+
     reserve.updateState(reserveCache);

     uint256 userBalance = IAToken(reserveCache.aTokenAddress).scaledBalanceOf(msg.sender).rayMul(
@@ -5820,7 +6040,7 @@ library SupplyLogic {

     ValidationLogic.validateWithdraw(reserveCache, amountToWithdraw, userBalance);

-    reserve.updateInterestRates(reserveCache, params.asset, 0, amountToWithdraw);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, params.asset, 0, amountToWithdraw);

     bool isCollateral = userConfig.isUsingAsCollateral(reserve.id);

@@ -5879,8 +6099,9 @@ library SupplyLogic {
     ValidationLogic.validateTransfer(reserve);

     uint256 reserveId = reserve.id;
+    uint256 scaledAmount = params.amount.rayDiv(reserve.getNormalizedIncome());

-    if (params.from != params.to && params.amount != 0) {
+    if (params.from != params.to && scaledAmount != 0) {
       DataTypes.UserConfigurationMap storage fromConfig = usersConfig[params.from];

       if (fromConfig.isUsingAsCollateral(reserveId)) {
```
