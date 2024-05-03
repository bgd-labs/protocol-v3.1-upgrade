```diff
diff --git a/./downloads/MAINNET/DEFAULT_A_TOKEN_IMPL.sol b/./downloads/FACTORY_LOCAL/DEFAULT_A_TOKEN_IMPL.sol
index 36ee10c..25aedcb 100644
--- a/./downloads/MAINNET/DEFAULT_A_TOKEN_IMPL.sol
+++ b/./downloads/FACTORY_LOCAL/DEFAULT_A_TOKEN_IMPL.sol

-// downloads/MAINNET/DEFAULT_A_TOKEN_IMPL/AToken/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/libraries/helpers/Errors.sol

 /**
  * @title Errors library
@@ -819,7 +819,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -849,9 +849,16 @@ library Errors {
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

-// downloads/MAINNET/DEFAULT_A_TOKEN_IMPL/AToken/@aave/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/base/IncentivizedERC20.sol

 /**
  * @title IncentivizedERC20
@@ -2587,15 +2737,15 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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

@@ -2756,7 +2906,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   }
 }

-// downloads/MAINNET/DEFAULT_A_TOKEN_IMPL/AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol
+// lib/aave-v3-origin/src/core/contracts/protocol/tokenization/AToken.sol

 /**
  * @title Aave ERC20 AToken
  * @author Aave
  * @notice Implementation of the interest bearing token for the Aave protocol
  */
-contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, IAToken {
+abstract contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, IAToken {
   using WadRayMath for uint256;
   using SafeCast for uint256;
   using GPv2SafeERC20 for IERC20;
@@ -2982,16 +3132,9 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');

-  uint256 public constant ATOKEN_REVISION = 0x1;
-
   address internal _treasury;
   address internal _underlyingAsset;

-  /// @inheritdoc VersionedInitializable
-  function getRevision() internal pure virtual override returns (uint256) {
-    return ATOKEN_REVISION;
-  }
-
   /**
    * @dev Constructor.
    * @param pool The address of the Pool contract
@@ -3012,29 +3155,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     string calldata aTokenName,
     string calldata aTokenSymbol,
     bytes calldata params
-  ) public virtual override initializer {
-    require(initializingPool == POOL, Errors.POOL_ADDRESSES_DO_NOT_MATCH);
-    _setName(aTokenName);
-    _setSymbol(aTokenSymbol);
-    _setDecimals(aTokenDecimals);
-
-    _treasury = treasury;
-    _underlyingAsset = underlyingAsset;
-    _incentivesController = incentivesController;
-
-    _domainSeparator = _calculateDomainSeparator();
-
-    emit Initialized(
-      underlyingAsset,
-      address(POOL),
-      treasury,
-      address(incentivesController),
-      aTokenDecimals,
-      aTokenName,
-      aTokenSymbol,
-      params
-    );
-  }
+  ) public virtual;

   /// @inheritdoc IAToken
   function mint(
@@ -3208,3 +3329,50 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     IERC20(token).safeTransfer(to, amount);
   }
 }
+
+// lib/aave-v3-origin/src/core/instances/ATokenInstance.sol
+
+contract ATokenInstance is AToken {
+  uint256 public constant ATOKEN_REVISION = 1;
+
+  constructor(IPool pool) AToken(pool) {}
+
+  /// @inheritdoc VersionedInitializable
+  function getRevision() internal pure virtual override returns (uint256) {
+    return ATOKEN_REVISION;
+  }
+
+  /// @inheritdoc IInitializableAToken
+  function initialize(
+    IPool initializingPool,
+    address treasury,
+    address underlyingAsset,
+    IAaveIncentivesController incentivesController,
+    uint8 aTokenDecimals,
+    string calldata aTokenName,
+    string calldata aTokenSymbol,
+    bytes calldata params
+  ) public virtual override initializer {
+    require(initializingPool == POOL, Errors.POOL_ADDRESSES_DO_NOT_MATCH);
+    _setName(aTokenName);
+    _setSymbol(aTokenSymbol);
+    _setDecimals(aTokenDecimals);
+
+    _treasury = treasury;
+    _underlyingAsset = underlyingAsset;
+    _incentivesController = incentivesController;
+
+    _domainSeparator = _calculateDomainSeparator();
+
+    emit Initialized(
+      underlyingAsset,
+      address(POOL),
+      treasury,
+      address(incentivesController),
+      aTokenDecimals,
+      aTokenName,
+      aTokenSymbol,
+      params
+    );
+  }
+}
```
