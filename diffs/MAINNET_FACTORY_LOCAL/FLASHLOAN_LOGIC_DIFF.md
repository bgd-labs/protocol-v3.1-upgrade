```diff
diff --git a/./downloads/MAINNET/FLASHLOAN_LOGIC.sol b/./downloads/FACTORY_LOCAL/FLASHLOAN_LOGIC.sol
index dd9c0ae..76c23f9 100644
--- a/./downloads/MAINNET/FLASHLOAN_LOGIC.sol
+++ b/./downloads/FACTORY_LOCAL/FLASHLOAN_LOGIC.sol
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: MIT
+// SPDX-License-Identifier: BUSL-1.1
 pragma solidity ^0.8.0 ^0.8.10;
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/Address.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/Address.sol
 
 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
 
@@ -221,7 +221,7 @@ library Address {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/Context.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/Context.sol
 
 /*
  * @dev Provides information about the current execution context, including the
@@ -244,7 +244,7 @@ abstract contract Context {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/IAccessControl.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IAccessControl.sol
 
 /**
  * @dev External interface of AccessControl declared to support ERC165 detection.
@@ -334,7 +334,7 @@ interface IAccessControl {
   function renounceRole(bytes32 role, address account) external;
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
 
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
@@ -410,7 +410,7 @@ interface IERC20 {
   event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
 
 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
 
@@ -666,7 +666,7 @@ library SafeCast {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IAaveIncentivesController.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveIncentivesController.sol
 
 /**
  * @title IAaveIncentivesController
@@ -685,7 +685,7 @@ interface IAaveIncentivesController {
   function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IPoolAddressesProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolAddressesProvider.sol
 
 /**
  * @title IPoolAddressesProvider
@@ -912,7 +912,7 @@ interface IPoolAddressesProvider {
   function setPoolDataProvider(address newDataProvider) external;
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IPriceOracleGetter.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPriceOracleGetter.sol
 
 /**
  * @title IPriceOracleGetter
@@ -942,7 +942,7 @@ interface IPriceOracleGetter {
   function getAssetPrice(address asset) external view returns (uint256);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IScaledBalanceToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IScaledBalanceToken.sol
 
 /**
  * @title IScaledBalanceToken
@@ -1014,7 +1014,7 @@ interface IScaledBalanceToken {
   function getPreviousIndex(address user) external view returns (uint256);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol
 
 /**
  * @title Errors library
@@ -1112,9 +1112,16 @@ library Errors {
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
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/math/PercentageMath.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/PercentageMath.sol
 
 /**
  * @title PercentageMath library
@@ -1175,7 +1182,7 @@ library PercentageMath {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/math/WadRayMath.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/WadRayMath.sol
 
 /**
  * @title WadRayMath library
@@ -1301,9 +1308,46 @@ library WadRayMath {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/types/DataTypes.sol
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
@@ -1321,6 +1365,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -1335,6 +1381,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }
 
   struct ReserveConfigurationMap {
@@ -1351,13 +1399,14 @@ library DataTypes {
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
@@ -1557,7 +1606,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }
 
   struct InitReserveParams {
@@ -1571,7 +1621,7 @@ library DataTypes {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol
 
 /// @title Gnosis Protocol v2 Safe ERC20 Transfer Library
 /// @author Gnosis Developers
@@ -1684,7 +1734,7 @@ library GPv2SafeERC20 {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
 
 interface IERC20Detailed is IERC20 {
   function name() external view returns (string memory);
@@ -1694,7 +1744,7 @@ interface IERC20Detailed is IERC20 {
   function decimals() external view returns (uint8);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IACLManager.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IACLManager.sol
 
 /**
  * @title IACLManager
@@ -1867,7 +1917,7 @@ interface IACLManager {
   function isAssetListingAdmin(address admin) external view returns (bool);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IPriceOracleSentinel.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPriceOracleSentinel.sol
 
 /**
  * @title IPriceOracleSentinel
@@ -1932,27 +1982,35 @@ interface IPriceOracleSentinel {
   function getGracePeriod() external view returns (uint256);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IReserveInterestRateStrategy.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IReserveInterestRateStrategy.sol
 
 /**
  * @title IReserveInterestRateStrategy
- * @author Aave
- * @notice Interface for the calculation of the interest rates
+ * @author BGD Labs
+ * @notice Basic interface for any rate strategy used by the Aave protocol
  */
 interface IReserveInterestRateStrategy {
+  /**
+   * @notice Sets interest rate data for an Aave rate strategy
+   * @param reserve The reserve to update
+   * @param rateData The abi encoded reserve interest rate data to apply to the given reserve
+   *   Abstracted this way as rate strategies can be custom
+   */
+  function setInterestRateParams(address reserve, bytes calldata rateData) external;
+
   /**
    * @notice Calculates the interest rates depending on the reserve's state and configurations
    * @param params The parameters needed to calculate interest rates
-   * @return liquidityRate The liquidity rate expressed in rays
-   * @return stableBorrowRate The stable borrow rate expressed in rays
-   * @return variableBorrowRate The variable borrow rate expressed in rays
+   * @return liquidityRate The liquidity rate expressed in ray
+   * @return stableBorrowRate The stable borrow rate expressed in ray
+   * @return variableBorrowRate The variable borrow rate expressed in ray
    */
   function calculateInterestRates(
     DataTypes.CalculateInterestRatesParams memory params
   ) external view returns (uint256, uint256, uint256);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/math/MathUtils.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/MathUtils.sol
 
 /**
  * @title MathUtils library
@@ -2049,7 +2107,7 @@ library MathUtils {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol
 
 /**
  * @title IPool
@@ -2427,6 +2485,14 @@ interface IPool {
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
@@ -2571,6 +2637,22 @@ interface IPool {
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
@@ -2626,7 +2708,23 @@ interface IPool {
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
@@ -2731,6 +2829,22 @@ interface IPool {
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
@@ -2788,9 +2902,44 @@ interface IPool {
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
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
 
 /**
  * @title ReserveConfiguration library
@@ -2817,6 +2966,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
 
   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -2837,6 +2987,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;
 
   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -3332,6 +3483,31 @@ library ReserveConfiguration {
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
@@ -3398,7 +3574,7 @@ library ReserveConfiguration {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/helpers/Helpers.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Helpers.sol
 
 /**
  * @title Helpers library
@@ -3423,7 +3599,7 @@ library Helpers {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
+// lib/aave-v3-origin/src/core/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
 
 /**
  * @title IFlashLoanReceiver
@@ -3456,7 +3632,7 @@ interface IFlashLoanReceiver {
   function POOL() external view returns (IPool);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol
+// lib/aave-v3-origin/src/core/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol
 
 /**
  * @title IFlashLoanSimpleReceiver
@@ -3489,7 +3665,7 @@ interface IFlashLoanSimpleReceiver {
   function POOL() external view returns (IPool);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/configuration/UserConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/UserConfiguration.sol
 
 /**
  * @title UserConfiguration library
@@ -3721,7 +3897,7 @@ library UserConfiguration {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableAToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableAToken.sol
 
 /**
  * @title IInitializableAToken
@@ -3774,7 +3950,7 @@ interface IInitializableAToken {
   ) external;
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableDebtToken.sol
 
 /**
  * @title IInitializableDebtToken
@@ -3823,7 +3999,7 @@ interface IInitializableDebtToken {
   ) external;
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IStableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IStableDebtToken.sol
 
 /**
  * @title IStableDebtToken
@@ -3960,7 +4136,7 @@ interface IStableDebtToken is IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/IsolationModeLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/IsolationModeLogic.sol
 
 /**
  * @title IsolationModeLogic library
@@ -4019,7 +4195,7 @@ library IsolationModeLogic {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IVariableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IVariableDebtToken.sol
 
 /**
  * @title IVariableDebtToken
@@ -4062,7 +4238,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/interfaces/IAToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAToken.sol
 
 /**
  * @title IAToken
@@ -4196,7 +4372,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
   function rescueTokens(address token, address to, uint256 amount) external;
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
 
 /**
  * @title IncentivizedERC20
@@ -4251,15 +4427,15 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   /**
    * @dev Constructor.
    * @param pool The reference to the main Pool contract
-   * @param name The name of the token
-   * @param symbol The symbol of the token
-   * @param decimals The number of decimals of the token
+   * @param name_ The name of the token
+   * @param symbol_ The symbol of the token
+   * @param decimals_ The number of decimals of the token
    */
-  constructor(IPool pool, string memory name, string memory symbol, uint8 decimals) {
+  constructor(IPool pool, string memory name_, string memory symbol_, uint8 decimals_) {
     _addressesProvider = pool.ADDRESSES_PROVIDER();
-    _name = name;
-    _symbol = symbol;
-    _decimals = decimals;
+    _name = name_;
+    _symbol = symbol_;
+    _decimals = decimals_;
     POOL = pool;
   }
 
@@ -4420,7 +4596,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/ReserveLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ReserveLogic.sol
 
 /**
  * @title ReserveLogic library
@@ -4562,7 +4738,7 @@ library ReserveLogic {
     reserve.interestRateStrategyAddress = interestRateStrategyAddress;
   }
 
-  struct UpdateInterestRatesLocalVars {
+  struct UpdateInterestRatesAndVirtualBalanceLocalVars {
     uint256 nextLiquidityRate;
     uint256 nextStableRate;
     uint256 nextVariableRate;
@@ -4577,14 +4753,14 @@ library ReserveLogic {
    * @param liquidityAdded The amount of liquidity added to the protocol (supply or repay) in the previous action
    * @param liquidityTaken The amount of liquidity taken from the protocol (redeem or borrow)
    */
-  function updateInterestRates(
+  function updateInterestRatesAndVirtualBalance(
     DataTypes.ReserveData storage reserve,
     DataTypes.ReserveCache memory reserveCache,
     address reserveAddress,
     uint256 liquidityAdded,
     uint256 liquidityTaken
   ) internal {
-    UpdateInterestRatesLocalVars memory vars;
+    UpdateInterestRatesAndVirtualBalanceLocalVars memory vars;
 
     vars.totalVariableDebt = reserveCache.nextScaledVariableDebt.rayMul(
       reserveCache.nextVariableBorrowIndex
@@ -4604,7 +4780,8 @@ library ReserveLogic {
         averageStableBorrowRate: reserveCache.nextAvgStableBorrowRate,
         reserveFactor: reserveCache.reserveFactor,
         reserve: reserveAddress,
-        aToken: reserveCache.aTokenAddress
+        usingVirtualBalance: reserve.configuration.getIsVirtualAccActive(),
+        virtualUnderlyingBalance: reserve.virtualUnderlyingBalance
       })
     );
 
@@ -4612,6 +4789,16 @@ library ReserveLogic {
     reserve.currentStableBorrowRate = vars.nextStableRate.toUint128();
     reserve.currentVariableBorrowRate = vars.nextVariableRate.toUint128();
 
+    // Only affect virtual balance if the reserve uses it
+    if (reserve.configuration.getIsVirtualAccActive()) {
+      if (liquidityAdded > 0) {
+        reserve.virtualUnderlyingBalance += liquidityAdded.toUint128();
+      }
+      if (liquidityTaken > 0) {
+        reserve.virtualUnderlyingBalance -= liquidityTaken.toUint128();
+      }
+    }
+
     emit ReserveDataUpdated(
       reserveAddress,
       vars.nextLiquidityRate,
@@ -4769,7 +4956,7 @@ library ReserveLogic {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/EModeLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/EModeLogic.sol
 
 /**
  * @title EModeLogic library
@@ -4870,7 +5057,7 @@ library EModeLogic {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/GenericLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/GenericLogic.sol
 
 /**
  * @title GenericLogic library
@@ -5128,7 +5315,7 @@ library GenericLogic {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/ValidationLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ValidationLogic.sol
 
 /**
  * @title ReserveLogic library
@@ -5173,7 +5360,8 @@ library ValidationLogic {
   function validateSupply(
     DataTypes.ReserveCache memory reserveCache,
     DataTypes.ReserveData storage reserve,
-    uint256 amount
+    uint256 amount,
+    address onBehalfOf
   ) internal view {
     require(amount != 0, Errors.INVALID_AMOUNT);
 
@@ -5183,6 +5371,7 @@ library ValidationLogic {
     require(isActive, Errors.RESERVE_INACTIVE);
     require(!isPaused, Errors.RESERVE_PAUSED);
     require(!isFrozen, Errors.RESERVE_FROZEN);
+    require(onBehalfOf != reserveCache.aTokenAddress, Errors.SUPPLY_TO_ATOKEN);
 
     uint256 supplyCap = reserveCache.reserveConfiguration.getSupplyCap();
     require(
@@ -5265,6 +5454,11 @@ library ValidationLogic {
     require(!vars.isPaused, Errors.RESERVE_PAUSED);
     require(!vars.isFrozen, Errors.RESERVE_FROZEN);
     require(vars.borrowingEnabled, Errors.BORROWING_NOT_ENABLED);
+    require(
+      !params.reserveCache.reserveConfiguration.getIsVirtualAccActive() ||
+        IERC20(params.reserveCache.aTokenAddress).totalSupply() >= params.amount,
+      Errors.INVALID_AMOUNT
+    );
 
     require(
       params.priceOracleSentinel == address(0) ||
@@ -5392,7 +5586,7 @@ library ValidationLogic {
         Errors.COLLATERAL_SAME_AS_BORROWING_CURRENCY
       );
 
-      vars.availableLiquidity = IERC20(params.asset).balanceOf(params.reserveCache.aTokenAddress);
+      vars.availableLiquidity = reservesData[params.asset].virtualUnderlyingBalance;
 
       //calculate the max available loan size in stable rate mode as a percentage of the
       //available liquidity
@@ -5468,12 +5662,11 @@ library ValidationLogic {
     uint256 variableDebt,
     DataTypes.InterestRateMode currentRateMode
   ) internal view {
-    (bool isActive, bool isFrozen, , bool stableRateEnabled, bool isPaused) = reserveCache
+    (bool isActive, , , bool stableRateEnabled, bool isPaused) = reserveCache
       .reserveConfiguration
       .getFlags();
     require(isActive, Errors.RESERVE_INACTIVE);
     require(!isPaused, Errors.RESERVE_PAUSED);
-    require(!isFrozen, Errors.RESERVE_FROZEN);
 
     if (currentRateMode == DataTypes.InterestRateMode.STABLE) {
       require(stableDebt != 0, Errors.NO_OUTSTANDING_STABLE_DEBT);
@@ -5531,7 +5724,8 @@ library ValidationLogic {
           averageStableBorrowRate: 0,
           reserveFactor: reserveCache.reserveFactor,
           reserve: reserveAddress,
-          aToken: reserveCache.aTokenAddress
+          usingVirtualBalance: reserve.configuration.getIsVirtualAccActive(),
+          virtualUnderlyingBalance: reserve.virtualUnderlyingBalance
         })
       );
 
@@ -5571,7 +5765,7 @@ library ValidationLogic {
   ) internal view {
     require(assets.length == amounts.length, Errors.INCONSISTENT_FLASHLOAN_PARAMS);
     for (uint256 i = 0; i < assets.length; i++) {
-      validateFlashloanSimple(reservesData[assets[i]]);
+      validateFlashloanSimple(reservesData[assets[i]], amounts[i]);
     }
   }
 
@@ -5579,11 +5773,19 @@ library ValidationLogic {
    * @notice Validates a flashloan action.
    * @param reserve The state of the reserve
    */
-  function validateFlashloanSimple(DataTypes.ReserveData storage reserve) internal view {
+  function validateFlashloanSimple(
+    DataTypes.ReserveData storage reserve,
+    uint256 amount
+  ) internal view {
     DataTypes.ReserveConfigurationMap memory configuration = reserve.configuration;
     require(!configuration.getPaused(), Errors.RESERVE_PAUSED);
     require(configuration.getActive(), Errors.RESERVE_INACTIVE);
     require(configuration.getFlashLoanEnabled(), Errors.FLASHLOAN_DISABLED);
+    require(
+      !configuration.getIsVirtualAccActive() ||
+        IERC20(reserve.aTokenAddress).totalSupply() >= amount,
+      Errors.INVALID_AMOUNT
+    );
   }
 
   struct ValidateLiquidationCallLocalVars {
@@ -5598,11 +5800,13 @@ library ValidationLogic {
    * @notice Validates the liquidation action.
    * @param userConfig The user configuration mapping
    * @param collateralReserve The reserve data of the collateral
+   * @param debtReserve The reserve data of the debt
    * @param params Additional parameters needed for the validation
    */
   function validateLiquidationCall(
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ReserveData storage collateralReserve,
+    DataTypes.ReserveData storage debtReserve,
     DataTypes.ValidateLiquidationCallParams memory params
   ) internal view {
     ValidateLiquidationCallLocalVars memory vars;
@@ -5626,6 +5830,12 @@ library ValidationLogic {
       Errors.PRICE_ORACLE_SENTINEL_CHECK_FAILED
     );
 
+    require(
+      collateralReserve.liquidationGracePeriodUntil < uint40(block.timestamp) &&
+        debtReserve.liquidationGracePeriodUntil < uint40(block.timestamp),
+      Errors.LIQUIDATION_GRACE_SENTINEL_CHECK_FAILED
+    );
+
     require(
       params.healthFactor < HEALTH_FACTOR_LIQUIDATION_THRESHOLD,
       Errors.HEALTH_FACTOR_NOT_BELOW_THRESHOLD
@@ -5862,7 +6072,7 @@ library ValidationLogic {
   }
 }
 
-// downloads/MAINNET/FLASHLOAN_LOGIC/FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol
 
 /**
  * @title BorrowLogic library
@@ -5901,6 +6111,7 @@ library BorrowLogic {
     DataTypes.InterestRateMode interestRateMode
   );
   event IsolationModeTotalDebtUpdated(address indexed asset, uint256 totalDebt);
+  event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);
 
   /**
    * @notice Implements the borrow feature. Borrowing allows users that provided collateral to draw liquidity from the
@@ -5919,7 +6130,7 @@ library BorrowLogic {
     mapping(uint8 => DataTypes.EModeCategory) storage eModeCategories,
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ExecuteBorrowParams memory params
-  ) public {
+  ) external {
     DataTypes.ReserveData storage reserve = reservesData[params.asset];
     DataTypes.ReserveCache memory reserveCache = reserve.cache();
 
@@ -5991,7 +6202,7 @@ library BorrowLogic {
       );
     }
 
-    reserve.updateInterestRates(
+    reserve.updateInterestRatesAndVirtualBalance(
       reserveCache,
       params.asset,
       0,
@@ -6073,7 +6284,7 @@ library BorrowLogic {
       ).burn(params.onBehalfOf, paybackAmount, reserveCache.nextVariableBorrowIndex);
     }
 
-    reserve.updateInterestRates(
+    reserve.updateInterestRatesAndVirtualBalance(
       reserveCache,
       params.asset,
       params.useATokens ? 0 : paybackAmount,
@@ -6099,6 +6310,11 @@ library BorrowLogic {
         paybackAmount,
         reserveCache.nextLiquidityIndex
       );
+      // in case of aToken repayment the msg.sender must always repay on behalf of itself
+      if (IAToken(reserveCache.aTokenAddress).scaledBalanceOf(msg.sender) == 0) {
+        userConfig.setUsingAsCollateral(reserve.id, false);
+        emit ReserveUsedAsCollateralDisabled(params.asset, msg.sender);
+      }
     } else {
       IERC20(params.asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, paybackAmount);
       IAToken(reserveCache.aTokenAddress).handleRepayment(
@@ -6140,7 +6356,7 @@ library BorrowLogic {
     (, reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = stableDebtToken
       .mint(user, user, stableDebt, reserve.currentStableBorrowRate);
 
-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);
 
     emit RebalanceStableBorrowRate(asset, user);
   }
@@ -6157,16 +6373,14 @@ library BorrowLogic {
     DataTypes.ReserveData storage reserve,
     DataTypes.UserConfigurationMap storage userConfig,
     address asset,
+    address user,
     DataTypes.InterestRateMode interestRateMode
   ) external {
     DataTypes.ReserveCache memory reserveCache = reserve.cache();
 
     reserve.updateState(reserveCache);
 
-    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(
-      msg.sender,
-      reserveCache
-    );
+    (uint256 stableDebt, uint256 variableDebt) = Helpers.getUserCurrentDebt(user, reserveCache);
 
     ValidationLogic.validateSwapRateMode(
       reserve,
@@ -6180,28 +6394,28 @@ library BorrowLogic {
     if (interestRateMode == DataTypes.InterestRateMode.STABLE) {
       (reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = IStableDebtToken(
         reserveCache.stableDebtTokenAddress
-      ).burn(msg.sender, stableDebt);
+      ).burn(user, stableDebt);
 
       (, reserveCache.nextScaledVariableDebt) = IVariableDebtToken(
         reserveCache.variableDebtTokenAddress
-      ).mint(msg.sender, msg.sender, stableDebt, reserveCache.nextVariableBorrowIndex);
+      ).mint(user, user, stableDebt, reserveCache.nextVariableBorrowIndex);
     } else {
       reserveCache.nextScaledVariableDebt = IVariableDebtToken(
         reserveCache.variableDebtTokenAddress
-      ).burn(msg.sender, variableDebt, reserveCache.nextVariableBorrowIndex);
+      ).burn(user, variableDebt, reserveCache.nextVariableBorrowIndex);
 
       (, reserveCache.nextTotalStableDebt, reserveCache.nextAvgStableBorrowRate) = IStableDebtToken(
         reserveCache.stableDebtTokenAddress
-      ).mint(msg.sender, msg.sender, variableDebt, reserve.currentStableBorrowRate);
+      ).mint(user, user, variableDebt, reserve.currentStableBorrowRate);
     }
 
-    reserve.updateInterestRates(reserveCache, asset, 0, 0);
+    reserve.updateInterestRatesAndVirtualBalance(reserveCache, asset, 0, 0);
 
-    emit SwapBorrowRateMode(asset, msg.sender, interestRateMode);
+    emit SwapBorrowRateMode(asset, user, interestRateMode);
   }
 }
 
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
