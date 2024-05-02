```diff
diff --git a/./downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER.sol b/./downloads/FACTORY_LOCAL/AAVE_PROTOCOL_DATA_PROVIDER.sol
index 2ebccfd..1174fe5 100644
--- a/./downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER.sol
+++ b/./downloads/FACTORY_LOCAL/AAVE_PROTOCOL_DATA_PROVIDER.sol

-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolDataProvider.sol

 /**
  * @title IPoolDataProvider
@@ -1138,9 +1190,23 @@ interface IPoolDataProvider {
    * @return True if FlashLoans are enabled, false otherwise
    */
   function getFlashLoanEnabled(address asset) external view returns (bool);
+
+  /**
+   * @notice Returns whether virtual accounting is enabled/not for a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return True if active, false otherwise
+   */
+  function getIsVirtualAccActive(address asset) external view returns (bool);
+
+  /**
+   * @notice Returns the virtual underlying balance of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The reserve virtual underlying balance
+   */
+  function getVirtualUnderlyingBalance(address asset) external view returns (uint256);
 }

-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/misc/AaveProtocolDataProvider.sol
+// lib/aave-v3-origin/src/core/contracts/misc/AaveProtocolDataProvider.sol

 /**
  * @title AaveProtocolDataProvider
@@ -2997,7 +3188,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     address[] memory reserves = pool.getReservesList();
     TokenData[] memory aTokens = new TokenData[](reserves.length);
     for (uint256 i = 0; i < reserves.length; i++) {
-      DataTypes.ReserveData memory reserveData = pool.getReserveData(reserves[i]);
+      DataTypes.ReserveDataLegacy memory reserveData = pool.getReserveData(reserves[i]);
       aTokens[i] = TokenData({
         symbol: IERC20Detailed(reserveData.aTokenAddress).symbol(),
         tokenAddress: reserveData.aTokenAddress
@@ -3103,7 +3294,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       uint40 lastUpdateTimestamp
     )
   {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );

@@ -3125,7 +3316,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {

   /// @inheritdoc IPoolDataProvider
   function getATokenTotalSupply(address asset) external view override returns (uint256) {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
     return IERC20Detailed(reserve.aTokenAddress).totalSupply();
@@ -3133,7 +3324,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {

   /// @inheritdoc IPoolDataProvider
   function getTotalDebt(address asset) external view override returns (uint256) {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
     return
@@ -3161,7 +3352,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       bool usageAsCollateralEnabled
     )
   {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );

@@ -3194,7 +3385,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       address variableDebtTokenAddress
     )
   {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );

@@ -3209,7 +3400,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   function getInterestRateStrategyAddress(
     address asset
   ) external view override returns (address irStrategyAddress) {
-    DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
+    DataTypes.ReserveDataLegacy memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );

@@ -3223,4 +3414,17 @@ contract AaveProtocolDataProvider is IPoolDataProvider {

     return configuration.getFlashLoanEnabled();
   }
+
+  /// @inheritdoc IPoolDataProvider
+  function getIsVirtualAccActive(address asset) external view override returns (bool) {
+    DataTypes.ReserveConfigurationMap memory configuration = IPool(ADDRESSES_PROVIDER.getPool())
+      .getConfiguration(asset);
+
+    return configuration.getIsVirtualAccActive();
+  }
+
+  /// @inheritdoc IPoolDataProvider
+  function getVirtualUnderlyingBalance(address asset) external view override returns (uint256) {
+    return IPool(ADDRESSES_PROVIDER.getPool()).getVirtualUnderlyingBalance(asset);
+  }
 }
```
