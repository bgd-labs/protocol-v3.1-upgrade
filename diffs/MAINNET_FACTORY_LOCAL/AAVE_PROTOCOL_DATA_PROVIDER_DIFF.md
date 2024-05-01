```diff
diff --git a/./downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER.sol b/./downloads/FACTORY_LOCAL/AAVE_PROTOCOL_DATA_PROVIDER.sol
index 2ebccfd..1174fe5 100644
--- a/./downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER.sol
+++ b/./downloads/FACTORY_LOCAL/AAVE_PROTOCOL_DATA_PROVIDER.sol
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: BUSL-1.1
-pragma solidity =0.8.10 ^0.8.0;
+// SPDX-License-Identifier: MIT
+pragma solidity ^0.8.0 ^0.8.10;
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
 
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
@@ -77,7 +77,7 @@ interface IERC20 {
   event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveIncentivesController.sol
 
 /**
  * @title IAaveIncentivesController
@@ -96,7 +96,7 @@ interface IAaveIncentivesController {
   function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolAddressesProvider.sol
 
 /**
  * @title IPoolAddressesProvider
@@ -323,7 +323,7 @@ interface IPoolAddressesProvider {
   function setPoolDataProvider(address newDataProvider) external;
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IScaledBalanceToken.sol
 
 /**
  * @title IScaledBalanceToken
@@ -395,7 +395,7 @@ interface IScaledBalanceToken {
   function getPreviousIndex(address user) external view returns (uint256);
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol
 
 /**
  * @title Errors library
@@ -463,7 +463,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -493,9 +493,16 @@ library Errors {
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
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/WadRayMath.sol
 
 /**
  * @title WadRayMath library
@@ -621,9 +628,46 @@ library WadRayMath {
   }
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
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
@@ -641,6 +685,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -655,6 +701,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }
 
   struct ReserveConfigurationMap {
@@ -668,15 +716,17 @@ library DataTypes {
     //bit 59: stable rate borrowing enabled
     //bit 60: asset is paused
     //bit 61: borrowing in isolation mode is enabled
-    //bit 62-63: reserved
+    //bit 62: siloed borrowing enabled
+    //bit 63: flashloaning enabled
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
@@ -811,6 +861,7 @@ library DataTypes {
     uint256 maxStableRateBorrowSizePercent;
     uint256 reservesCount;
     address addressesProvider;
+    address pool;
     uint8 userEModeCategory;
     bool isAuthorizedFlashBorrower;
   }
@@ -875,7 +926,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }
 
   struct InitReserveParams {
@@ -889,7 +941,7 @@ library DataTypes {
   }
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
 
 interface IERC20Detailed is IERC20 {
   function name() external view returns (string memory);
@@ -899,7 +951,7 @@ interface IERC20Detailed is IERC20 {
   function decimals() external view returns (uint8);
 }
 
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
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol
 
 /**
  * @title IPool
@@ -1518,6 +1584,14 @@ interface IPool {
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
@@ -1559,7 +1633,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -1586,7 +1660,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -1662,6 +1736,22 @@ interface IPool {
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
@@ -1717,7 +1807,23 @@ interface IPool {
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
@@ -1745,6 +1851,13 @@ interface IPool {
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
@@ -1815,6 +1928,22 @@ interface IPool {
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
@@ -1872,9 +2001,44 @@ interface IPool {
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
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
 
 /**
  * @title ReserveConfiguration library
@@ -1901,6 +2065,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
 
   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -1921,6 +2086,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;
 
   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -2416,6 +2582,31 @@ library ReserveConfiguration {
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
@@ -2482,7 +2673,7 @@ library ReserveConfiguration {
   }
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/UserConfiguration.sol
 
 /**
  * @title UserConfiguration library
@@ -2714,7 +2905,7 @@ library UserConfiguration {
   }
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableDebtToken.sol
 
 /**
  * @title IInitializableDebtToken
@@ -2763,7 +2954,7 @@ interface IInitializableDebtToken {
   ) external;
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IStableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IStableDebtToken.sol
 
 /**
  * @title IStableDebtToken
@@ -2900,7 +3091,7 @@ interface IStableDebtToken is IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
-// downloads/MAINNET/AAVE_PROTOCOL_DATA_PROVIDER/AaveProtocolDataProvider/@aave/core-v3/contracts/interfaces/IVariableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IVariableDebtToken.sol
 
 /**
  * @title IVariableDebtToken
@@ -2943,7 +3134,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
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
