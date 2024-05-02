```diff
diff --git a/./downloads/MAINNET/UI_INCENTIVE_DATA_PROVIDER.sol b/./downloads/FACTORY_LOCAL/UI_INCENTIVE_DATA_PROVIDER.sol
index 60e5e41..f578b7b 100644
--- a/./downloads/MAINNET/UI_INCENTIVE_DATA_PROVIDER.sol
+++ b/./downloads/FACTORY_LOCAL/UI_INCENTIVE_DATA_PROVIDER.sol

-// downloads/MAINNET/UI_INCENTIVE_DATA_PROVIDER/UiIncentiveDataProviderV3/@aave/periphery-v3/contracts/misc/interfaces/IUiIncentiveDataProviderV3.sol
-
-interface IUiIncentiveDataProviderV3 {
-  struct AggregatedReserveIncentiveData {
-    address underlyingAsset;
-    IncentiveData aIncentiveData;
-    IncentiveData vIncentiveData;
-    IncentiveData sIncentiveData;
-  }
-
-  struct IncentiveData {
-    address tokenAddress;
-    address incentiveControllerAddress;
-    RewardInfo[] rewardsTokenInformation;
-  }
-
-  struct RewardInfo {
-    string rewardTokenSymbol;
-    address rewardTokenAddress;
-    address rewardOracleAddress;
-    uint256 emissionPerSecond;
-    uint256 incentivesLastUpdateTimestamp;
-    uint256 tokenIncentivesIndex;
-    uint256 emissionEndTimestamp;
-    int256 rewardPriceFeed;
-    uint8 rewardTokenDecimals;
-    uint8 precision;
-    uint8 priceFeedDecimals;
-  }
-
-  struct UserReserveIncentiveData {
-    address underlyingAsset;
-    UserIncentiveData aTokenIncentivesUserData;
-    UserIncentiveData vTokenIncentivesUserData;
-    UserIncentiveData sTokenIncentivesUserData;
-  }
-
-  struct UserIncentiveData {
-    address tokenAddress;
-    address incentiveControllerAddress;
-    UserRewardInfo[] userRewardsInformation;
-  }
-
-  struct UserRewardInfo {
-    string rewardTokenSymbol;
-    address rewardOracleAddress;
-    address rewardTokenAddress;
-    uint256 userUnclaimedRewards;
-    uint256 tokenIncentivesUserIndex;
-    int256 rewardPriceFeed;
-    uint8 priceFeedDecimals;
-    uint8 rewardTokenDecimals;
-  }
-
-  function getReservesIncentivesData(
-    IPoolAddressesProvider provider
-  ) external view returns (AggregatedReserveIncentiveData[] memory);
-
-  function getUserReservesIncentivesData(
-    IPoolAddressesProvider provider,
-    address user
-  ) external view returns (UserReserveIncentiveData[] memory);

+// lib/aave-v3-origin/src/periphery/contracts/misc/interfaces/IUiIncentiveDataProviderV3.sol
+
+interface IUiIncentiveDataProviderV3 {
+  struct AggregatedReserveIncentiveData {
+    address underlyingAsset;
+    IncentiveData aIncentiveData;
+    IncentiveData vIncentiveData;
+    IncentiveData sIncentiveData;
+  }
+
+  struct IncentiveData {
+    address tokenAddress;
+    address incentiveControllerAddress;
+    RewardInfo[] rewardsTokenInformation;
   }

-  struct UserAssetBalance {
-    address asset;
-    uint256 userBalance;
-    uint256 totalSupply;
+  struct RewardInfo {
+    string rewardTokenSymbol;
+    address rewardTokenAddress;
+    address rewardOracleAddress;
+    uint256 emissionPerSecond;
+    uint256 incentivesLastUpdateTimestamp;
+    uint256 tokenIncentivesIndex;
+    uint256 emissionEndTimestamp;
+    int256 rewardPriceFeed;
+    uint8 rewardTokenDecimals;
+    uint8 precision;
+    uint8 priceFeedDecimals;
   }

-  struct UserData {
-    // Liquidity index of the reward distribution for the user
-    uint104 index;
-    // Amount of accrued rewards for the user since last user index update
-    uint128 accrued;
+  struct UserReserveIncentiveData {
+    address underlyingAsset;
+    UserIncentiveData aTokenIncentivesUserData;
+    UserIncentiveData vTokenIncentivesUserData;
+    UserIncentiveData sTokenIncentivesUserData;
   }

-  struct RewardData {
-    // Liquidity index of the reward distribution
-    uint104 index;
-    // Amount of reward tokens distributed per second
-    uint88 emissionPerSecond;
-    // Timestamp of the last reward index update
-    uint32 lastUpdateTimestamp;
-    // The end of the distribution of rewards (in seconds)
-    uint32 distributionEnd;
-    // Map of user addresses and their rewards data (userAddress => userData)
-    mapping(address => UserData) usersData;
+  struct UserIncentiveData {
+    address tokenAddress;
+    address incentiveControllerAddress;
+    UserRewardInfo[] userRewardsInformation;
   }

-  struct AssetData {
-    // Map of reward token addresses and their data (rewardTokenAddress => rewardData)
-    mapping(address => RewardData) rewards;
-    // List of reward token addresses for the asset
-    mapping(uint128 => address) availableRewards;
-    // Count of reward tokens for the asset
-    uint128 availableRewardsCount;
-    // Number of decimals of the asset
-    uint8 decimals;
+  struct UserRewardInfo {
+    string rewardTokenSymbol;
+    address rewardOracleAddress;
+    address rewardTokenAddress;
+    uint256 userUnclaimedRewards;
+    uint256 tokenIncentivesUserIndex;
+    int256 rewardPriceFeed;
+    uint8 priceFeedDecimals;
+    uint8 rewardTokenDecimals;
   }
+
+  function getReservesIncentivesData(
+    IPoolAddressesProvider provider
+  ) external view returns (AggregatedReserveIncentiveData[] memory);
+
+  function getUserReservesIncentivesData(
+    IPoolAddressesProvider provider,
+    address user
+  ) external view returns (UserReserveIncentiveData[] memory);
+
+  // generic method with full data
+  function getFullReservesIncentiveData(
+    IPoolAddressesProvider provider,
+    address user
+  )
+    external
+    view
+    returns (AggregatedReserveIncentiveData[] memory, UserReserveIncentiveData[] memory);
 }

-// downloads/MAINNET/UI_INCENTIVE_DATA_PROVIDER/UiIncentiveDataProviderV3/@aave/periphery-v3/contracts/misc/UiIncentiveDataProviderV3.sol
+// lib/aave-v3-origin/src/periphery/contracts/misc/UiIncentiveDataProviderV3.sol

 contract UiIncentiveDataProviderV3 is IUiIncentiveDataProviderV3 {
   using UserConfiguration for DataTypes.UserConfigurationMap;
@@ -3669,7 +3845,7 @@ contract UiIncentiveDataProviderV3 is IUiIncentiveDataProviderV3 {
       AggregatedReserveIncentiveData memory reserveIncentiveData = reservesIncentiveData[i];
       reserveIncentiveData.underlyingAsset = reserves[i];

-      DataTypes.ReserveData memory baseData = pool.getReserveData(reserves[i]);
+      DataTypes.ReserveDataLegacy memory baseData = pool.getReserveData(reserves[i]);

       // Get aTokens rewards information
       // TODO: check that this is deployed correctly on contract and remove casting
@@ -3731,12 +3907,11 @@ contract UiIncentiveDataProviderV3 is IUiIncentiveDataProviderV3 {
       IRewardsController vTokenIncentiveController = IRewardsController(
         address(IncentivizedERC20(baseData.variableDebtTokenAddress).getIncentivesController())
       );
-      address[] memory vTokenRewardAddresses = vTokenIncentiveController.getRewardsByAsset(
-        baseData.variableDebtTokenAddress
-      );
       RewardInfo[] memory vRewardsInformation;
-
       if (address(vTokenIncentiveController) != address(0)) {
+        address[] memory vTokenRewardAddresses = vTokenIncentiveController.getRewardsByAsset(
+          baseData.variableDebtTokenAddress
+        );
         vRewardsInformation = new RewardInfo[](vTokenRewardAddresses.length);
         for (uint256 j = 0; j < vTokenRewardAddresses.length; ++j) {
           RewardInfo memory rewardInformation;
@@ -3786,12 +3961,11 @@ contract UiIncentiveDataProviderV3 is IUiIncentiveDataProviderV3 {
       IRewardsController sTokenIncentiveController = IRewardsController(
         address(IncentivizedERC20(baseData.stableDebtTokenAddress).getIncentivesController())
       );
-      address[] memory sTokenRewardAddresses = sTokenIncentiveController.getRewardsByAsset(
-        baseData.stableDebtTokenAddress
-      );
       RewardInfo[] memory sRewardsInformation;
-
       if (address(sTokenIncentiveController) != address(0)) {
+        address[] memory sTokenRewardAddresses = sTokenIncentiveController.getRewardsByAsset(
+          baseData.stableDebtTokenAddress
+        );
         sRewardsInformation = new RewardInfo[](sTokenRewardAddresses.length);
         for (uint256 j = 0; j < sTokenRewardAddresses.length; ++j) {
           RewardInfo memory rewardInformation;
@@ -3860,7 +4034,7 @@ contract UiIncentiveDataProviderV3 is IUiIncentiveDataProviderV3 {
     );

     for (uint256 i = 0; i < reserves.length; i++) {
-      DataTypes.ReserveData memory baseData = pool.getReserveData(reserves[i]);
+      DataTypes.ReserveDataLegacy memory baseData = pool.getReserveData(reserves[i]);

       // user reserve data
       userReservesIncentivesData[i].underlyingAsset = reserves[i];
```
