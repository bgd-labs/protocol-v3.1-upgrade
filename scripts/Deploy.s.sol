// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';
import {AaveV3Gnosis} from 'aave-address-book/AaveV3Gnosis.sol';
import {AaveV3Metis} from 'aave-address-book/AaveV3Metis.sol';
import {AaveV3BNB} from 'aave-address-book/AaveV3BNB.sol';
import {AaveV3Scroll} from 'aave-address-book/AaveV3Scroll.sol';
import {IPoolAddressesProvider} from 'aave-v3-origin/core/contracts/interfaces/IPoolAddressesProvider.sol';
import {AaveProtocolDataProvider} from 'aave-v3-origin/core/contracts/misc/AaveProtocolDataProvider.sol';
import {PoolConfiguratorInstance} from 'aave-v3-origin/core/instances/PoolConfiguratorInstance.sol';
import {EthereumScript, PolygonScript, AvalancheScript, OptimismScript, ArbitrumScript, MetisScript, BaseScript, GnosisScript, ScrollScript, BNBScript} from 'aave-helpers/ScriptUtils.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';

import {PoolInstanceWithCustomInitialize} from '../src/contracts/PoolInstanceWithCustomInitialize.sol';
import {L2PoolInstanceWithCustomInitialize} from '../src/contracts/L2PoolInstanceWithCustomInitialize.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';

library DeploymentLibrary {
  struct DeployPoolImplementationParams {
    address poolAddressesProvider;
    address pool;
    address poolConfigurator;
    address proofOfReserveExecutor;
  }
  struct DeployPayloadParams {
    address poolAddressesProvider;
    address pool;
    address poolImpl;
    address poolConfigurator;
    address proofOfReserveExecutor;
  }

  function _deployL2(DeployPoolImplementationParams memory params) internal returns (address) {
    address poolImpl = GovV3Helpers.deployDeterministic(
      type(L2PoolInstanceWithCustomInitialize).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    return
      _deployPayload(
        DeployPayloadParams({
          poolAddressesProvider: params.poolAddressesProvider,
          pool: params.pool,
          poolConfigurator: params.poolConfigurator,
          poolImpl: poolImpl,
          proofOfReserveExecutor: params.proofOfReserveExecutor
        })
      );
  }

  function _deployL1(DeployPoolImplementationParams memory params) internal returns (address) {
    address poolImpl = GovV3Helpers.deployDeterministic(
      type(PoolInstanceWithCustomInitialize).creationCode,
      abi.encode(params.poolAddressesProvider)
    );
    return
      _deployPayload(
        DeployPayloadParams({
          poolAddressesProvider: params.poolAddressesProvider,
          pool: params.pool,
          poolConfigurator: params.poolConfigurator,
          poolImpl: poolImpl,
          proofOfReserveExecutor: params.proofOfReserveExecutor
        })
      );
  }

  function _deployPayload(DeployPayloadParams memory params) internal returns (address) {
    address poolConfiguratorImpl = GovV3Helpers.deployDeterministic(
      type(PoolConfiguratorInstance).creationCode
    );
    address poolDataProvider = GovV3Helpers.deployDeterministic(
      type(AaveProtocolDataProvider).creationCode,
      abi.encode(params.poolAddressesProvider)
    );

    return
      GovV3Helpers.deployDeterministic(
        type(UpgradePayload).creationCode,
        abi.encode(
          UpgradePayload.ConstructorParams({
            poolAddressesProvider: params.poolAddressesProvider,
            pool: params.pool,
            poolConfigurator: params.poolConfigurator,
            poolImpl: params.poolImpl,
            poolConfiguratorImpl: poolConfiguratorImpl,
            poolDataProvider: poolDataProvider,
            proofOfReserveExecutor: params.proofOfReserveExecutor
          })
        )
      );
  }

  function _deployPolygon() internal returns (address) {
    return
      _deployL1(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Polygon.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Polygon.POOL),
          poolConfigurator: address(AaveV3Polygon.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployEthereum() internal returns (address) {
    return
      _deployL1(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Ethereum.POOL),
          poolConfigurator: address(AaveV3Ethereum.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployAvalanche() internal returns (address) {
    return
      _deployL1(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Avalanche.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Avalanche.POOL),
          poolConfigurator: address(AaveV3Avalanche.POOL_CONFIGURATOR),
          proofOfReserveExecutor: AaveV3Avalanche.PROOF_OF_RESERVE
        })
      );
  }

  function _deployArbitrum() internal returns (address) {
    return
      _deployL2(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Arbitrum.POOL),
          poolConfigurator: address(AaveV3Arbitrum.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployOptimism() internal returns (address) {
    return
      _deployL2(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Optimism.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Optimism.POOL),
          poolConfigurator: address(AaveV3Optimism.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployBase() internal returns (address) {
    return
      _deployL2(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Base.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Base.POOL),
          poolConfigurator: address(AaveV3Base.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployGnosis() internal returns (address) {
    return
      _deployL1(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Gnosis.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Gnosis.POOL),
          poolConfigurator: address(AaveV3Gnosis.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployMetis() internal returns (address) {
    return
      _deployL2(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Metis.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Metis.POOL),
          poolConfigurator: address(AaveV3Metis.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployBNB() internal returns (address) {
    return
      _deployL1(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3BNB.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3BNB.POOL),
          poolConfigurator: address(AaveV3BNB.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }

  function _deployScroll() internal returns (address) {
    return
      _deployL2(
        DeployPoolImplementationParams({
          poolAddressesProvider: address(AaveV3Scroll.POOL_ADDRESSES_PROVIDER),
          pool: address(AaveV3Scroll.POOL),
          poolConfigurator: address(AaveV3Scroll.POOL_CONFIGURATOR),
          proofOfReserveExecutor: address(0)
        })
      );
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployEthereum chain=mainnet
contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    DeploymentLibrary._deployEthereum();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployPolygon chain=polygon
contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    DeploymentLibrary._deployPolygon();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployAvalanche chain=avalanche
contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    DeploymentLibrary._deployAvalanche();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployOptimism chain=optimism
contract DeployOptimism is OptimismScript {
  function run() external broadcast {
    DeploymentLibrary._deployOptimism();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployArbitrum chain=arbitrum
contract DeployArbitrum is ArbitrumScript {
  function run() external broadcast {
    DeploymentLibrary._deployArbitrum();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployMetis chain=metis
contract DeployMetis is MetisScript {
  function run() external broadcast {
    DeploymentLibrary._deployMetis();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployBase chain=base
contract DeployBase is BaseScript {
  function run() external broadcast {
    DeploymentLibrary._deployBase();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployGnosis chain=gnosis
contract DeployGnosis is GnosisScript {
  function run() external broadcast {
    DeploymentLibrary._deployGnosis();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployScroll chain=scroll
contract DeployScroll is ScrollScript {
  function run() external broadcast {
    DeploymentLibrary._deployScroll();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployBNB chain=bnb
contract DeployBNB is BNBScript {
  function run() external broadcast {
    DeploymentLibrary._deployBNB();
  }
}
