```diff
diff --git a/./downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL.sol b/./downloads/FACTORY_LOCAL/DEFAULT_STABLE_DEBT_TOKEN_IMPL.sol
index 87f3628..39dbbac 100644
--- a/./downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL.sol
+++ b/./downloads/FACTORY_LOCAL/DEFAULT_STABLE_DEBT_TOKEN_IMPL.sol
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity =0.8.10 ^0.8.0;
+pragma solidity ^0.8.0 ^0.8.10;
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/Context.sol
 
 /*
  * @dev Provides information about the current execution context, including the
@@ -24,7 +24,7 @@ abstract contract Context {
   }
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
 
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
@@ -100,7 +100,7 @@ interface IERC20 {
   event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
 
 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
 
@@ -356,7 +356,7 @@ library SafeCast {
   }
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveIncentivesController.sol
 
 /**
  * @title IAaveIncentivesController
@@ -375,7 +375,7 @@ interface IAaveIncentivesController {
   function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/ICreditDelegationToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/ICreditDelegationToken.sol
 
 /**
  * @title ICreditDelegationToken
@@ -435,7 +435,7 @@ interface ICreditDelegationToken {
   ) external;
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolAddressesProvider.sol
 
 /**
  * @title IPoolAddressesProvider
@@ -662,7 +662,7 @@ interface IPoolAddressesProvider {
   function setPoolDataProvider(address newDataProvider) external;
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
 
 /**
  * @title VersionedInitializable
@@ -739,7 +739,7 @@ abstract contract VersionedInitializable {
   uint256[50] private ______gap;
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol
 
 /**
  * @title Errors library
@@ -807,7 +807,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -837,9 +837,16 @@ library Errors {
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
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/WadRayMath.sol
 
 /**
  * @title WadRayMath library
@@ -965,9 +972,46 @@ library WadRayMath {
   }
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
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
@@ -985,6 +1029,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -999,6 +1045,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }
 
   struct ReserveConfigurationMap {
@@ -1012,15 +1060,17 @@ library DataTypes {
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
@@ -1155,6 +1205,7 @@ library DataTypes {
     uint256 maxStableRateBorrowSizePercent;
     uint256 reservesCount;
     address addressesProvider;
+    address pool;
     uint8 userEModeCategory;
     bool isAuthorizedFlashBorrower;
   }
@@ -1219,7 +1270,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }
 
   struct InitReserveParams {
@@ -1233,7 +1285,7 @@ library DataTypes {
   }
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/base/EIP712Base.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/base/EIP712Base.sol
 
 /**
  * @title EIP712Base
@@ -1303,7 +1355,7 @@ abstract contract EIP712Base {
   function _EIP712BaseId() internal view virtual returns (string memory);
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
 
 interface IERC20Detailed is IERC20 {
   function name() external view returns (string memory);
@@ -1313,7 +1365,7 @@ interface IERC20Detailed is IERC20 {
   function decimals() external view returns (uint8);
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/IACLManager.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IACLManager.sol
 
 /**
  * @title IACLManager
@@ -1486,104 +1538,7 @@ interface IACLManager {
   function isAssetListingAdmin(address admin) external view returns (bool);
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/libraries/math/MathUtils.sol
-
-/**
- * @title MathUtils library
- * @author Aave
- * @notice Provides functions to perform linear and compounded interest calculations
- */
-library MathUtils {
-  using WadRayMath for uint256;
-
-  /// @dev Ignoring leap years
-  uint256 internal constant SECONDS_PER_YEAR = 365 days;
-
-  /**
-   * @dev Function to calculate the interest accumulated using a linear interest rate formula
-   * @param rate The interest rate, in ray
-   * @param lastUpdateTimestamp The timestamp of the last update of the interest
-   * @return The interest rate linearly accumulated during the timeDelta, in ray
-   */
-  function calculateLinearInterest(
-    uint256 rate,
-    uint40 lastUpdateTimestamp
-  ) internal view returns (uint256) {
-    //solium-disable-next-line
-    uint256 result = rate * (block.timestamp - uint256(lastUpdateTimestamp));
-    unchecked {
-      result = result / SECONDS_PER_YEAR;
-    }
-
-    return WadRayMath.RAY + result;
-  }
-
-  /**
-   * @dev Function to calculate the interest using a compounded interest rate formula
-   * To avoid expensive exponentiation, the calculation is performed using a binomial approximation:
-   *
-   *  (1+x)^n = 1+n*x+[n/2*(n-1)]*x^2+[n/6*(n-1)*(n-2)*x^3...
-   *
-   * The approximation slightly underpays liquidity providers and undercharges borrowers, with the advantage of great
-   * gas cost reductions. The whitepaper contains reference to the approximation and a table showing the margin of
-   * error per different time periods
-   *
-   * @param rate The interest rate, in ray
-   * @param lastUpdateTimestamp The timestamp of the last update of the interest
-   * @return The interest rate compounded during the timeDelta, in ray
-   */
-  function calculateCompoundedInterest(
-    uint256 rate,
-    uint40 lastUpdateTimestamp,
-    uint256 currentTimestamp
-  ) internal pure returns (uint256) {
-    //solium-disable-next-line
-    uint256 exp = currentTimestamp - uint256(lastUpdateTimestamp);
-
-    if (exp == 0) {
-      return WadRayMath.RAY;
-    }
-
-    uint256 expMinusOne;
-    uint256 expMinusTwo;
-    uint256 basePowerTwo;
-    uint256 basePowerThree;
-    unchecked {
-      expMinusOne = exp - 1;
-
-      expMinusTwo = exp > 2 ? exp - 2 : 0;
-
-      basePowerTwo = rate.rayMul(rate) / (SECONDS_PER_YEAR * SECONDS_PER_YEAR);
-      basePowerThree = basePowerTwo.rayMul(rate) / SECONDS_PER_YEAR;
-    }
-
-    uint256 secondTerm = exp * expMinusOne * basePowerTwo;
-    unchecked {
-      secondTerm /= 2;
-    }
-    uint256 thirdTerm = exp * expMinusOne * expMinusTwo * basePowerThree;
-    unchecked {
-      thirdTerm /= 6;
-    }
-
-    return WadRayMath.RAY + (rate * exp) / SECONDS_PER_YEAR + secondTerm + thirdTerm;
-  }
-
-  /**
-   * @dev Calculates the compounded interest between the timestamp of the last update and the current block timestamp
-   * @param rate The interest rate (in ray)
-   * @param lastUpdateTimestamp The timestamp from which the interest accumulation needs to be calculated
-   * @return The interest rate compounded between lastUpdateTimestamp and current block timestamp, in ray
-   */
-  function calculateCompoundedInterest(
-    uint256 rate,
-    uint40 lastUpdateTimestamp
-  ) internal view returns (uint256) {
-    return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
-  }
-}
-
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol
 
 /**
  * @title IPool
@@ -1961,6 +1916,14 @@ interface IPool {
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
@@ -2002,7 +1965,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -2029,7 +1992,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -2105,6 +2068,22 @@ interface IPool {
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
@@ -2160,7 +2139,23 @@ interface IPool {
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
@@ -2188,6 +2183,13 @@ interface IPool {
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
@@ -2258,6 +2260,22 @@ interface IPool {
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
@@ -2315,9 +2333,44 @@ interface IPool {
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
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableDebtToken.sol
 
 /**
  * @title IInitializableDebtToken
@@ -2366,7 +2419,7 @@ interface IInitializableDebtToken {
   ) external;
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/interfaces/IStableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IStableDebtToken.sol
 
 /**
  * @title IStableDebtToken
@@ -2503,7 +2556,7 @@ interface IStableDebtToken is IInitializableDebtToken {
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/base/DebtTokenBase.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/base/DebtTokenBase.sol
 
 /**
  * @title DebtTokenBase
@@ -2599,7 +2652,7 @@ abstract contract DebtTokenBase is
   }
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
 
 /**
  * @title IncentivizedERC20
@@ -2654,15 +2707,15 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
 
@@ -2823,7 +2876,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   }
 }
 
-// downloads/MAINNET/DEFAULT_STABLE_DEBT_TOKEN_IMPL/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/StableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/StableDebtToken.sol
 
 /**
  * @title StableDebtToken
@@ -2832,20 +2885,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
  * at stable rate mode
  * @dev Transfer and approve functionalities are disabled since its a non-transferable token
  */
-contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
-  using WadRayMath for uint256;
-  using SafeCast for uint256;
-
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
-
-  // Map of users address and the timestamp of their last update (userAddress => lastUpdateTimestamp)
-  mapping(address => uint40) internal _timestamps;
-
-  uint128 internal _avgStableRate;
-
-  // Timestamp of the last update of the total supply
-  uint40 internal _totalSupplyTimestamp;
-
+abstract contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
   /**
    * @dev Constructor.
    * @param pool The address of the Pool contract
@@ -2865,245 +2905,66 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
     string memory debtTokenName,
     string memory debtTokenSymbol,
     bytes calldata params
-  ) external override initializer {
-    require(initializingPool == POOL, Errors.POOL_ADDRESSES_DO_NOT_MATCH);
-    _setName(debtTokenName);
-    _setSymbol(debtTokenSymbol);
-    _setDecimals(debtTokenDecimals);
-
-    _underlyingAsset = underlyingAsset;
-    _incentivesController = incentivesController;
-
-    _domainSeparator = _calculateDomainSeparator();
-
-    emit Initialized(
-      underlyingAsset,
-      address(POOL),
-      address(incentivesController),
-      debtTokenDecimals,
-      debtTokenName,
-      debtTokenSymbol,
-      params
-    );
-  }
-
-  /// @inheritdoc VersionedInitializable
-  function getRevision() internal pure virtual override returns (uint256) {
-    return DEBT_TOKEN_REVISION;
-  }
+  ) external virtual;
 
   /// @inheritdoc IStableDebtToken
-  function getAverageStableRate() external view virtual override returns (uint256) {
-    return _avgStableRate;
+  function getAverageStableRate() external pure virtual override returns (uint256) {
+    return 0;
   }
 
   /// @inheritdoc IStableDebtToken
-  function getUserLastUpdated(address user) external view virtual override returns (uint40) {
-    return _timestamps[user];
+  function getUserLastUpdated(address) external pure virtual override returns (uint40) {
+    return 0;
   }
 
   /// @inheritdoc IStableDebtToken
-  function getUserStableRate(address user) external view virtual override returns (uint256) {
-    return _userState[user].additionalData;
+  function getUserStableRate(address) external pure virtual override returns (uint256) {
+    return 0;
   }
 
   /// @inheritdoc IERC20
-  function balanceOf(address account) public view virtual override returns (uint256) {
-    uint256 accountBalance = super.balanceOf(account);
-    uint256 stableRate = _userState[account].additionalData;
-    if (accountBalance == 0) {
-      return 0;
-    }
-    uint256 cumulatedInterest = MathUtils.calculateCompoundedInterest(
-      stableRate,
-      _timestamps[account]
-    );
-    return accountBalance.rayMul(cumulatedInterest);
-  }
-
-  struct MintLocalVars {
-    uint256 previousSupply;
-    uint256 nextSupply;
-    uint256 amountInRay;
-    uint256 currentStableRate;
-    uint256 nextStableRate;
-    uint256 currentAvgStableRate;
+  function balanceOf(address) public pure virtual override returns (uint256) {
+    return 0;
   }
 
   /// @inheritdoc IStableDebtToken
   function mint(
-    address user,
-    address onBehalfOf,
-    uint256 amount,
-    uint256 rate
+    address,
+    address,
+    uint256,
+    uint256
   ) external virtual override onlyPool returns (bool, uint256, uint256) {
-    MintLocalVars memory vars;
-
-    if (user != onBehalfOf) {
-      _decreaseBorrowAllowance(onBehalfOf, user, amount);
-    }
-
-    (, uint256 currentBalance, uint256 balanceIncrease) = _calculateBalanceIncrease(onBehalfOf);
-
-    vars.previousSupply = totalSupply();
-    vars.currentAvgStableRate = _avgStableRate;
-    vars.nextSupply = _totalSupply = vars.previousSupply + amount;
-
-    vars.amountInRay = amount.wadToRay();
-
-    vars.currentStableRate = _userState[onBehalfOf].additionalData;
-    vars.nextStableRate = (vars.currentStableRate.rayMul(currentBalance.wadToRay()) +
-      vars.amountInRay.rayMul(rate)).rayDiv((currentBalance + amount).wadToRay());
-
-    _userState[onBehalfOf].additionalData = vars.nextStableRate.toUint128();
-
-    //solium-disable-next-line
-    _totalSupplyTimestamp = _timestamps[onBehalfOf] = uint40(block.timestamp);
-
-    // Calculates the updated average stable rate
-    vars.currentAvgStableRate = _avgStableRate = (
-      (vars.currentAvgStableRate.rayMul(vars.previousSupply.wadToRay()) +
-        rate.rayMul(vars.amountInRay)).rayDiv(vars.nextSupply.wadToRay())
-    ).toUint128();
-
-    uint256 amountToMint = amount + balanceIncrease;
-    _mint(onBehalfOf, amountToMint, vars.previousSupply);
-
-    emit Transfer(address(0), onBehalfOf, amountToMint);
-    emit Mint(
-      user,
-      onBehalfOf,
-      amountToMint,
-      currentBalance,
-      balanceIncrease,
-      vars.nextStableRate,
-      vars.currentAvgStableRate,
-      vars.nextSupply
-    );
-
-    return (currentBalance == 0, vars.nextSupply, vars.currentAvgStableRate);
+    revert(Errors.OPERATION_NOT_SUPPORTED);
   }
 
   /// @inheritdoc IStableDebtToken
-  function burn(
-    address from,
-    uint256 amount
-  ) external virtual override onlyPool returns (uint256, uint256) {
-    (, uint256 currentBalance, uint256 balanceIncrease) = _calculateBalanceIncrease(from);
-
-    uint256 previousSupply = totalSupply();
-    uint256 nextAvgStableRate = 0;
-    uint256 nextSupply = 0;
-    uint256 userStableRate = _userState[from].additionalData;
-
-    // Since the total supply and each single user debt accrue separately,
-    // there might be accumulation errors so that the last borrower repaying
-    // might actually try to repay more than the available debt supply.
-    // In this case we simply set the total supply and the avg stable rate to 0
-    if (previousSupply <= amount) {
-      _avgStableRate = 0;
-      _totalSupply = 0;
-    } else {
-      nextSupply = _totalSupply = previousSupply - amount;
-      uint256 firstTerm = uint256(_avgStableRate).rayMul(previousSupply.wadToRay());
-      uint256 secondTerm = userStableRate.rayMul(amount.wadToRay());
-
-      // For the same reason described above, when the last user is repaying it might
-      // happen that user rate * user balance > avg rate * total supply. In that case,
-      // we simply set the avg rate to 0
-      if (secondTerm >= firstTerm) {
-        nextAvgStableRate = _totalSupply = _avgStableRate = 0;
-      } else {
-        nextAvgStableRate = _avgStableRate = (
-          (firstTerm - secondTerm).rayDiv(nextSupply.wadToRay())
-        ).toUint128();
-      }
-    }
-
-    if (amount == currentBalance) {
-      _userState[from].additionalData = 0;
-      _timestamps[from] = 0;
-    } else {
-      //solium-disable-next-line
-      _timestamps[from] = uint40(block.timestamp);
-    }
-    //solium-disable-next-line
-    _totalSupplyTimestamp = uint40(block.timestamp);
-
-    if (balanceIncrease > amount) {
-      uint256 amountToMint = balanceIncrease - amount;
-      _mint(from, amountToMint, previousSupply);
-      emit Transfer(address(0), from, amountToMint);
-      emit Mint(
-        from,
-        from,
-        amountToMint,
-        currentBalance,
-        balanceIncrease,
-        userStableRate,
-        nextAvgStableRate,
-        nextSupply
-      );
-    } else {
-      uint256 amountToBurn = amount - balanceIncrease;
-      _burn(from, amountToBurn, previousSupply);
-      emit Transfer(from, address(0), amountToBurn);
-      emit Burn(from, amountToBurn, currentBalance, balanceIncrease, nextAvgStableRate, nextSupply);
-    }
-
-    return (nextSupply, nextAvgStableRate);
-  }
-
-  /**
-   * @notice Calculates the increase in balance since the last user interaction
-   * @param user The address of the user for which the interest is being accumulated
-   * @return The previous principal balance
-   * @return The new principal balance
-   * @return The balance increase
-   */
-  function _calculateBalanceIncrease(
-    address user
-  ) internal view returns (uint256, uint256, uint256) {
-    uint256 previousPrincipalBalance = super.balanceOf(user);
-
-    if (previousPrincipalBalance == 0) {
-      return (0, 0, 0);
-    }
-
-    uint256 newPrincipalBalance = balanceOf(user);
-
-    return (
-      previousPrincipalBalance,
-      newPrincipalBalance,
-      newPrincipalBalance - previousPrincipalBalance
-    );
+  function burn(address, uint256) external virtual override onlyPool returns (uint256, uint256) {
+    revert(Errors.OPERATION_NOT_SUPPORTED);
   }
 
   /// @inheritdoc IStableDebtToken
-  function getSupplyData() external view override returns (uint256, uint256, uint256, uint40) {
-    uint256 avgRate = _avgStableRate;
-    return (super.totalSupply(), _calcTotalSupply(avgRate), avgRate, _totalSupplyTimestamp);
+  function getSupplyData() external pure override returns (uint256, uint256, uint256, uint40) {
+    return (0, 0, 0, 0);
   }
 
   /// @inheritdoc IStableDebtToken
-  function getTotalSupplyAndAvgRate() external view override returns (uint256, uint256) {
-    uint256 avgRate = _avgStableRate;
-    return (_calcTotalSupply(avgRate), avgRate);
+  function getTotalSupplyAndAvgRate() external pure override returns (uint256, uint256) {
+    return (0, 0);
   }
 
   /// @inheritdoc IERC20
-  function totalSupply() public view virtual override returns (uint256) {
-    return _calcTotalSupply(_avgStableRate);
+  function totalSupply() public pure virtual override returns (uint256) {
+    return 0;
   }
 
   /// @inheritdoc IStableDebtToken
-  function getTotalSupplyLastUpdated() external view override returns (uint40) {
-    return _totalSupplyTimestamp;
+  function getTotalSupplyLastUpdated() external pure override returns (uint40) {
+    return 0;
   }
 
   /// @inheritdoc IStableDebtToken
-  function principalBalanceOf(address user) external view virtual override returns (uint256) {
-    return super.balanceOf(user);
+  function principalBalanceOf(address) external pure virtual override returns (uint256) {
+    return 0;
   }
 
   /// @inheritdoc IStableDebtToken
@@ -3111,58 +2972,6 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
     return _underlyingAsset;
   }
 
-  /**
-   * @notice Calculates the total supply
-   * @param avgRate The average rate at which the total supply increases
-   * @return The debt balance of the user since the last burn/mint action
-   */
-  function _calcTotalSupply(uint256 avgRate) internal view returns (uint256) {
-    uint256 principalSupply = super.totalSupply();
-
-    if (principalSupply == 0) {
-      return 0;
-    }
-
-    uint256 cumulatedInterest = MathUtils.calculateCompoundedInterest(
-      avgRate,
-      _totalSupplyTimestamp
-    );
-
-    return principalSupply.rayMul(cumulatedInterest);
-  }
-
-  /**
-   * @notice Mints stable debt tokens to a user
-   * @param account The account receiving the debt tokens
-   * @param amount The amount being minted
-   * @param oldTotalSupply The total supply before the minting event
-   */
-  function _mint(address account, uint256 amount, uint256 oldTotalSupply) internal {
-    uint128 castAmount = amount.toUint128();
-    uint128 oldAccountBalance = _userState[account].balance;
-    _userState[account].balance = oldAccountBalance + castAmount;
-
-    if (address(_incentivesController) != address(0)) {
-      _incentivesController.handleAction(account, oldTotalSupply, oldAccountBalance);
-    }
-  }
-
-  /**
-   * @notice Burns stable debt tokens of a user
-   * @param account The user getting his debt burned
-   * @param amount The amount being burned
-   * @param oldTotalSupply The total supply before the burning event
-   */
-  function _burn(address account, uint256 amount, uint256 oldTotalSupply) internal {
-    uint128 castAmount = amount.toUint128();
-    uint128 oldAccountBalance = _userState[account].balance;
-    _userState[account].balance = oldAccountBalance - castAmount;
-
-    if (address(_incentivesController) != address(0)) {
-      _incentivesController.handleAction(account, oldTotalSupply, oldAccountBalance);
-    }
-  }
-
   /// @inheritdoc EIP712Base
   function _EIP712BaseId() internal view override returns (string memory) {
     return name();
```
