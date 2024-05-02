```diff
diff --git a/./downloads/MAINNET/POOL_CONFIGURATOR_IMPL.sol b/./downloads/FACTORY_LOCAL/POOL_CONFIGURATOR_IMPL.sol
index b5e47e8..027ad1d 100644
--- a/./downloads/MAINNET/POOL_CONFIGURATOR_IMPL.sol
+++ b/./downloads/FACTORY_LOCAL/POOL_CONFIGURATOR_IMPL.sol

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
@@ -4232,4 +5057,30 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
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
+}
+
+// lib/aave-v3-origin/src/core/instances/PoolConfiguratorInstance.sol
+
+contract PoolConfiguratorInstance is PoolConfigurator {
+  uint256 public constant CONFIGURATOR_REVISION = 3;
+
+  /// @inheritdoc VersionedInitializable
+  function getRevision() internal pure virtual override returns (uint256) {
+    return CONFIGURATOR_REVISION;
+  }
+
+  function initialize(IPoolAddressesProvider provider) public virtual override initializer {
+    _addressesProvider = provider;
+    _pool = IPool(_addressesProvider.getPool());
+  }
 }
```
