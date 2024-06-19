// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ProtocolV3TestBase, IERC20} from 'aave-helpers/ProtocolV3TestBase.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {IPoolConfigurator} from 'aave-v3-origin/core/contracts/interfaces/IPoolConfigurator.sol';
import {IPool} from 'aave-v3-origin/core/contracts/interfaces/IPool.sol';
import {IPoolDataProvider} from 'aave-v3-origin/core/contracts/interfaces/IPoolDataProvider.sol';
import {UpgradePayload} from '../../src/contracts/UpgradePayload.sol';

abstract contract BaseTest is ProtocolV3TestBase {
  string public NETWORK;
  uint256 public immutable BLOCK_NUMBER;
  IPoolAddressesProvider internal POOL_ADDRESSES_PROVIDER;
  IPoolConfigurator internal CONFIGURATOR;
  IPoolDataProvider internal AAVE_PROTOCOL_DATA_PROVIDER;
  IPool internal POOL;
  UpgradePayload internal PAYLOAD;

  constructor(string memory network, uint256 blocknumber) {
    NETWORK = network;
    BLOCK_NUMBER = blocknumber;
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
}
