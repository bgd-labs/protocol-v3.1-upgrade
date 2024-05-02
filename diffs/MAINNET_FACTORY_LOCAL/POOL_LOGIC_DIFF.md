```diff
diff --git a/./downloads/MAINNET/POOL_LOGIC.sol b/./downloads/FACTORY_LOCAL/POOL_LOGIC.sol
index 4b36b82..2c5f87f 100644
--- a/./downloads/MAINNET/POOL_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/POOL_LOGIC.sol

-// downloads/MAINNET/POOL_LOGIC/PoolLogic/src/core/contracts/protocol/libraries/logic/PoolLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/PoolLogic.sol

 /**
  * @title PoolLogic library
@@ -5816,6 +6034,20 @@ library PoolLogic {
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
```
