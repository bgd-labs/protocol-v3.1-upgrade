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
