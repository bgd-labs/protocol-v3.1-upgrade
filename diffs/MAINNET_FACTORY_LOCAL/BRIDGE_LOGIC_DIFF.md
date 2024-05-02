```diff
diff --git a/./downloads/MAINNET/BRIDGE_LOGIC.sol b/./downloads/FACTORY_LOCAL/BRIDGE_LOGIC.sol
index 6eb71fc..25d7cff 100644
--- a/./downloads/MAINNET/BRIDGE_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/BRIDGE_LOGIC.sol

-// downloads/MAINNET/BRIDGE_LOGIC/BridgeLogic/src/core/contracts/protocol/libraries/logic/BridgeLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BridgeLogic.sol

 library BridgeLogic {
   using ReserveLogic for DataTypes.ReserveCache;
@@ -5755,7 +5973,7 @@ library BridgeLogic {

     reserve.updateState(reserveCache);

-    ValidationLogic.validateSupply(reserveCache, reserve, amount);
+    ValidationLogic.validateSupply(reserveCache, reserve, amount, onBehalfOf);

     uint256 unbackedMintCap = reserveCache.reserveConfiguration.getUnbackedMintCap();
     uint256 reserveDecimals = reserveCache.reserveConfiguration.getDecimals();
@@ -5767,7 +5985,7 @@ library BridgeLogic {
       Errors.UNBACKED_MINT_CAP_EXCEEDED
     );

-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);

     bool isFirstSupply = IAToken(reserveCache.aTokenAddress).mint(
       msg.sender,
@@ -5831,7 +6049,7 @@ library BridgeLogic {
     reserve.accruedToTreasury += feeToProtocol.rayDiv(reserveCache.nextLiquidityIndex).toUint128();

     reserve.unbacked -= backingAmount.toUint128();
-    reserve.updateInterestRates(reserveCache, asset, added, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, added, 0);

     IERC20(asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, added);

```
