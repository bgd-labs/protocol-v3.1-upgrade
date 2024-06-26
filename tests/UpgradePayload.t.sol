// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ProtocolV3TestBase, IPool as IOldPool, ReserveConfig, IERC20, IERC20Metadata} from 'aave-helpers/ProtocolV3TestBase.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/core/contracts/interfaces/IPoolConfigurator.sol';
import {IPool} from 'aave-v3-origin/core/contracts/interfaces/IPool.sol';
import {Errors} from 'aave-v3-origin/core/contracts/protocol/libraries/helpers/Errors.sol';
import {IPoolDataProvider} from 'aave-v3-origin/core/contracts/interfaces/IPoolDataProvider.sol';
import {IPool} from 'aave-v3-origin/core/contracts/interfaces/IPool.sol';
import {IPriceOracleGetter} from 'aave-v3-origin/core/contracts/interfaces/IPriceOracleGetter.sol';
import {DataTypes} from 'aave-v3-origin/core/contracts/protocol/libraries/types/DataTypes.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {ReserveConfiguration} from 'aave-v3-origin/core/contracts/protocol/libraries/configuration/ReserveConfiguration.sol';

/**
 * Base test to be executed on all networks
 */
abstract contract UpgradePayloadTest is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;
  IPoolAddressesProvider internal POOL_ADDRESSES_PROVIDER;
  IPoolConfigurator internal CONFIGURATOR;
  IPoolDataProvider internal AAVE_PROTOCOL_DATA_PROVIDER;
  IPool internal POOL;
  address internal ACL_ADMIN;
  UpgradePayload internal PAYLOAD;
  uint256 internal VIRTUAL_ACCOUNTING_TO_ATOKEN_OFF_LIMIT; // 1e7 is 100%

  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

  constructor(string memory network, uint256 blocknumber, uint256 voOffLimit) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
    VIRTUAL_ACCOUNTING_TO_ATOKEN_OFF_LIMIT = voOffLimit;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
    PAYLOAD = UpgradePayload(_getPayload());
    POOL_ADDRESSES_PROVIDER = PAYLOAD.POOL_ADDRESSES_PROVIDER();
    CONFIGURATOR = PAYLOAD.CONFIGURATOR();
    POOL = IPool(POOL_ADDRESSES_PROVIDER.getPool());
    AAVE_PROTOCOL_DATA_PROVIDER = IPoolDataProvider(PAYLOAD.POOL_DATA_PROVIDER());
    ACL_ADMIN = POOL_ADDRESSES_PROVIDER.getACLAdmin();
  }

  modifier proposalExecuted() {
    _executePayload();
    _;
  }

  function _getPayload() internal virtual returns (address);

  function _executePayload() internal {
    GovV3Helpers.executePayload(vm, address(PAYLOAD));
  }

  function _adjustUser(address user) internal view {
    vm.assume(
      user != address(0) &&
        user != address(POOL_ADDRESSES_PROVIDER) &&
        user != address(CONFIGURATOR)
    );
  }

  /**
   * Creating a config diff & running our default e2e suite.
   */
  function test_default() external {
    defaultTest(vm.toString(block.chainid), IOldPool(address(POOL)), address(PAYLOAD));
  }

  /**
   * Doing the upgrade, nothing else for gas measurement of execution.
   */
  function test_upgrade() external {
    _executePayload();
  }

  function test_aave_data_provider_upgraded() external proposalExecuted {
    assertEq(POOL_ADDRESSES_PROVIDER.getPoolDataProvider(), address(AAVE_PROTOCOL_DATA_PROVIDER));
  }

  function test_virtualAccounting() external proposalExecuted {
    address[] memory reserves = POOL.getReservesList();
    for (uint256 i = 0; i < reserves.length; i++) {
      address underlying = reserves[i];
      DataTypes.ReserveData memory reserveData = POOL.getReserveDataExtended(underlying);
      bool isVirtualAccActive = AAVE_PROTOCOL_DATA_PROVIDER.getIsVirtualAccActive(underlying);

      if (underlying == AaveV3EthereumAssets.GHO_UNDERLYING) {
        assertEq(
          reserveData.virtualUnderlyingBalance,
          0,
          string.concat('virtual accounting is not correct for GHO')
        );
        assertFalse(isVirtualAccActive);
      } else {
        uint256 realUnderlying = IERC20(underlying).balanceOf(reserveData.aTokenAddress);

        assertTrue(isVirtualAccActive, 'no virtual accounting set');
        assertGe(
          realUnderlying,
          reserveData.virtualUnderlyingBalance,
          string.concat(
            'the balance of underlying can not be below VO: ',
            underlying == 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2
              ? 'MKR'
              : IERC20Metadata(underlying).symbol()
          )
        );
        assertLe(
          ((realUnderlying - reserveData.virtualUnderlyingBalance) * 1e7) / realUnderlying,
          VIRTUAL_ACCOUNTING_TO_ATOKEN_OFF_LIMIT,
          string.concat(
            'the balance of underlying is off VO more then the limit: ',
            underlying == 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2
              ? 'MKR'
              : IERC20Metadata(underlying).symbol()
          )
        );
      }
    }
  }

  /**
   * Test that cailing can be added to assets that have no collateral power
   */
  function test_ceiling() external {
    vm.startPrank(ACL_ADMIN);
    ReserveConfig[] memory configs = _getReservesConfigs(IOldPool(address(POOL)));
    /**
     * Try setting ceiling under current limitations
     */
    uint256 snapshot = vm.snapshot();
    for (uint256 i = 0; i < configs.length; i++) {
      uint256 totalSupply = IERC20(configs[i].aToken).totalSupply();
      if (configs[i].debtCeiling == 0 && totalSupply != 0)
        vm.expectRevert(bytes(Errors.RESERVE_LIQUIDITY_NOT_ZERO));
      CONFIGURATOR.setDebtCeiling(configs[i].underlying, configs[i].debtCeiling + 1e8);
    }
    vm.revertTo(snapshot);
    _executePayload();

    /**
     * Try setting ceiling under new limitations
     */
    for (uint256 i = 0; i < configs.length; i++) {
      uint256 totalSupply = IERC20(configs[i].aToken).totalSupply();
      if (configs[i].debtCeiling == 0 && (totalSupply != 0 && configs[i].liquidationThreshold != 0))
        vm.expectRevert(bytes(Errors.RESERVE_LIQUIDITY_NOT_ZERO));
      CONFIGURATOR.setDebtCeiling(configs[i].underlying, configs[i].debtCeiling + 1e8);
    }
  }

  function test_liquidationGracePeriod(
    uint40 gracePeriod,
    address user,
    uint128 collateralUsdAmount
  ) external {
    _executePayload();

    vm.assume(gracePeriod != 0 && gracePeriod < CONFIGURATOR.MAX_GRACE_PERIOD());
    vm.assume(collateralUsdAmount > 100 && collateralUsdAmount < 100_000);
    _adjustUser(user);

    ReserveConfig[] memory reserveConfigs = _getReservesConfigs(IOldPool(address(POOL)));

    address collateralAsset = _getGoodCollateralAsset(reserveConfigs);
    address debtAsset = _getGoodBorrowableAsset(reserveConfigs, collateralAsset);

    uint256 collateralAssetAmount = _getTokenAmountByDollarValue(
      IOldPool(address(POOL)),
      _findReserveConfig(reserveConfigs, collateralAsset),
      collateralUsdAmount
    );
    uint256 debtAssetAmount = _getTokenAmountByDollarValue(
      IOldPool(address(POOL)),
      _findReserveConfig(reserveConfigs, debtAsset),
      collateralUsdAmount / 2
    );

    // increase protocol borrow / supply cap to maximum
    if (_findReserveConfig(reserveConfigs, collateralAsset).supplyCap != 0) {
      vm.prank(ACL_ADMIN);
      CONFIGURATOR.setSupplyCap(collateralAsset, 0);
    }
    if (_findReserveConfig(reserveConfigs, debtAsset).borrowCap != 0) {
      vm.prank(ACL_ADMIN);
      CONFIGURATOR.setBorrowCap(debtAsset, 0);
    }

    // create a position of the user
    _deposit(
      _findReserveConfig(reserveConfigs, collateralAsset),
      IOldPool(address(POOL)),
      user,
      collateralAssetAmount
    );
    this._borrow(
      _findReserveConfig(reserveConfigs, debtAsset),
      IOldPool(address(POOL)),
      user,
      debtAssetAmount,
      false
    );

    // we reduce the price of collateral so the position could be liquidated
    address aaveOracle = POOL_ADDRESSES_PROVIDER.getPriceOracle();
    vm.mockCall(
      aaveOracle,
      abi.encodeWithSelector(IPriceOracleGetter.getAssetPrice.selector, collateralAsset),
      abi.encode(IPriceOracleGetter(aaveOracle).getAssetPrice(collateralAsset) / 10)
    );

    deal2(debtAsset, address(this), debtAssetAmount);
    IERC20(debtAsset).approve(address(POOL), debtAssetAmount);

    uint256 snapshotBeforeLiquidation = vm.snapshot();

    // check liquidations are allowed before setting grace period
    IPool(POOL).liquidationCall(collateralAsset, debtAsset, user, debtAssetAmount, false);
    vm.revertTo(snapshotBeforeLiquidation);

    vm.startPrank(ACL_ADMIN);
    CONFIGURATOR.setReservePause(collateralAsset, false, gracePeriod);
    assertEq(IPool(POOL).getLiquidationGracePeriod(collateralAsset), block.timestamp + gracePeriod);
    vm.stopPrank();

    // liquidation should revert as grace period has not passed
    vm.expectRevert(bytes(Errors.LIQUIDATION_GRACE_SENTINEL_CHECK_FAILED));
    IPool(POOL).liquidationCall(collateralAsset, debtAsset, user, debtAssetAmount, false);

    // liquidation should be allowed after grace period has passed
    vm.warp(block.timestamp + gracePeriod + 1);
    IPool(POOL).liquidationCall(collateralAsset, debtAsset, user, debtAssetAmount, false);
  }

  function _getGoodBorrowableAsset(
    ReserveConfig[] memory reserveConfigs,
    address collateralAsset
  ) internal pure returns (address) {
    for (uint i = 0; i < reserveConfigs.length; i++) {
      if (
        reserveConfigs[i].borrowingEnabled &&
        _includeInE2e(reserveConfigs[i]) &&
        reserveConfigs[i].underlying != collateralAsset
      ) {
        return reserveConfigs[i].underlying;
      }
    }
    revert('ERROR: No usable borrowable asset found');
  }

  function _getGoodCollateralAsset(ReserveConfig[] memory configs) internal pure returns (address) {
    for (uint256 i = 0; i < configs.length; i++) {
      if (
        _includeInE2e(configs[i]) &&
        configs[i].usageAsCollateralEnabled &&
        !configs[i].stableBorrowRateEnabled &&
        configs[i].debtCeiling == 0
      ) return configs[i].underlying;
    }
    revert('ERROR: No usable collateral found');
  }

  /**
   * Test the library getters are available
   */
  function test_getFlashLoanLogic() public proposalExecuted {
    assertNotEq(POOL.getFlashLoanLogic(), address(0));
  }

  function test_getBorrowLogic() public proposalExecuted {
    assertNotEq(POOL.getBorrowLogic(), address(0));
  }

  function test_getBridgeLogic() public proposalExecuted {
    assertNotEq(POOL.getBridgeLogic(), address(0));
  }

  function test_getEModeLogic() public proposalExecuted {
    assertNotEq(POOL.getEModeLogic(), address(0));
  }

  function test_getLiquidationLogic() public proposalExecuted {
    assertNotEq(POOL.getLiquidationLogic(), address(0));
  }

  function test_getPoolLogic() public proposalExecuted {
    assertNotEq(POOL.getPoolLogic(), address(0));
  }

  function test_getSupplyLogic() public proposalExecuted {
    assertNotEq(POOL.getSupplyLogic(), address(0));
  }

  function test_getConfiguratorLogic() public proposalExecuted {
    assertNotEq(CONFIGURATOR.getConfiguratorLogic(), address(0));
  }

  function test_sets_ltv_to_0_for_frozen_assets() public {
    address[] memory reserves = POOL.getReservesList();
    vm.startPrank(ACL_ADMIN);
    for (uint256 i = 0; i < reserves.length; i++) {
      DataTypes.ReserveDataLegacy memory reserveData = POOL.getReserveData(reserves[i]);
      if (reserveData.configuration.getFrozen()) {
        (uint256 ltv, uint256 liquidationThreshold, uint256 liquidationBonus, , , ) = reserveData
          .configuration
          .getParams();

        if (ltv == 0 && liquidationThreshold != 0) {
          ltv = liquidationThreshold - 1;
          CONFIGURATOR.configureReserveAsCollateral(
            reserves[i],
            ltv,
            liquidationThreshold,
            liquidationBonus
          );
        }
      }
    }
    _executePayload();

    for (uint256 i = 0; i < reserves.length; i++) {
      DataTypes.ReserveDataLegacy memory reserveData = POOL.getReserveData(reserves[i]);
      if (reserveData.configuration.getFrozen()) {
        (uint256 ltv, , , , , ) = reserveData.configuration.getParams();
        assertEq(ltv, 0);
        uint256 pendingLtv = CONFIGURATOR.getPendingLtv(reserves[i]);
        assertEq(pendingLtv, 0);
      }
    }
    vm.stopPrank();
  }
}
