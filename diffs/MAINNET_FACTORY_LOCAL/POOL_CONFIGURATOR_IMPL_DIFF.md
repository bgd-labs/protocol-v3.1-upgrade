```diff
diff --git a/./downloads/MAINNET/POOL_CONFIGURATOR_IMPL.sol b/./downloads/FACTORY_LOCAL/POOL_CONFIGURATOR_IMPL.sol
index b5e47e8..1a3d8bb 100644
--- a/./downloads/MAINNET/POOL_CONFIGURATOR_IMPL.sol
+++ b/./downloads/FACTORY_LOCAL/POOL_CONFIGURATOR_IMPL.sol
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity =0.8.10 ^0.8.0;
+pragma solidity ^0.8.0 ^0.8.10;
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/Address.sol
+
+// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
 
 /**
  * @dev Collection of functions related to the address type
@@ -25,16 +27,15 @@ library Address {
    * ====
    */
   function isContract(address account) internal view returns (bool) {
-    // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
-    // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
-    // for accounts without code, i.e. `keccak256('')`
-    bytes32 codehash;
-    bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
-    // solhint-disable-next-line no-inline-assembly
+    // This method relies on extcodesize, which returns 0 for contracts in
+    // construction, since the code is only stored at the end of the
+    // constructor execution.
+
+    uint256 size;
     assembly {
-      codehash := extcodehash(account)
+      size := extcodesize(account)
     }
-    return (codehash != accountHash && codehash != 0x0);
+    return size > 0;
   }
 
   /**
@@ -56,13 +57,247 @@ library Address {
   function sendValue(address payable recipient, uint256 amount) internal {
     require(address(this).balance >= amount, 'Address: insufficient balance');
 
-    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
     (bool success, ) = recipient.call{value: amount}('');
     require(success, 'Address: unable to send value, recipient may have reverted');
   }
+
+  /**
+   * @dev Performs a Solidity function call using a low level `call`. A
+   * plain `call` is an unsafe replacement for a function call: use this
+   * function instead.
+   *
+   * If `target` reverts with a revert reason, it is bubbled up by this
+   * function (like regular Solidity function calls).
+   *
+   * Returns the raw returned data. To convert to the expected return value,
+   * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
+   *
+   * Requirements:
+   *
+   * - `target` must be a contract.
+   * - calling `target` with `data` must not revert.
+   *
+   * _Available since v3.1._
+   */
+  function functionCall(address target, bytes memory data) internal returns (bytes memory) {
+    return functionCall(target, data, 'Address: low-level call failed');
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
+   * `errorMessage` as a fallback revert reason when `target` reverts.
+   *
+   * _Available since v3.1._
+   */
+  function functionCall(
+    address target,
+    bytes memory data,
+    string memory errorMessage
+  ) internal returns (bytes memory) {
+    return functionCallWithValue(target, data, 0, errorMessage);
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+   * but also transferring `value` wei to `target`.
+   *
+   * Requirements:
+   *
+   * - the calling contract must have an ETH balance of at least `value`.
+   * - the called Solidity function must be `payable`.
+   *
+   * _Available since v3.1._
+   */
+  function functionCallWithValue(
+    address target,
+    bytes memory data,
+    uint256 value
+  ) internal returns (bytes memory) {
+    return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
+   * with `errorMessage` as a fallback revert reason when `target` reverts.
+   *
+   * _Available since v3.1._
+   */
+  function functionCallWithValue(
+    address target,
+    bytes memory data,
+    uint256 value,
+    string memory errorMessage
+  ) internal returns (bytes memory) {
+    require(address(this).balance >= value, 'Address: insufficient balance for call');
+    require(isContract(target), 'Address: call to non-contract');
+
+    (bool success, bytes memory returndata) = target.call{value: value}(data);
+    return verifyCallResult(success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+   * but performing a static call.
+   *
+   * _Available since v3.3._
+   */
+  function functionStaticCall(
+    address target,
+    bytes memory data
+  ) internal view returns (bytes memory) {
+    return functionStaticCall(target, data, 'Address: low-level static call failed');
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
+   * but performing a static call.
+   *
+   * _Available since v3.3._
+   */
+  function functionStaticCall(
+    address target,
+    bytes memory data,
+    string memory errorMessage
+  ) internal view returns (bytes memory) {
+    require(isContract(target), 'Address: static call to non-contract');
+
+    (bool success, bytes memory returndata) = target.staticcall(data);
+    return verifyCallResult(success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+   * but performing a delegate call.
+   *
+   * _Available since v3.4._
+   */
+  function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
+    return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
+   * but performing a delegate call.
+   *
+   * _Available since v3.4._
+   */
+  function functionDelegateCall(
+    address target,
+    bytes memory data,
+    string memory errorMessage
+  ) internal returns (bytes memory) {
+    require(isContract(target), 'Address: delegate call to non-contract');
+
+    (bool success, bytes memory returndata) = target.delegatecall(data);
+    return verifyCallResult(success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
+   * revert reason using the provided one.
+   *
+   * _Available since v4.3._
+   */
+  function verifyCallResult(
+    bool success,
+    bytes memory returndata,
+    string memory errorMessage
+  ) internal pure returns (bytes memory) {
+    if (success) {
+      return returndata;
+    } else {
+      // Look for revert reason and bubble it up if present
+      if (returndata.length > 0) {
+        // The easiest way to bubble the revert reason is using memory via assembly
+
+        assembly {
+          let returndata_size := mload(returndata)
+          revert(add(32, returndata), returndata_size)
+        }
+      } else {
+        revert(errorMessage);
+      }
+    }
+  }
+}
+
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+
+/**
+ * @dev Interface of the ERC20 standard as defined in the EIP.
+ */
+interface IERC20 {
+  /**
+   * @dev Returns the amount of tokens in existence.
+   */
+  function totalSupply() external view returns (uint256);
+
+  /**
+   * @dev Returns the amount of tokens owned by `account`.
+   */
+  function balanceOf(address account) external view returns (uint256);
+
+  /**
+   * @dev Moves `amount` tokens from the caller's account to `recipient`.
+   *
+   * Returns a boolean value indicating whether the operation succeeded.
+   *
+   * Emits a {Transfer} event.
+   */
+  function transfer(address recipient, uint256 amount) external returns (bool);
+
+  /**
+   * @dev Returns the remaining number of tokens that `spender` will be
+   * allowed to spend on behalf of `owner` through {transferFrom}. This is
+   * zero by default.
+   *
+   * This value changes when {approve} or {transferFrom} are called.
+   */
+  function allowance(address owner, address spender) external view returns (uint256);
+
+  /**
+   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
+   *
+   * Returns a boolean value indicating whether the operation succeeded.
+   *
+   * IMPORTANT: Beware that changing an allowance with this method brings the risk
+   * that someone may use both the old and the new allowance by unfortunate
+   * transaction ordering. One possible solution to mitigate this race
+   * condition is to first reduce the spender's allowance to 0 and set the
+   * desired value afterwards:
+   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
+   *
+   * Emits an {Approval} event.
+   */
+  function approve(address spender, uint256 amount) external returns (bool);
+
+  /**
+   * @dev Moves `amount` tokens from `sender` to `recipient` using the
+   * allowance mechanism. `amount` is then deducted from the caller's
+   * allowance.
+   *
+   * Returns a boolean value indicating whether the operation succeeded.
+   *
+   * Emits a {Transfer} event.
+   */
+  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
+
+  /**
+   * @dev Emitted when `value` tokens are moved from one account (`from`) to
+   * another (`to`).
+   *
+   * Note that `value` may be zero.
+   */
+  event Transfer(address indexed from, address indexed to, uint256 value);
+
+  /**
+   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
+   * a call to {approve}. `value` is the new allowance.
+   */
+  event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
 
 /**
  * @title Proxy
@@ -81,6 +316,14 @@ abstract contract Proxy {
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
@@ -135,7 +378,7 @@ abstract contract Proxy {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IAaveIncentivesController.sol
 
 /**
  * @title IAaveIncentivesController
@@ -154,7 +397,7 @@ interface IAaveIncentivesController {
   function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolAddressesProvider.sol
 
 /**
  * @title IPoolAddressesProvider
@@ -381,7 +624,7 @@ interface IPoolAddressesProvider {
   function setPoolDataProvider(address newDataProvider) external;
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
 
 /**
  * @title VersionedInitializable
@@ -458,7 +701,7 @@ abstract contract VersionedInitializable {
   uint256[50] private ______gap;
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol
 
 /**
  * @title Errors library
@@ -526,7 +769,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -556,9 +799,16 @@ library Errors {
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
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/math/PercentageMath.sol
 
 /**
  * @title PercentageMath library
@@ -619,7 +869,7 @@ library PercentageMath {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol
 
 library ConfiguratorInputTypes {
   struct InitReserveInput {
@@ -627,6 +877,7 @@ library ConfiguratorInputTypes {
     address stableDebtTokenImpl;
     address variableDebtTokenImpl;
     uint8 underlyingAssetDecimals;
+    bool useVirtualBalance;
     address interestRateStrategyAddress;
     address underlyingAsset;
     address treasury;
@@ -638,6 +889,7 @@ library ConfiguratorInputTypes {
     string stableDebtTokenName;
     string stableDebtTokenSymbol;
     bytes params;
+    bytes interestRateData;
   }
 
   struct UpdateATokenInput {
@@ -660,9 +912,46 @@ library ConfiguratorInputTypes {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
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
@@ -680,6 +969,8 @@ library DataTypes {
     uint40 lastUpdateTimestamp;
     //the id of the reserve. Represents the position in the list of the active reserves
     uint16 id;
+    //timestamp in the future, until when liquidations are not allowed on the reserve
+    uint40 liquidationGracePeriodUntil;
     //aToken address
     address aTokenAddress;
     //stableDebtToken address
@@ -694,6 +985,8 @@ library DataTypes {
     uint128 unbacked;
     //the outstanding debt borrowed against this asset in isolation mode
     uint128 isolationModeTotalDebt;
+    //the amount of underlying accounted for by the protocol
+    uint128 virtualUnderlyingBalance;
   }
 
   struct ReserveConfigurationMap {
@@ -707,15 +1000,17 @@ library DataTypes {
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
@@ -850,6 +1145,7 @@ library DataTypes {
     uint256 maxStableRateBorrowSizePercent;
     uint256 reservesCount;
     address addressesProvider;
+    address pool;
     uint8 userEModeCategory;
     bool isAuthorizedFlashBorrower;
   }
@@ -914,7 +1210,8 @@ library DataTypes {
     uint256 averageStableBorrowRate;
     uint256 reserveFactor;
     address reserve;
-    address aToken;
+    bool usingVirtualBalance;
+    uint256 virtualUnderlyingBalance;
   }
 
   struct InitReserveParams {
@@ -928,7 +1225,17 @@ library DataTypes {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IACLManager.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+
+interface IERC20Detailed is IERC20 {
+  function name() external view returns (string memory);
+
+  function symbol() external view returns (string memory);
+
+  function decimals() external view returns (uint8);
+}
+
+// lib/aave-v3-origin/src/core/contracts/interfaces/IACLManager.sol
 
 /**
  * @title IACLManager
@@ -1101,491 +1408,7 @@ interface IACLManager {
   function isAssetListingAdmin(address admin) external view returns (bool);
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolConfigurator.sol
-
-/**
- * @title IPoolConfigurator
- * @author Aave
- * @notice Defines the basic interface for a Pool configurator.
- */
-interface IPoolConfigurator {
-  /**
-   * @dev Emitted when a reserve is initialized.
-   * @param asset The address of the underlying asset of the reserve
-   * @param aToken The address of the associated aToken contract
-   * @param stableDebtToken The address of the associated stable rate debt token
-   * @param variableDebtToken The address of the associated variable rate debt token
-   * @param interestRateStrategyAddress The address of the interest rate strategy for the reserve
-   */
-  event ReserveInitialized(
-    address indexed asset,
-    address indexed aToken,
-    address stableDebtToken,
-    address variableDebtToken,
-    address interestRateStrategyAddress
-  );
-
-  /**
-   * @dev Emitted when borrowing is enabled or disabled on a reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param enabled True if borrowing is enabled, false otherwise
-   */
-  event ReserveBorrowing(address indexed asset, bool enabled);
-
-  /**
-   * @dev Emitted when flashloans are enabled or disabled on a reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param enabled True if flashloans are enabled, false otherwise
-   */
-  event ReserveFlashLoaning(address indexed asset, bool enabled);
-
-  /**
-   * @dev Emitted when the collateralization risk parameters for the specified asset are updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param ltv The loan to value of the asset when used as collateral
-   * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
-   * @param liquidationBonus The bonus liquidators receive to liquidate this asset
-   */
-  event CollateralConfigurationChanged(
-    address indexed asset,
-    uint256 ltv,
-    uint256 liquidationThreshold,
-    uint256 liquidationBonus
-  );
-
-  /**
-   * @dev Emitted when stable rate borrowing is enabled or disabled on a reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @param enabled True if stable rate borrowing is enabled, false otherwise
-   */
-  event ReserveStableRateBorrowing(address indexed asset, bool enabled);
-
-  /**
-   * @dev Emitted when a reserve is activated or deactivated
-   * @param asset The address of the underlying asset of the reserve
-   * @param active True if reserve is active, false otherwise
-   */
-  event ReserveActive(address indexed asset, bool active);
-
-  /**
-   * @dev Emitted when a reserve is frozen or unfrozen
-   * @param asset The address of the underlying asset of the reserve
-   * @param frozen True if reserve is frozen, false otherwise
-   */
-  event ReserveFrozen(address indexed asset, bool frozen);
-
-  /**
-   * @dev Emitted when a reserve is paused or unpaused
-   * @param asset The address of the underlying asset of the reserve
-   * @param paused True if reserve is paused, false otherwise
-   */
-  event ReservePaused(address indexed asset, bool paused);
-
-  /**
-   * @dev Emitted when a reserve is dropped.
-   * @param asset The address of the underlying asset of the reserve
-   */
-  event ReserveDropped(address indexed asset);
-
-  /**
-   * @dev Emitted when a reserve factor is updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldReserveFactor The old reserve factor, expressed in bps
-   * @param newReserveFactor The new reserve factor, expressed in bps
-   */
-  event ReserveFactorChanged(
-    address indexed asset,
-    uint256 oldReserveFactor,
-    uint256 newReserveFactor
-  );
-
-  /**
-   * @dev Emitted when the borrow cap of a reserve is updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldBorrowCap The old borrow cap
-   * @param newBorrowCap The new borrow cap
-   */
-  event BorrowCapChanged(address indexed asset, uint256 oldBorrowCap, uint256 newBorrowCap);
-
-  /**
-   * @dev Emitted when the supply cap of a reserve is updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldSupplyCap The old supply cap
-   * @param newSupplyCap The new supply cap
-   */
-  event SupplyCapChanged(address indexed asset, uint256 oldSupplyCap, uint256 newSupplyCap);
-
-  /**
-   * @dev Emitted when the liquidation protocol fee of a reserve is updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldFee The old liquidation protocol fee, expressed in bps
-   * @param newFee The new liquidation protocol fee, expressed in bps
-   */
-  event LiquidationProtocolFeeChanged(address indexed asset, uint256 oldFee, uint256 newFee);
-
-  /**
-   * @dev Emitted when the unbacked mint cap of a reserve is updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldUnbackedMintCap The old unbacked mint cap
-   * @param newUnbackedMintCap The new unbacked mint cap
-   */
-  event UnbackedMintCapChanged(
-    address indexed asset,
-    uint256 oldUnbackedMintCap,
-    uint256 newUnbackedMintCap
-  );
-
-  /**
-   * @dev Emitted when the category of an asset in eMode is changed.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldCategoryId The old eMode asset category
-   * @param newCategoryId The new eMode asset category
-   */
-  event EModeAssetCategoryChanged(address indexed asset, uint8 oldCategoryId, uint8 newCategoryId);
-
-  /**
-   * @dev Emitted when a new eMode category is added.
-   * @param categoryId The new eMode category id
-   * @param ltv The ltv for the asset category in eMode
-   * @param liquidationThreshold The liquidationThreshold for the asset category in eMode
-   * @param liquidationBonus The liquidationBonus for the asset category in eMode
-   * @param oracle The optional address of the price oracle specific for this category
-   * @param label A human readable identifier for the category
-   */
-  event EModeCategoryAdded(
-    uint8 indexed categoryId,
-    uint256 ltv,
-    uint256 liquidationThreshold,
-    uint256 liquidationBonus,
-    address oracle,
-    string label
-  );
-
-  /**
-   * @dev Emitted when a reserve interest strategy contract is updated.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldStrategy The address of the old interest strategy contract
-   * @param newStrategy The address of the new interest strategy contract
-   */
-  event ReserveInterestRateStrategyChanged(
-    address indexed asset,
-    address oldStrategy,
-    address newStrategy
-  );
-
-  /**
-   * @dev Emitted when an aToken implementation is upgraded.
-   * @param asset The address of the underlying asset of the reserve
-   * @param proxy The aToken proxy address
-   * @param implementation The new aToken implementation
-   */
-  event ATokenUpgraded(
-    address indexed asset,
-    address indexed proxy,
-    address indexed implementation
-  );
-
-  /**
-   * @dev Emitted when the implementation of a stable debt token is upgraded.
-   * @param asset The address of the underlying asset of the reserve
-   * @param proxy The stable debt token proxy address
-   * @param implementation The new aToken implementation
-   */
-  event StableDebtTokenUpgraded(
-    address indexed asset,
-    address indexed proxy,
-    address indexed implementation
-  );
-
-  /**
-   * @dev Emitted when the implementation of a variable debt token is upgraded.
-   * @param asset The address of the underlying asset of the reserve
-   * @param proxy The variable debt token proxy address
-   * @param implementation The new aToken implementation
-   */
-  event VariableDebtTokenUpgraded(
-    address indexed asset,
-    address indexed proxy,
-    address indexed implementation
-  );
-
-  /**
-   * @dev Emitted when the debt ceiling of an asset is set.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldDebtCeiling The old debt ceiling
-   * @param newDebtCeiling The new debt ceiling
-   */
-  event DebtCeilingChanged(address indexed asset, uint256 oldDebtCeiling, uint256 newDebtCeiling);
-
-  /**
-   * @dev Emitted when the the siloed borrowing state for an asset is changed.
-   * @param asset The address of the underlying asset of the reserve
-   * @param oldState The old siloed borrowing state
-   * @param newState The new siloed borrowing state
-   */
-  event SiloedBorrowingChanged(address indexed asset, bool oldState, bool newState);
-
-  /**
-   * @dev Emitted when the bridge protocol fee is updated.
-   * @param oldBridgeProtocolFee The old protocol fee, expressed in bps
-   * @param newBridgeProtocolFee The new protocol fee, expressed in bps
-   */
-  event BridgeProtocolFeeUpdated(uint256 oldBridgeProtocolFee, uint256 newBridgeProtocolFee);
-
-  /**
-   * @dev Emitted when the total premium on flashloans is updated.
-   * @param oldFlashloanPremiumTotal The old premium, expressed in bps
-   * @param newFlashloanPremiumTotal The new premium, expressed in bps
-   */
-  event FlashloanPremiumTotalUpdated(
-    uint128 oldFlashloanPremiumTotal,
-    uint128 newFlashloanPremiumTotal
-  );
-
-  /**
-   * @dev Emitted when the part of the premium that goes to protocol is updated.
-   * @param oldFlashloanPremiumToProtocol The old premium, expressed in bps
-   * @param newFlashloanPremiumToProtocol The new premium, expressed in bps
-   */
-  event FlashloanPremiumToProtocolUpdated(
-    uint128 oldFlashloanPremiumToProtocol,
-    uint128 newFlashloanPremiumToProtocol
-  );
-
-  /**
-   * @dev Emitted when the reserve is set as borrowable/non borrowable in isolation mode.
-   * @param asset The address of the underlying asset of the reserve
-   * @param borrowable True if the reserve is borrowable in isolation, false otherwise
-   */
-  event BorrowableInIsolationChanged(address asset, bool borrowable);
-
-  /**
-   * @notice Initializes multiple reserves.
-   * @param input The array of initialization parameters
-   */
-  function initReserves(ConfiguratorInputTypes.InitReserveInput[] calldata input) external;
-
-  /**
-   * @dev Updates the aToken implementation for the reserve.
-   * @param input The aToken update parameters
-   */
-  function updateAToken(ConfiguratorInputTypes.UpdateATokenInput calldata input) external;
-
-  /**
-   * @notice Updates the stable debt token implementation for the reserve.
-   * @param input The stableDebtToken update parameters
-   */
-  function updateStableDebtToken(
-    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) external;
-
-  /**
-   * @notice Updates the variable debt token implementation for the asset.
-   * @param input The variableDebtToken update parameters
-   */
-  function updateVariableDebtToken(
-    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) external;
-
-  /**
-   * @notice Configures borrowing on a reserve.
-   * @dev Can only be disabled (set to false) if stable borrowing is disabled
-   * @param asset The address of the underlying asset of the reserve
-   * @param enabled True if borrowing needs to be enabled, false otherwise
-   */
-  function setReserveBorrowing(address asset, bool enabled) external;
-
-  /**
-   * @notice Configures the reserve collateralization parameters.
-   * @dev All the values are expressed in bps. A value of 10000, results in 100.00%
-   * @dev The `liquidationBonus` is always above 100%. A value of 105% means the liquidator will receive a 5% bonus
-   * @param asset The address of the underlying asset of the reserve
-   * @param ltv The loan to value of the asset when used as collateral
-   * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
-   * @param liquidationBonus The bonus liquidators receive to liquidate this asset
-   */
-  function configureReserveAsCollateral(
-    address asset,
-    uint256 ltv,
-    uint256 liquidationThreshold,
-    uint256 liquidationBonus
-  ) external;
-
-  /**
-   * @notice Enable or disable stable rate borrowing on a reserve.
-   * @dev Can only be enabled (set to true) if borrowing is enabled
-   * @param asset The address of the underlying asset of the reserve
-   * @param enabled True if stable rate borrowing needs to be enabled, false otherwise
-   */
-  function setReserveStableRateBorrowing(address asset, bool enabled) external;
-
-  /**
-   * @notice Enable or disable flashloans on a reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @param enabled True if flashloans need to be enabled, false otherwise
-   */
-  function setReserveFlashLoaning(address asset, bool enabled) external;
-
-  /**
-   * @notice Activate or deactivate a reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @param active True if the reserve needs to be active, false otherwise
-   */
-  function setReserveActive(address asset, bool active) external;
-
-  /**
-   * @notice Freeze or unfreeze a reserve. A frozen reserve doesn't allow any new supply, borrow
-   * or rate swap but allows repayments, liquidations, rate rebalances and withdrawals.
-   * @param asset The address of the underlying asset of the reserve
-   * @param freeze True if the reserve needs to be frozen, false otherwise
-   */
-  function setReserveFreeze(address asset, bool freeze) external;
-
-  /**
-   * @notice Sets the borrowable in isolation flag for the reserve.
-   * @dev When this flag is set to true, the asset will be borrowable against isolated collaterals and the
-   * borrowed amount will be accumulated in the isolated collateral's total debt exposure
-   * @dev Only assets of the same family (e.g. USD stablecoins) should be borrowable in isolation mode to keep
-   * consistency in the debt ceiling calculations
-   * @param asset The address of the underlying asset of the reserve
-   * @param borrowable True if the asset should be borrowable in isolation, false otherwise
-   */
-  function setBorrowableInIsolation(address asset, bool borrowable) external;
-
-  /**
-   * @notice Pauses a reserve. A paused reserve does not allow any interaction (supply, borrow, repay,
-   * swap interest rate, liquidate, atoken transfers).
-   * @param asset The address of the underlying asset of the reserve
-   * @param paused True if pausing the reserve, false if unpausing
-   */
-  function setReservePause(address asset, bool paused) external;
-
-  /**
-   * @notice Updates the reserve factor of a reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newReserveFactor The new reserve factor of the reserve
-   */
-  function setReserveFactor(address asset, uint256 newReserveFactor) external;
-
-  /**
-   * @notice Sets the interest rate strategy of a reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newRateStrategyAddress The address of the new interest strategy contract
-   */
-  function setReserveInterestRateStrategyAddress(
-    address asset,
-    address newRateStrategyAddress
-  ) external;
-
-  /**
-   * @notice Pauses or unpauses all the protocol reserves. In the paused state all the protocol interactions
-   * are suspended.
-   * @param paused True if protocol needs to be paused, false otherwise
-   */
-  function setPoolPause(bool paused) external;
-
-  /**
-   * @notice Updates the borrow cap of a reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newBorrowCap The new borrow cap of the reserve
-   */
-  function setBorrowCap(address asset, uint256 newBorrowCap) external;
-
-  /**
-   * @notice Updates the supply cap of a reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newSupplyCap The new supply cap of the reserve
-   */
-  function setSupplyCap(address asset, uint256 newSupplyCap) external;
-
-  /**
-   * @notice Updates the liquidation protocol fee of reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newFee The new liquidation protocol fee of the reserve, expressed in bps
-   */
-  function setLiquidationProtocolFee(address asset, uint256 newFee) external;
-
-  /**
-   * @notice Updates the unbacked mint cap of reserve.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newUnbackedMintCap The new unbacked mint cap of the reserve
-   */
-  function setUnbackedMintCap(address asset, uint256 newUnbackedMintCap) external;
-
-  /**
-   * @notice Assign an efficiency mode (eMode) category to asset.
-   * @param asset The address of the underlying asset of the reserve
-   * @param newCategoryId The new category id of the asset
-   */
-  function setAssetEModeCategory(address asset, uint8 newCategoryId) external;
-
-  /**
-   * @notice Adds a new efficiency mode (eMode) category.
-   * @dev If zero is provided as oracle address, the default asset oracles will be used to compute the overall debt and
-   * overcollateralization of the users using this category.
-   * @dev The new ltv and liquidation threshold must be greater than the base
-   * ltvs and liquidation thresholds of all assets within the eMode category
-   * @param categoryId The id of the category to be configured
-   * @param ltv The ltv associated with the category
-   * @param liquidationThreshold The liquidation threshold associated with the category
-   * @param liquidationBonus The liquidation bonus associated with the category
-   * @param oracle The oracle associated with the category
-   * @param label A label identifying the category
-   */
-  function setEModeCategory(
-    uint8 categoryId,
-    uint16 ltv,
-    uint16 liquidationThreshold,
-    uint16 liquidationBonus,
-    address oracle,
-    string calldata label
-  ) external;
-
-  /**
-   * @notice Drops a reserve entirely.
-   * @param asset The address of the reserve to drop
-   */
-  function dropReserve(address asset) external;
-
-  /**
-   * @notice Updates the bridge fee collected by the protocol reserves.
-   * @param newBridgeProtocolFee The part of the fee sent to the protocol treasury, expressed in bps
-   */
-  function updateBridgeProtocolFee(uint256 newBridgeProtocolFee) external;
-
-  /**
-   * @notice Updates the total flash loan premium.
-   * Total flash loan premium consists of two parts:
-   * - A part is sent to aToken holders as extra balance
-   * - A part is collected by the protocol reserves
-   * @dev Expressed in bps
-   * @dev The premium is calculated on the total amount borrowed
-   * @param newFlashloanPremiumTotal The total flashloan premium
-   */
-  function updateFlashloanPremiumTotal(uint128 newFlashloanPremiumTotal) external;
-
-  /**
-   * @notice Updates the flash loan premium collected by protocol reserves
-   * @dev Expressed in bps
-   * @dev The premium to protocol is calculated on the total flashloan premium
-   * @param newFlashloanPremiumToProtocol The part of the flashloan premium sent to the protocol treasury
-   */
-  function updateFlashloanPremiumToProtocol(uint128 newFlashloanPremiumToProtocol) external;
-
-  /**
-   * @notice Sets the debt ceiling for an asset.
-   * @param newDebtCeiling The new debt ceiling
-   */
-  function setDebtCeiling(address asset, uint256 newDebtCeiling) external;
-
-  /**
-   * @notice Sets siloed borrowing for an asset
-   * @param siloed The new siloed borrowing state
-   */
-  function setSiloedBorrowing(address asset, bool siloed) external;
-}
-
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolDataProvider.sol
 
 /**
  * @title IPoolDataProvider
@@ -1824,9 +1647,51 @@ interface IPoolDataProvider {
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
+}
+
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
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
 
 /**
  * @title BaseUpgradeabilityProxy
@@ -1889,7 +1754,7 @@ contract BaseUpgradeabilityProxy is Proxy {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPool.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPool.sol
 
 /**
  * @title IPool
@@ -2267,6 +2132,14 @@ interface IPool {
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
@@ -2308,7 +2181,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -2335,7 +2208,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -2411,6 +2284,22 @@ interface IPool {
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
@@ -2466,7 +2355,23 @@ interface IPool {
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
@@ -2494,6 +2399,13 @@ interface IPool {
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
@@ -2564,6 +2476,22 @@ interface IPool {
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
@@ -2621,9 +2549,44 @@ interface IPool {
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
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
 
 /**
  * @title ReserveConfiguration library
@@ -2650,6 +2613,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_MASK =            0xFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant UNBACKED_MINT_CAP_MASK =         0xFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant DEBT_CEILING_MASK =              0xF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant VIRTUAL_ACC_ACTIVE =             0xEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
 
   /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
   uint256 internal constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
@@ -2670,6 +2634,7 @@ library ReserveConfiguration {
   uint256 internal constant EMODE_CATEGORY_START_BIT_POSITION = 168;
   uint256 internal constant UNBACKED_MINT_CAP_START_BIT_POSITION = 176;
   uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;
+  uint256 internal constant VIRTUAL_ACC_START_BIT_POSITION = 252;
 
   uint256 internal constant MAX_VALID_LTV = 65535;
   uint256 internal constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
@@ -3165,6 +3130,31 @@ library ReserveConfiguration {
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
@@ -3231,7 +3221,7 @@ library ReserveConfiguration {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
 
 /**
  * @title InitializableUpgradeabilityProxy
@@ -3258,7 +3248,175 @@ contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IDefaultInterestRateStrategyV2.sol
+
+/**
+ * @title IDefaultInterestRateStrategyV2
+ * @author BGD Labs
+ * @notice Interface of the default interest rate strategy used by the Aave protocol
+ */
+interface IDefaultInterestRateStrategyV2 is IReserveInterestRateStrategy {
+  struct CalcInterestRatesLocalVars {
+    uint256 availableLiquidity;
+    uint256 totalDebt;
+    uint256 currentVariableBorrowRate;
+    uint256 currentLiquidityRate;
+    uint256 borrowUsageRatio;
+    uint256 supplyUsageRatio;
+    uint256 availableLiquidityPlusDebt;
+  }
+
+  /**
+   * @notice Holds the interest rate data for a given reserve
+   *
+   * @dev Since values are in bps, they are multiplied by 1e23 in order to become rays with 27 decimals. This
+   * in turn means that the maximum supported interest rate is 4294967295 (2**32-1) bps or 42949672.95%.
+   *
+   * @param optimalUsageRatio The optimal usage ratio, in bps
+   * @param baseVariableBorrowRate The base variable borrow rate, in bps
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio, in bps
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio, in bps
+   */
+  struct InterestRateData {
+    uint16 optimalUsageRatio;
+    uint32 baseVariableBorrowRate;
+    uint32 variableRateSlope1;
+    uint32 variableRateSlope2;
+  }
+
+  /**
+   * @notice The interest rate data, where all values are in ray (fixed-point 27 decimal numbers) for a given reserve,
+   * used in in-memory calculations.
+   *
+   * @param optimalUsageRatio The optimal usage ratio
+   * @param baseVariableBorrowRate The base variable borrow rate
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio
+   */
+  struct InterestRateDataRay {
+    uint256 optimalUsageRatio;
+    uint256 baseVariableBorrowRate;
+    uint256 variableRateSlope1;
+    uint256 variableRateSlope2;
+  }
+
+  /**
+   * @notice emitted when new interest rate data is set in a reserve
+   *
+   * @param reserve address of the reserve that has new interest rate data set
+   * @param optimalUsageRatio The optimal usage ratio, in bps
+   * @param baseVariableBorrowRate The base variable borrow rate, in bps
+   * @param variableRateSlope1 The slope of the variable interest curve, before hitting the optimal ratio, in bps
+   * @param variableRateSlope2 The slope of the variable interest curve, after hitting the optimal ratio, in bps
+   */
+  event RateDataUpdate(
+    address indexed reserve,
+    uint256 optimalUsageRatio,
+    uint256 baseVariableBorrowRate,
+    uint256 variableRateSlope1,
+    uint256 variableRateSlope2
+  );
+
+  /**
+   * @notice Returns the address of the PoolAddressesProvider
+   * @return The address of the PoolAddressesProvider contract
+   */
+  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
+
+  /**
+   * @notice Returns the maximum value achievable for variable borrow rate, in bps
+   * @return The maximum rate
+   */
+  function MAX_BORROW_RATE() external view returns (uint256);
+
+  /**
+   * @notice Returns the minimum optimal point, in bps
+   * @return The optimal point
+   */
+  function MIN_OPTIMAL_POINT() external view returns (uint256);
+
+  /**
+   * @notice Returns the maximum optimal point, in bps
+   * @return The optimal point
+   */
+  function MAX_OPTIMAL_POINT() external view returns (uint256);
+
+  /**
+   * notice Returns the full InterestRateData object for the given reserve, in ray
+   *
+   * @param reserve The reserve to get the data of
+   *
+   * @return The InterestRateDataRay object for the given reserve
+   */
+  function getInterestRateData(address reserve) external view returns (InterestRateDataRay memory);
+
+  /**
+   * notice Returns the full InterestRateDataRay object for the given reserve, in bps
+   *
+   * @param reserve The reserve to get the data of
+   *
+   * @return The InterestRateData object for the given reserve
+   */
+  function getInterestRateDataBps(address reserve) external view returns (InterestRateData memory);
+
+  /**
+   * @notice Returns the optimal usage rate for the given reserve in ray
+   *
+   * @param reserve The reserve to get the optimal usage rate of
+   *
+   * @return The optimal usage rate is the level of borrow / collateral at which the borrow rate
+   */
+  function getOptimalUsageRatio(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the variable rate slope below optimal usage ratio in ray
+   * @dev It's the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
+   *
+   * @param reserve The reserve to get the variable rate slope 1 of
+   *
+   * @return The variable rate slope
+   */
+  function getVariableRateSlope1(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the variable rate slope above optimal usage ratio in ray
+   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
+   *
+   * @param reserve The reserve to get the variable rate slope 2 of
+   *
+   * @return The variable rate slope
+   */
+  function getVariableRateSlope2(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the base variable borrow rate, in ray
+   *
+   * @param reserve The reserve to get the base variable borrow rate of
+   *
+   * @return The base variable borrow rate
+   */
+  function getBaseVariableBorrowRate(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Returns the maximum variable borrow rate, in ray
+   *
+   * @param reserve The reserve to get the maximum variable borrow rate of
+   *
+   * @return The maximum variable borrow rate
+   */
+  function getMaxVariableBorrowRate(address reserve) external view returns (uint256);
+
+  /**
+   * @notice Sets interest rate data for an Aave rate strategy
+   * @param reserve The reserve to update
+   * @param rateData The reserve interest rate data to apply to the given reserve
+   *   Being specific to this custom implementation, with custom struct type,
+   *   overloading the function on the generic interface
+   */
+  function setInterestRateParams(address reserve, InterestRateData calldata rateData) external;
+}
+
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
 
 /**
  * @title BaseImmutableAdminUpgradeabilityProxy
@@ -3275,10 +3433,10 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
 
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
@@ -3341,7 +3499,7 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableAToken.sol
 
 /**
  * @title IInitializableAToken
@@ -3394,7 +3552,7 @@ interface IInitializableAToken {
   ) external;
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IInitializableDebtToken.sol
 
 /**
  * @title IInitializableDebtToken
@@ -3443,7 +3601,570 @@ interface IInitializableDebtToken {
   ) external;
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol
+// lib/aave-v3-origin/src/core/contracts/interfaces/IPoolConfigurator.sol
+
+/**
+ * @title IPoolConfigurator
+ * @author Aave
+ * @notice Defines the basic interface for a Pool configurator.
+ */
+interface IPoolConfigurator {
+  /**
+   * @dev Emitted when a reserve is initialized.
+   * @param asset The address of the underlying asset of the reserve
+   * @param aToken The address of the associated aToken contract
+   * @param stableDebtToken The address of the associated stable rate debt token
+   * @param variableDebtToken The address of the associated variable rate debt token
+   * @param interestRateStrategyAddress The address of the interest rate strategy for the reserve
+   */
+  event ReserveInitialized(
+    address indexed asset,
+    address indexed aToken,
+    address stableDebtToken,
+    address variableDebtToken,
+    address interestRateStrategyAddress
+  );
+
+  /**
+   * @dev Emitted when borrowing is enabled or disabled on a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if borrowing is enabled, false otherwise
+   */
+  event ReserveBorrowing(address indexed asset, bool enabled);
+
+  /**
+   * @dev Emitted when flashloans are enabled or disabled on a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if flashloans are enabled, false otherwise
+   */
+  event ReserveFlashLoaning(address indexed asset, bool enabled);
+
+  /**
+   * @dev Emitted when the ltv is set for the frozen asset.
+   * @param asset The address of the underlying asset of the reserve
+   * @param ltv The loan to value of the asset when used as collateral
+   */
+  event PendingLtvChanged(address indexed asset, uint256 ltv);
+
+  /**
+   * @dev Emitted when the asset is unfrozen and pending ltv is removed.
+   * @param asset The address of the underlying asset of the reserve
+   */
+  event PendingLtvRemoved(address indexed asset);
+
+  /**
+   * @dev Emitted when the collateralization risk parameters for the specified asset are updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param ltv The loan to value of the asset when used as collateral
+   * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
+   * @param liquidationBonus The bonus liquidators receive to liquidate this asset
+   */
+  event CollateralConfigurationChanged(
+    address indexed asset,
+    uint256 ltv,
+    uint256 liquidationThreshold,
+    uint256 liquidationBonus
+  );
+
+  /**
+   * @dev Emitted when stable rate borrowing is enabled or disabled on a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if stable rate borrowing is enabled, false otherwise
+   */
+  event ReserveStableRateBorrowing(address indexed asset, bool enabled);
+
+  /**
+   * @dev Emitted when a reserve is activated or deactivated
+   * @param asset The address of the underlying asset of the reserve
+   * @param active True if reserve is active, false otherwise
+   */
+  event ReserveActive(address indexed asset, bool active);
+
+  /**
+   * @dev Emitted when a reserve is frozen or unfrozen
+   * @param asset The address of the underlying asset of the reserve
+   * @param frozen True if reserve is frozen, false otherwise
+   */
+  event ReserveFrozen(address indexed asset, bool frozen);
+
+  /**
+   * @dev Emitted when a reserve is paused or unpaused
+   * @param asset The address of the underlying asset of the reserve
+   * @param paused True if reserve is paused, false otherwise
+   */
+  event ReservePaused(address indexed asset, bool paused);
+
+  /**
+   * @dev Emitted when a reserve is dropped.
+   * @param asset The address of the underlying asset of the reserve
+   */
+  event ReserveDropped(address indexed asset);
+
+  /**
+   * @dev Emitted when a reserve factor is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldReserveFactor The old reserve factor, expressed in bps
+   * @param newReserveFactor The new reserve factor, expressed in bps
+   */
+  event ReserveFactorChanged(
+    address indexed asset,
+    uint256 oldReserveFactor,
+    uint256 newReserveFactor
+  );
+
+  /**
+   * @dev Emitted when the borrow cap of a reserve is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldBorrowCap The old borrow cap
+   * @param newBorrowCap The new borrow cap
+   */
+  event BorrowCapChanged(address indexed asset, uint256 oldBorrowCap, uint256 newBorrowCap);
+
+  /**
+   * @dev Emitted when the supply cap of a reserve is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldSupplyCap The old supply cap
+   * @param newSupplyCap The new supply cap
+   */
+  event SupplyCapChanged(address indexed asset, uint256 oldSupplyCap, uint256 newSupplyCap);
+
+  /**
+   * @dev Emitted when the liquidation protocol fee of a reserve is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldFee The old liquidation protocol fee, expressed in bps
+   * @param newFee The new liquidation protocol fee, expressed in bps
+   */
+  event LiquidationProtocolFeeChanged(address indexed asset, uint256 oldFee, uint256 newFee);
+
+  /**
+   * @dev Emitted when the liquidation grace period is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param gracePeriodUntil Timestamp until when liquidations will not be allowed post-unpause
+   */
+  event LiquidationGracePeriodChanged(address indexed asset, uint40 gracePeriodUntil);
+
+  /**
+   * @dev Emitted when the unbacked mint cap of a reserve is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldUnbackedMintCap The old unbacked mint cap
+   * @param newUnbackedMintCap The new unbacked mint cap
+   */
+  event UnbackedMintCapChanged(
+    address indexed asset,
+    uint256 oldUnbackedMintCap,
+    uint256 newUnbackedMintCap
+  );
+
+  /**
+   * @dev Emitted when the category of an asset in eMode is changed.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldCategoryId The old eMode asset category
+   * @param newCategoryId The new eMode asset category
+   */
+  event EModeAssetCategoryChanged(address indexed asset, uint8 oldCategoryId, uint8 newCategoryId);
+
+  /**
+   * @dev Emitted when a new eMode category is added.
+   * @param categoryId The new eMode category id
+   * @param ltv The ltv for the asset category in eMode
+   * @param liquidationThreshold The liquidationThreshold for the asset category in eMode
+   * @param liquidationBonus The liquidationBonus for the asset category in eMode
+   * @param oracle The optional address of the price oracle specific for this category
+   * @param label A human readable identifier for the category
+   */
+  event EModeCategoryAdded(
+    uint8 indexed categoryId,
+    uint256 ltv,
+    uint256 liquidationThreshold,
+    uint256 liquidationBonus,
+    address oracle,
+    string label
+  );
+
+  /**
+   * @dev Emitted when a reserve interest strategy contract is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldStrategy The address of the old interest strategy contract
+   * @param newStrategy The address of the new interest strategy contract
+   */
+  event ReserveInterestRateStrategyChanged(
+    address indexed asset,
+    address oldStrategy,
+    address newStrategy
+  );
+
+  /**
+   * @dev Emitted when the data of a reserve interest strategy contract is updated.
+   * @param asset The address of the underlying asset of the reserve
+   * @param data abi encoded data
+   */
+  event ReserveInterestRateDataChanged(address indexed asset, address indexed strategy, bytes data);
+
+  /**
+   * @dev Emitted when an aToken implementation is upgraded.
+   * @param asset The address of the underlying asset of the reserve
+   * @param proxy The aToken proxy address
+   * @param implementation The new aToken implementation
+   */
+  event ATokenUpgraded(
+    address indexed asset,
+    address indexed proxy,
+    address indexed implementation
+  );
+
+  /**
+   * @dev Emitted when the implementation of a stable debt token is upgraded.
+   * @param asset The address of the underlying asset of the reserve
+   * @param proxy The stable debt token proxy address
+   * @param implementation The new aToken implementation
+   */
+  event StableDebtTokenUpgraded(
+    address indexed asset,
+    address indexed proxy,
+    address indexed implementation
+  );
+
+  /**
+   * @dev Emitted when the implementation of a variable debt token is upgraded.
+   * @param asset The address of the underlying asset of the reserve
+   * @param proxy The variable debt token proxy address
+   * @param implementation The new aToken implementation
+   */
+  event VariableDebtTokenUpgraded(
+    address indexed asset,
+    address indexed proxy,
+    address indexed implementation
+  );
+
+  /**
+   * @dev Emitted when the debt ceiling of an asset is set.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldDebtCeiling The old debt ceiling
+   * @param newDebtCeiling The new debt ceiling
+   */
+  event DebtCeilingChanged(address indexed asset, uint256 oldDebtCeiling, uint256 newDebtCeiling);
+
+  /**
+   * @dev Emitted when the the siloed borrowing state for an asset is changed.
+   * @param asset The address of the underlying asset of the reserve
+   * @param oldState The old siloed borrowing state
+   * @param newState The new siloed borrowing state
+   */
+  event SiloedBorrowingChanged(address indexed asset, bool oldState, bool newState);
+
+  /**
+   * @dev Emitted when the bridge protocol fee is updated.
+   * @param oldBridgeProtocolFee The old protocol fee, expressed in bps
+   * @param newBridgeProtocolFee The new protocol fee, expressed in bps
+   */
+  event BridgeProtocolFeeUpdated(uint256 oldBridgeProtocolFee, uint256 newBridgeProtocolFee);
+
+  /**
+   * @dev Emitted when the total premium on flashloans is updated.
+   * @param oldFlashloanPremiumTotal The old premium, expressed in bps
+   * @param newFlashloanPremiumTotal The new premium, expressed in bps
+   */
+  event FlashloanPremiumTotalUpdated(
+    uint128 oldFlashloanPremiumTotal,
+    uint128 newFlashloanPremiumTotal
+  );
+
+  /**
+   * @dev Emitted when the part of the premium that goes to protocol is updated.
+   * @param oldFlashloanPremiumToProtocol The old premium, expressed in bps
+   * @param newFlashloanPremiumToProtocol The new premium, expressed in bps
+   */
+  event FlashloanPremiumToProtocolUpdated(
+    uint128 oldFlashloanPremiumToProtocol,
+    uint128 newFlashloanPremiumToProtocol
+  );
+
+  /**
+   * @dev Emitted when the reserve is set as borrowable/non borrowable in isolation mode.
+   * @param asset The address of the underlying asset of the reserve
+   * @param borrowable True if the reserve is borrowable in isolation, false otherwise
+   */
+  event BorrowableInIsolationChanged(address asset, bool borrowable);
+
+  /**
+   * @notice Initializes multiple reserves.
+   * @param input The array of initialization parameters
+   */
+  function initReserves(ConfiguratorInputTypes.InitReserveInput[] calldata input) external;
+
+  /**
+   * @dev Updates the aToken implementation for the reserve.
+   * @param input The aToken update parameters
+   */
+  function updateAToken(ConfiguratorInputTypes.UpdateATokenInput calldata input) external;
+
+  /**
+   * @notice Updates the stable debt token implementation for the reserve.
+   * @param input The stableDebtToken update parameters
+   */
+  function updateStableDebtToken(
+    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
+  ) external;
+
+  /**
+   * @notice Updates the variable debt token implementation for the asset.
+   * @param input The variableDebtToken update parameters
+   */
+  function updateVariableDebtToken(
+    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
+  ) external;
+
+  /**
+   * @notice Configures borrowing on a reserve.
+   * @dev Can only be disabled (set to false) if stable borrowing is disabled
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if borrowing needs to be enabled, false otherwise
+   */
+  function setReserveBorrowing(address asset, bool enabled) external;
+
+  /**
+   * @notice Configures the reserve collateralization parameters.
+   * @dev All the values are expressed in bps. A value of 10000, results in 100.00%
+   * @dev The `liquidationBonus` is always above 100%. A value of 105% means the liquidator will receive a 5% bonus
+   * @param asset The address of the underlying asset of the reserve
+   * @param ltv The loan to value of the asset when used as collateral
+   * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
+   * @param liquidationBonus The bonus liquidators receive to liquidate this asset
+   */
+  function configureReserveAsCollateral(
+    address asset,
+    uint256 ltv,
+    uint256 liquidationThreshold,
+    uint256 liquidationBonus
+  ) external;
+
+  /**
+   * @notice Enable or disable stable rate borrowing on a reserve.
+   * @dev Can only be enabled (set to true) if borrowing is enabled
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if stable rate borrowing needs to be enabled, false otherwise
+   */
+  function setReserveStableRateBorrowing(address asset, bool enabled) external;
+
+  /**
+   * @notice Enable or disable flashloans on a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if flashloans need to be enabled, false otherwise
+   */
+  function setReserveFlashLoaning(address asset, bool enabled) external;
+
+  /**
+   * @notice Activate or deactivate a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @param active True if the reserve needs to be active, false otherwise
+   */
+  function setReserveActive(address asset, bool active) external;
+
+  /**
+   * @notice Freeze or unfreeze a reserve. A frozen reserve doesn't allow any new supply, borrow
+   * or rate swap but allows repayments, liquidations, rate rebalances and withdrawals.
+   * @param asset The address of the underlying asset of the reserve
+   * @param freeze True if the reserve needs to be frozen, false otherwise
+   */
+  function setReserveFreeze(address asset, bool freeze) external;
+
+  /**
+   * @notice Sets the borrowable in isolation flag for the reserve.
+   * @dev When this flag is set to true, the asset will be borrowable against isolated collaterals and the
+   * borrowed amount will be accumulated in the isolated collateral's total debt exposure
+   * @dev Only assets of the same family (e.g. USD stablecoins) should be borrowable in isolation mode to keep
+   * consistency in the debt ceiling calculations
+   * @param asset The address of the underlying asset of the reserve
+   * @param borrowable True if the asset should be borrowable in isolation, false otherwise
+   */
+  function setBorrowableInIsolation(address asset, bool borrowable) external;
+
+  /**
+   * @notice Pauses a reserve. A paused reserve does not allow any interaction (supply, borrow, repay,
+   * swap interest rate, liquidate, atoken transfers).
+   * @param asset The address of the underlying asset of the reserve
+   * @param paused True if pausing the reserve, false if unpausing
+   * @param gracePeriod Count of seconds after unpause during which liquidations will not be available
+   *   - Only applicable whenever unpausing (`paused` as false)
+   *   - Passing 0 means no grace period
+   *   - Capped to maximum MAX_GRACE_PERIOD
+   */
+  function setReservePause(address asset, bool paused, uint40 gracePeriod) external;
+
+  /**
+   * @notice Pauses a reserve. A paused reserve does not allow any interaction (supply, borrow, repay,
+   * swap interest rate, liquidate, atoken transfers).
+   * @dev Version with no grace period
+   * @param asset The address of the underlying asset of the reserve
+   * @param paused True if pausing the reserve, false if unpausing
+   */
+  function setReservePause(address asset, bool paused) external;
+
+  /**
+   * @notice Updates the reserve factor of a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newReserveFactor The new reserve factor of the reserve
+   */
+  function setReserveFactor(address asset, uint256 newReserveFactor) external;
+
+  /**
+   * @notice Sets the interest rate strategy of a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newRateStrategyAddress The address of the new interest strategy contract
+   * @param rateData bytes-encoded rate data. In this format in order to allow the rate strategy contract
+   *  to de-structure custom data
+   */
+  function setReserveInterestRateStrategyAddress(
+    address asset,
+    address newRateStrategyAddress,
+    bytes calldata rateData
+  ) external;
+
+  /**
+   * @notice Sets interest rate data for a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @param rateData bytes-encoded rate data. In this format in order to allow the rate strategy contract
+   *  to de-structure custom data
+   */
+  function setReserveInterestRateData(address asset, bytes calldata rateData) external;
+
+  /**
+   * @notice Pauses or unpauses all the protocol reserves. In the paused state all the protocol interactions
+   * are suspended.
+   * @param paused True if protocol needs to be paused, false otherwise
+   * @param gracePeriod Count of seconds after unpause during which liquidations will not be available
+   *   - Only applicable whenever unpausing (`paused` as false)
+   *   - Passing 0 means no grace period
+   *   - Capped to maximum MAX_GRACE_PERIOD
+   */
+  function setPoolPause(bool paused, uint40 gracePeriod) external;
+
+  /**
+   * @notice Pauses or unpauses all the protocol reserves. In the paused state all the protocol interactions
+   * are suspended.
+   * @dev Version with no grace period
+   * @param paused True if protocol needs to be paused, false otherwise
+   */
+  function setPoolPause(bool paused) external;
+
+  /**
+   * @notice Updates the borrow cap of a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newBorrowCap The new borrow cap of the reserve
+   */
+  function setBorrowCap(address asset, uint256 newBorrowCap) external;
+
+  /**
+   * @notice Updates the supply cap of a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newSupplyCap The new supply cap of the reserve
+   */
+  function setSupplyCap(address asset, uint256 newSupplyCap) external;
+
+  /**
+   * @notice Updates the liquidation protocol fee of reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newFee The new liquidation protocol fee of the reserve, expressed in bps
+   */
+  function setLiquidationProtocolFee(address asset, uint256 newFee) external;
+
+  /**
+   * @notice Updates the unbacked mint cap of reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newUnbackedMintCap The new unbacked mint cap of the reserve
+   */
+  function setUnbackedMintCap(address asset, uint256 newUnbackedMintCap) external;
+
+  /**
+   * @notice Assign an efficiency mode (eMode) category to asset.
+   * @param asset The address of the underlying asset of the reserve
+   * @param newCategoryId The new category id of the asset
+   */
+  function setAssetEModeCategory(address asset, uint8 newCategoryId) external;
+
+  /**
+   * @notice Adds a new efficiency mode (eMode) category.
+   * @dev If zero is provided as oracle address, the default asset oracles will be used to compute the overall debt and
+   * overcollateralization of the users using this category.
+   * @dev The new ltv and liquidation threshold must be greater than the base
+   * ltvs and liquidation thresholds of all assets within the eMode category
+   * @param categoryId The id of the category to be configured
+   * @param ltv The ltv associated with the category
+   * @param liquidationThreshold The liquidation threshold associated with the category
+   * @param liquidationBonus The liquidation bonus associated with the category
+   * @param oracle The oracle associated with the category
+   * @param label A label identifying the category
+   */
+  function setEModeCategory(
+    uint8 categoryId,
+    uint16 ltv,
+    uint16 liquidationThreshold,
+    uint16 liquidationBonus,
+    address oracle,
+    string calldata label
+  ) external;
+
+  /**
+   * @notice Drops a reserve entirely.
+   * @param asset The address of the reserve to drop
+   */
+  function dropReserve(address asset) external;
+
+  /**
+   * @notice Updates the bridge fee collected by the protocol reserves.
+   * @param newBridgeProtocolFee The part of the fee sent to the protocol treasury, expressed in bps
+   */
+  function updateBridgeProtocolFee(uint256 newBridgeProtocolFee) external;
+
+  /**
+   * @notice Updates the total flash loan premium.
+   * Total flash loan premium consists of two parts:
+   * - A part is sent to aToken holders as extra balance
+   * - A part is collected by the protocol reserves
+   * @dev Expressed in bps
+   * @dev The premium is calculated on the total amount borrowed
+   * @param newFlashloanPremiumTotal The total flashloan premium
+   */
+  function updateFlashloanPremiumTotal(uint128 newFlashloanPremiumTotal) external;
+
+  /**
+   * @notice Updates the flash loan premium collected by protocol reserves
+   * @dev Expressed in bps
+   * @dev The premium to protocol is calculated on the total flashloan premium
+   * @param newFlashloanPremiumToProtocol The part of the flashloan premium sent to the protocol treasury
+   */
+  function updateFlashloanPremiumToProtocol(uint128 newFlashloanPremiumToProtocol) external;
+
+  /**
+   * @notice Sets the debt ceiling for an asset.
+   * @param newDebtCeiling The new debt ceiling
+   */
+  function setDebtCeiling(address asset, uint256 newDebtCeiling) external;
+
+  /**
+   * @notice Sets siloed borrowing for an asset
+   * @param siloed The new siloed borrowing state
+   */
+  function setSiloedBorrowing(address asset, bool siloed) external;
+
+  /**
+   * @notice Gets pending ltv value and flag if it is set
+   * @param asset The new siloed borrowing state
+   */
+  function getPendingLtv(address asset) external returns (uint256, bool);
+
+  /**
+   * @notice Gets the address of the external ConfiguratorLogic
+   */
+  function getConfiguratorLogic() external returns (address);
+
+  /**
+   * @notice Gets the maximum liquidations grace period allowed, in seconds
+   */
+  function MAX_GRACE_PERIOD() external returns (uint40);
+}
+
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol
 
 /**
  * @title InitializableAdminUpgradeabilityProxy
@@ -3468,7 +4189,7 @@ contract InitializableImmutableAdminUpgradeabilityProxy is
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
 
 /**
  * @title ConfiguratorLogic library
@@ -3511,7 +4232,7 @@ library ConfiguratorLogic {
   function executeInitReserve(
     IPool pool,
     ConfiguratorInputTypes.InitReserveInput calldata input
-  ) public {
+  ) external {
     address aTokenProxyAddress = _initTokenWithProxy(
       input.aTokenImpl,
       abi.encodeWithSelector(
@@ -3570,9 +4291,15 @@ library ConfiguratorLogic {
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
@@ -3591,8 +4318,8 @@ library ConfiguratorLogic {
   function executeUpdateAToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateATokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);
 
     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();
 
@@ -3622,8 +4349,8 @@ library ConfiguratorLogic {
   function executeUpdateStableDebtToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);
 
     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();
 
@@ -3660,8 +4387,8 @@ library ConfiguratorLogic {
   function executeUpdateVariableDebtToken(
     IPool cachedPool,
     ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
-  ) public {
-    DataTypes.ReserveData memory reserveData = cachedPool.getReserveData(input.asset);
+  ) external {
+    DataTypes.ReserveDataLegacy memory reserveData = cachedPool.getReserveData(input.asset);
 
     (, , , uint256 decimals, , ) = cachedPool.getConfiguration(input.asset).getParams();
 
@@ -3728,20 +4455,25 @@ library ConfiguratorLogic {
   }
 }
 
-// downloads/MAINNET/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/pool/PoolConfigurator.sol
 
 /**
  * @title PoolConfigurator
  * @author Aave
  * @dev Implements the configuration methods for the Aave protocol
  */
-contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
+abstract contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   using PercentageMath for uint256;
   using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
 
   IPoolAddressesProvider internal _addressesProvider;
   IPool internal _pool;
 
+  mapping(address => uint256) internal _pendingLtv;
+  mapping(address => bool) internal _isPendingLtvSet;
+
+  uint40 public constant MAX_GRACE_PERIOD = 4 hours;
+
   /**
    * @dev Only pool admin can call functions marked by this modifier.
    */
@@ -3750,14 +4482,6 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     _;
   }
 
-  /**
-   * @dev Only emergency admin can call functions marked by this modifier.
-   */
-  modifier onlyEmergencyAdmin() {
-    _onlyEmergencyAdmin();
-    _;
-  }
-
   /**
    * @dev Only emergency or pool admin can call functions marked by this modifier.
    */
@@ -3782,17 +4506,15 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     _;
   }
 
-  uint256 public constant CONFIGURATOR_REVISION = 0x1;
-
-  /// @inheritdoc VersionedInitializable
-  function getRevision() internal pure virtual override returns (uint256) {
-    return CONFIGURATOR_REVISION;
+  /**
+   * @dev Only risk, pool or emergency admin can call functions marked by this modifier.
+   */
+  modifier onlyRiskOrPoolOrEmergencyAdmins() {
+    _onlyRiskOrPoolOrEmergencyAdmins();
+    _;
   }
 
-  function initialize(IPoolAddressesProvider provider) public initializer {
-    _addressesProvider = provider;
-    _pool = IPool(_addressesProvider.getPool());
-  }
+  function initialize(IPoolAddressesProvider provider) public virtual;
 
   /// @inheritdoc IPoolConfigurator
   function initReserves(
@@ -3800,7 +4522,14 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   ) external override onlyAssetListingOrPoolAdmins {
     IPool cachedPool = _pool;
     for (uint256 i = 0; i < input.length; i++) {
+      require(IERC20Detailed(input[i].underlyingAsset).decimals() > 5, Errors.INVALID_DECIMALS);
+
       ConfiguratorLogic.executeInitReserve(cachedPool, input[i]);
+      emit ReserveInterestRateDataChanged(
+        input[i].underlyingAsset,
+        input[i].interestRateStrategyAddress,
+        input[i].interestRateData
+      );
     }
   }
 
@@ -3875,7 +4604,15 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
       _checkNoSuppliers(asset);
     }
 
-    currentConfig.setLtv(ltv);
+    if (currentConfig.getFrozen()) {
+      _pendingLtv[asset] = ltv;
+      _isPendingLtvSet[asset] = true;
+
+      emit PendingLtvChanged(asset, ltv);
+    } else {
+      currentConfig.setLtv(ltv);
+    }
+
     currentConfig.setLiquidationThreshold(liquidationThreshold);
     currentConfig.setLiquidationBonus(liquidationBonus);
 
@@ -3920,9 +4657,29 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setReserveFreeze(address asset, bool freeze) external override onlyRiskOrPoolAdmins {
+  function setReserveFreeze(
+    address asset,
+    bool freeze
+  ) external override onlyRiskOrPoolOrEmergencyAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     currentConfig.setFrozen(freeze);
+
+    if (freeze) {
+      _pendingLtv[asset] = currentConfig.getLtv();
+      _isPendingLtvSet[asset] = true;
+      currentConfig.setLtv(0);
+
+      emit PendingLtvChanged(asset, currentConfig.getLtv());
+    } else if (_isPendingLtvSet[asset]) {
+      uint256 ltv = _pendingLtv[asset];
+      currentConfig.setLtv(ltv);
+
+      delete _pendingLtv[asset];
+      delete _isPendingLtvSet[asset];
+
+      emit PendingLtvRemoved(asset);
+    }
+
     _pool.setConfiguration(asset, currentConfig);
     emit ReserveFrozen(asset, freeze);
   }
@@ -3939,24 +4696,46 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setReservePause(address asset, bool paused) public override onlyEmergencyOrPoolAdmin {
+  function setReservePause(
+    address asset,
+    bool paused,
+    uint40 gracePeriod
+  ) public override onlyEmergencyOrPoolAdmin {
+    if (!paused && gracePeriod != 0) {
+      require(gracePeriod <= MAX_GRACE_PERIOD, Errors.INVALID_GRACE_PERIOD);
+
+      uint40 until = uint40(block.timestamp) + gracePeriod;
+      _pool.setLiquidationGracePeriod(asset, until);
+      emit LiquidationGracePeriodChanged(asset, until);
+    }
+
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     currentConfig.setPaused(paused);
     _pool.setConfiguration(asset, currentConfig);
     emit ReservePaused(asset, paused);
   }
 
+  /// @inheritdoc IPoolConfigurator
+  function setReservePause(address asset, bool paused) external override onlyEmergencyOrPoolAdmin {
+    setReservePause(asset, paused, 0);
+  }
+
   /// @inheritdoc IPoolConfigurator
   function setReserveFactor(
     address asset,
     uint256 newReserveFactor
   ) external override onlyRiskOrPoolAdmins {
     require(newReserveFactor <= PercentageMath.PERCENTAGE_FACTOR, Errors.INVALID_RESERVE_FACTOR);
+
+    _pool.syncIndexesState(asset);
+
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     uint256 oldReserveFactor = currentConfig.getReserveFactor();
     currentConfig.setReserveFactor(newReserveFactor);
     _pool.setConfiguration(asset, currentConfig);
     emit ReserveFactorChanged(asset, oldReserveFactor, newReserveFactor);
+
+    _pool.syncRatesState(asset);
   }
 
   /// @inheritdoc IPoolConfigurator
@@ -3967,7 +4746,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
 
     uint256 oldDebtCeiling = currentConfig.getDebtCeiling();
-    if (oldDebtCeiling == 0) {
+    if (currentConfig.getLiquidationThreshold() != 0 && oldDebtCeiling == 0) {
       _checkNoSuppliers(asset);
     }
     currentConfig.setDebtCeiling(newDebtCeiling);
@@ -4122,28 +4901,41 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     emit UnbackedMintCapChanged(asset, oldUnbackedMintCap, newUnbackedMintCap);
   }
 
+  /// @inheritdoc IPoolConfigurator
+  function setReserveInterestRateData(
+    address asset,
+    bytes calldata rateData
+  ) external onlyRiskOrPoolAdmins {
+    DataTypes.ReserveDataLegacy memory reserve = _pool.getReserveData(asset);
+    _updateInterestRateStrategy(asset, reserve, reserve.interestRateStrategyAddress, rateData);
+  }
+
   /// @inheritdoc IPoolConfigurator
   function setReserveInterestRateStrategyAddress(
     address asset,
-    address newRateStrategyAddress
+    address rateStrategyAddress,
+    bytes calldata rateData
   ) external override onlyRiskOrPoolAdmins {
-    DataTypes.ReserveData memory reserve = _pool.getReserveData(asset);
-    address oldRateStrategyAddress = reserve.interestRateStrategyAddress;
-    _pool.setReserveInterestRateStrategyAddress(asset, newRateStrategyAddress);
-    emit ReserveInterestRateStrategyChanged(asset, oldRateStrategyAddress, newRateStrategyAddress);
+    DataTypes.ReserveDataLegacy memory reserve = _pool.getReserveData(asset);
+    _updateInterestRateStrategy(asset, reserve, rateStrategyAddress, rateData);
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setPoolPause(bool paused) external override onlyEmergencyAdmin {
+  function setPoolPause(bool paused, uint40 gracePeriod) public override onlyEmergencyOrPoolAdmin {
     address[] memory reserves = _pool.getReservesList();
 
     for (uint256 i = 0; i < reserves.length; i++) {
       if (reserves[i] != address(0)) {
-        setReservePause(reserves[i], paused);
+        setReservePause(reserves[i], paused, gracePeriod);
       }
     }
   }
 
+  /// @inheritdoc IPoolConfigurator
+  function setPoolPause(bool paused) external override onlyEmergencyOrPoolAdmin {
+    setPoolPause(paused, 0);
+  }
+
   /// @inheritdoc IPoolConfigurator
   function updateBridgeProtocolFee(uint256 newBridgeProtocolFee) external override onlyPoolAdmin {
     require(
@@ -4184,12 +4976,50 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     );
   }
 
+  /// @inheritdoc IPoolConfigurator
+  function getPendingLtv(address asset) external view override returns (uint256, bool) {
+    return (_pendingLtv[asset], _isPendingLtvSet[asset]);
+  }
+
+  /// @inheritdoc IPoolConfigurator
+  function getConfiguratorLogic() external pure returns (address) {
+    return address(ConfiguratorLogic);
+  }
+
+  function _updateInterestRateStrategy(
+    address asset,
+    DataTypes.ReserveDataLegacy memory reserve,
+    address newRateStrategyAddress,
+    bytes calldata rateData
+  ) internal {
+    address oldRateStrategyAddress = reserve.interestRateStrategyAddress;
+
+    _pool.syncIndexesState(asset);
+
+    IDefaultInterestRateStrategyV2(newRateStrategyAddress).setInterestRateParams(asset, rateData);
+    emit ReserveInterestRateDataChanged(asset, newRateStrategyAddress, rateData);
+
+    if (oldRateStrategyAddress != newRateStrategyAddress) {
+      _pool.setReserveInterestRateStrategyAddress(asset, newRateStrategyAddress);
+      emit ReserveInterestRateStrategyChanged(
+        asset,
+        oldRateStrategyAddress,
+        newRateStrategyAddress
+      );
+    }
+
+    _pool.syncRatesState(asset);
+  }
+
   function _checkNoSuppliers(address asset) internal view {
-    (, uint256 accruedToTreasury, uint256 totalATokens, , , , , , , , , ) = IPoolDataProvider(
-      _addressesProvider.getPoolDataProvider()
-    ).getReserveData(asset);
+    DataTypes.ReserveDataLegacy memory reserveData = _pool.getReserveData(asset);
+    uint256 totalSupplied = IPoolDataProvider(_addressesProvider.getPoolDataProvider())
+      .getATokenTotalSupply(asset);
 
-    require(totalATokens == 0 && accruedToTreasury == 0, Errors.RESERVE_LIQUIDITY_NOT_ZERO);
+    require(
+      totalSupplied == 0 && reserveData.accruedToTreasury == 0,
+      Errors.RESERVE_LIQUIDITY_NOT_ZERO
+    );
   }
 
   function _checkNoBorrowers(address asset) internal view {
@@ -4204,11 +5034,6 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     require(aclManager.isPoolAdmin(msg.sender), Errors.CALLER_NOT_POOL_ADMIN);
   }
 
-  function _onlyEmergencyAdmin() internal view {
-    IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
-    require(aclManager.isEmergencyAdmin(msg.sender), Errors.CALLER_NOT_EMERGENCY_ADMIN);
-  }
-
   function _onlyPoolOrEmergencyAdmin() internal view {
     IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
     require(
@@ -4232,4 +5057,14 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
       Errors.CALLER_NOT_RISK_OR_POOL_ADMIN
     );
   }
+
+  function _onlyRiskOrPoolOrEmergencyAdmins() internal view {
+    IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
+    require(
+      aclManager.isRiskAdmin(msg.sender) ||
+        aclManager.isPoolAdmin(msg.sender) ||
+        aclManager.isEmergencyAdmin(msg.sender),
+      Errors.CALLER_NOT_RISK_OR_POOL_OR_EMERGENCY_ADMIN
+    );
+  }
 }
```
