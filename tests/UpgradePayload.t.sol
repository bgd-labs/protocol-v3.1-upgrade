// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3helpers.sol';
import {ProtocolV3TestBase, IPool as IOldPool, ReserveConfig, IERC20, IERC20Metadata} from 'aave-helpers/ProtocolV3TestBase.sol';
import {IPoolAddressesProvider} from 'aave-v3-factory/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-factory/core/contracts/interfaces/IPoolConfigurator.sol';
import {IPool, DataTypes} from 'aave-v3-factory/core/contracts/interfaces/IPool.sol';
import {Errors} from 'aave-v3-factory/core/contracts/protocol/libraries/helpers/Errors.sol';
import {IPoolDataProvider} from 'aave-v3-factory/core/contracts/interfaces/IPoolDataProvider.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';

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
  UpgradePayload internal PAYLOAD;
  uint256 internal VIRTUAL_ACCOUNTING_TO_ATOKEN_OFF_LIMIT; // 1e7 is 100%

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
  }

  modifier proposalExecuted() {
    _executePayload();
    _;
  }

  function _getPayload() internal virtual returns (address);

  function _executePayload() internal {
    GovV3Helpers.executePayload(vm, address(PAYLOAD));
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
    vm.startPrank(POOL_ADDRESSES_PROVIDER.getACLAdmin());
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
}
