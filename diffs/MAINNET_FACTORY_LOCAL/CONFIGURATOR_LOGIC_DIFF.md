```diff
diff --git a/./downloads/MAINNET/CONFIGURATOR_LOGIC.sol b/./downloads/FACTORY_LOCAL/CONFIGURATOR_LOGIC.sol
index e8cfc59..c167c74 100644
--- a/./downloads/MAINNET/CONFIGURATOR_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/CONFIGURATOR_LOGIC.sol
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: MIT
+// SPDX-License-Identifier: BUSL-1.1
 pragma solidity ^0.8.0 ^0.8.10;
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/dependencies/openzeppelin/contracts/Address.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/Address.sol
 
 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
 
@@ -221,7 +221,7 @@ library Address {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
 
 /**
  * @title Proxy
@@ -240,6 +240,14 @@ abstract contract Proxy {
     _fallback();
   }
 
+  /**
+   * @dev Fallback function that will run if call data is empty.
+   * IMPORTANT. receive() on implementation contracts will be unreachable
+   */
+  receive() external payable {
+    _fallback();
+  }
+
   /**
    * @return The Address of the implementation.
    */
@@ -294,7 +302,7 @@ abstract contract Proxy {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/interfaces/IAaveIncentivesController.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveIncentivesController.sol
 
 /**
  * @title IAaveIncentivesController
@@ -313,7 +321,7 @@ interface IAaveIncentivesController {
   function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/interfaces/IPoolAddressesProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolAddressesProvider.sol
 
 /**
  * @title IPoolAddressesProvider
@@ -540,7 +548,7 @@ interface IPoolAddressesProvider {
   function setPoolDataProvider(address newDataProvider) external;
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol
 
 /**
  * @title Errors library
@@ -638,9 +646,16 @@ library Errors {
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
   string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
+  string public constant INVALID_MAXRATE = '92'; // The expect maximum borrow rate is invalid
+  string public constant WITHDRAW_TO_ATOKEN = '93'; // Withdrawing to the aToken is not allowed
+  string public constant SUPPLY_TO_ATOKEN = '94'; // Supplying to the aToken is not allowed
+  string public constant SLOPE_2_MUST_BE_GTE_SLOPE_1 = '95'; // Variable interest rate slope 2 can not be lower than slope 1
+  string public constant CALLER_NOT_RISK_OR_POOL_OR_EMERGENCY_ADMIN = '96'; // 'The caller of the function is not a risk, pool or emergency admin'
+  string public constant LIQUIDATION_GRACE_SENTINEL_CHECK_FAILED = '97'; // 'Liquidation grace sentinel validation failed'
+  string public constant INVALID_GRACE_PERIOD = '98'; // Grace period above a valid range
 }
 
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
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/types/DataTypes.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/types/DataTypes.sol
 
 library DataTypes {
+  /**
+   * This exists specifically to maintain the `getReserveData()` interface, since the new, internal
+   * `ReserveData` struct includes the reserve's `virtualUnderlyingBalance`.
+   */
+  struct ReserveDataLegacy {
+    //stores the reserve configuration
+    ReserveConfigurationMap configuration;
+    //the liquidity index. Expressed in ray
+    uint128 liquidityIndex;
+    //the current supply rate. Expressed in ray
+    uint128 currentLiquidityRate;
+    //variable borrow index. Expressed in ray
+    uint128 variableBorrowIndex;
+    //the current variable borrow rate. Expressed in ray
+    uint128 currentVariableBorrowRate;
+    //the current stable borrow rate. Expressed in ray
+    uint128 currentStableBorrowRate;
+    //timestamp of last update
+    uint40 lastUpdateTimestamp;
+    //the id of the reserve. Represents the position in the list of the active reserves
+    uint16 id;
+    //aToken address
+    address aTokenAddress;
+    //stableDebtToken address
+    address stableDebtTokenAddress;
+    //variableDebtToken address
+    address variableDebtTokenAddress;
+    //address of the interest rate strategy
+    address interestRateStrategyAddress;
+    //the current treasury balance, scaled
+    uint128 accruedToTreasury;
+    //the outstanding unbacked aTokens minted through the bridging feature
+    uint128 unbacked;
+    //the outstanding debt borrowed against this asset in isolation mode
+    uint128 isolationModeTotalDebt;
+  }
+
   struct ReserveData {
     //stores the reserve configuration
     ReserveConfigurationMap configuration;
@@ -701,6 +755,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -715,6 +771,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }
 
   struct ReserveConfigurationMap {
@@ -731,13 +789,14 @@ library DataTypes {
     //bit 62: siloed borrowing enabled
     //bit 63: flashloaning enabled
     //bit 64-79: reserve factor
-    //bit 80-115 borrow cap in whole tokens, borrowCap == 0 => no cap
-    //bit 116-151 supply cap in whole tokens, supplyCap == 0 => no cap
-    //bit 152-167 liquidation protocol fee
-    //bit 168-175 eMode category
-    //bit 176-211 unbacked mint cap in whole tokens, unbackedMintCap == 0 => minting disabled
-    //bit 212-251 debt ceiling for isolation mode with (ReserveConfiguration::DEBT_CEILING_DECIMALS) decimals
-    //bit 252-255 unused
+    //bit 80-115: borrow cap in whole tokens, borrowCap == 0 => no cap
+    //bit 116-151: supply cap in whole tokens, supplyCap == 0 => no cap
+    //bit 152-167: liquidation protocol fee
+    //bit 168-175: eMode category
+    //bit 176-211: unbacked mint cap in whole tokens, unbackedMintCap == 0 => minting disabled
+    //bit 212-251: debt ceiling for isolation mode with (ReserveConfiguration::DEBT_CEILING_DECIMALS) decimals
+    //bit 252: virtual accounting is enabled for the reserve
+    //bit 253-255 unused
 
     uint256 data;
   }
@@ -872,6 +931,7 @@ library DataTypes {
     uint256 maxStableRateBorrowSizePercent;
     uint256 reservesCount;
     address addressesProvider;
+    address pool;
     uint8 userEModeCategory;
     bool isAuthorizedFlashBorrower;
   }
@@ -936,7 +996,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }
 
   struct InitReserveParams {
@@ -950,7 +1011,35 @@ library DataTypes {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IReserveInterestRateStrategy.sol
+
+/**
+ * @title IReserveInterestRateStrategy
+ * @author BGD Labs
+ * @notice Basic interface for any rate strategy used by the Aave protocol
+ */
+interface IReserveInterestRateStrategy {
+  /**
+   * @notice Sets interest rate data for an Aave rate strategy
+   * @param reserve The reserve to update
+   * @param rateData The abi encoded reserve interest rate data to apply to the given reserve
+   *   Abstracted this way as rate strategies can be custom
+   */
+  function setInterestRateParams(address reserve, bytes calldata rateData) external;
+
+  /**
+   * @notice Calculates the interest rates depending on the reserve's state and configurations
+   * @param params The parameters needed to calculate interest rates
+   * @return liquidityRate The liquidity rate expressed in ray
+   * @return stableBorrowRate The stable borrow rate expressed in ray
+   * @return variableBorrowRate The variable borrow rate expressed in ray
+   */
+  function calculateInterestRates(
+    DataTypes.CalculateInterestRatesParams memory params
+  ) external view returns (uint256, uint256, uint256);
+}
+
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
 
 /**
  * @title BaseUpgradeabilityProxy
@@ -1013,7 +1102,7 @@ contract BaseUpgradeabilityProxy is Proxy {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol
 
 /**
  * @title IPool
@@ -1391,6 +1480,14 @@ interface IPool {
    */
   function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
 
+  /**
+   * @notice Allows a borrower to swap his debt between stable and variable mode,
+   * @dev introduce in a flavor stable rate deprecation
+   * @param asset The address of the underlying asset borrowed
+   * @param user The address of the user to be swapped
+   */
+  function swapToVariable(address asset, address user) external;
+
   /**
    * @notice Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
    * - Users can be rebalanced if the following conditions are satisfied:
@@ -1535,6 +1632,22 @@ interface IPool {
     address rateStrategyAddress
   ) external;
 
+  /**
+   * @notice Accumulates interest to all indexes of the reserve
+   * @dev Only callable by the PoolConfigurator contract
+   * @dev To be used when required by the configurator, for example when updating interest rates strategy data
+   * @param asset The address of the underlying asset of the reserve
+   */
+  function syncIndexesState(address asset) external;
+
+  /**
+   * @notice Updates interest rates on the reserve data
+   * @dev Only callable by the PoolConfigurator contract
+   * @dev To be used when required by the configurator, for example when updating interest rates strategy data
+   * @param asset The address of the underlying asset of the reserve
+   */
+  function syncRatesState(address asset) external;
+
   /**
    * @notice Sets the configuration bitmap of the reserve as a whole
    * @dev Only callable by the PoolConfigurator contract
@@ -1590,7 +1703,23 @@ interface IPool {
    * @param asset The address of the underlying asset of the reserve
    * @return The state and configuration data of the reserve
    */
-  function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
+  function getReserveData(address asset) external view returns (DataTypes.ReserveDataLegacy memory);
+
+  /**
+   * @notice Returns the state and configuration of the reserve, including extra data included with Aave v3.1
+   * @param asset The address of the underlying asset of the reserve
+   * @return The state and configuration data of the reserve with virtual accounting
+   */
+  function getReserveDataExtended(
+    address asset
+  ) external view returns (DataTypes.ReserveData memory);
+
+  /**
+   * @notice Returns the virtual underlying balance of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The reserve virtual underlying balance
+   */
+  function getVirtualUnderlyingBalance(address asset) external view returns (uint128);
 
   /**
    * @notice Validates and finalizes an aToken transfer
@@ -1618,6 +1747,13 @@ interface IPool {
    */
   function getReservesList() external view returns (address[] memory);
 
+  /**
+   * @notice Returns the number of initialized reserves
+   * @dev It includes dropped reserves
+   * @return The count
+   */
+  function getReservesCount() external view returns (uint256);
+
   /**
    * @notice Returns the address of the underlying asset of a reserve by the reserve id as stored in the DataTypes.ReserveData struct
    * @param id The id of the reserve as stored in the DataTypes.ReserveData struct
@@ -1688,6 +1824,22 @@ interface IPool {
    */
   function resetIsolationModeTotalDebt(address asset) external;
 
+  /**
+   * @notice Sets the liquidation grace period of the given asset
+   * @dev To enable a liquidation grace period, a timestamp in the future should be set,
+   *      To disable a liquidation grace period, any timestamp in the past works, like 0
+   * @param asset The address of the underlying asset to set the liquidationGracePeriod
+   * @param until Timestamp when the liquidation grace period will end
+   **/
+  function setLiquidationGracePeriod(address asset, uint40 until) external;
+
+  /**
+   * @notice Returns the liquidation grace period of the given asset
+   * @param asset The address of the underlying asset
+   * @return Timestamp when the liquidation grace period will end
+   **/
+  function getLiquidationGracePeriod(address asset) external returns (uint40);
+
   /**
    * @notice Returns the percentage of available liquidity that can be borrowed at once at stable rate
    * @return The percentage of available liquidity to borrow, expressed in bps
@@ -1745,9 +1897,44 @@ interface IPool {
    *   0 if the action is executed directly by the user, without any middle-man
    */
   function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
+
+  /**
+   * @notice Gets the address of the external FlashLoanLogic
+   */
+  function getFlashLoanLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external BorrowLogic
+   */
+  function getBorrowLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external BridgeLogic
+   */
+  function getBridgeLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external EModeLogic
+   */
+  function getEModeLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external LiquidationLogic
+   */
+  function getLiquidationLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external PoolLogic
+   */
+  function getPoolLogic() external returns (address);
+
+  /**
+   * @notice Gets the address of the external SupplyLogic
+   */
+  function getSupplyLogic() external returns (address);
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
 
 /**
  * @title ReserveConfiguration library
@@ -1774,6 +1961,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
 
   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -1794,6 +1982,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;
 
   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -2289,6 +2478,31 @@ library ReserveConfiguration {
     return (self.data & ~FLASHLOAN_ENABLED_MASK) != 0;
   }
 
+  /**
+   * @notice Sets the virtual account active/not state of the reserve
+   * @param self The reserve configuration
+   * @param active The active state
+   */
+  function setVirtualAccActive(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool active
+  ) internal pure {
+    self.data =
+      (self.data & VIRTUAL_ACC_ACTIVE) |
+      (uint256(active ? 1 : 0) << VIRTUAL_ACC_START_BIT_POSITION);
+  }
+
+  /**
+   * @notice Gets the virtual account active/not state of the reserve
+   * @param self The reserve configuration
+   * @return The active state
+   */
+  function getIsVirtualAccActive(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
+    return (self.data & ~VIRTUAL_ACC_ACTIVE) != 0;
+  }
+
   /**
    * @notice Gets the configuration flags of the reserve
    * @param self The reserve configuration
@@ -2355,7 +2569,7 @@ library ReserveConfiguration {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
 
 /**
  * @title InitializableUpgradeabilityProxy
@@ -2382,7 +2596,7 @@ contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
 
 /**
  * @title BaseImmutableAdminUpgradeabilityProxy
@@ -2399,10 +2613,10 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
 
   /**
    * @dev Constructor.
-   * @param admin The address of the admin
+   * @param admin_ The address of the admin
    */
-  constructor(address admin) {
-    _admin = admin;
+  constructor(address admin_) {
+    _admin = admin_;
   }
 
   modifier ifAdmin() {
@@ -2465,7 +2679,7 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
   }
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/interfaces/IInitializableAToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableAToken.sol
 
 /**
  * @title IInitializableAToken
@@ -2518,7 +2732,7 @@ interface IInitializableAToken {
   ) external;
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/interfaces/IInitializableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableDebtToken.sol
 
 /**
  * @title IInitializableDebtToken
@@ -2567,7 +2781,7 @@ interface IInitializableDebtToken {
   ) external;
 }
 
-// downloads/MAINNET/CONFIGURATOR_LOGIC/ConfiguratorLogic/src/core/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol
 
 /**
  * @title InitializableAdminUpgradeabilityProxy
@@ -2592,7 +2806,7 @@ contract InitializableImmutableAdminUpgradeabilityProxy is
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
