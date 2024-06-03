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
import {PoolInstanceWithCustomInitialize} from '../src/contracts/PoolInstanceWithCustomInitialize.sol';
import {L2PoolInstanceWithCustomInitialize} from '../src/contracts/L2PoolInstanceWithCustomInitialize.sol';
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {EthereumScript, PolygonScript, AvalancheScript, OptimismScript, ArbitrumScript, BaseScript, GnosisScript, MetisScript, BNBScript, ScrollScript} from 'aave-helpers/ScriptUtils.sol';

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

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployArbitrum chain=arbitrum
contract DeployArbitrum is ArbitrumScript {
  function run() external broadcast {
    DeploymentLibrary._deployArbitrum();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployOptimism chain=optimism
contract DeployOptimism is OptimismScript {
  function run() external broadcast {
    DeploymentLibrary._deployOptimism();
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

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployMetis chain=metis
contract DeployMetis is MetisScript {
  function run() external broadcast {
    DeploymentLibrary._deployMetis();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployBNB chain=bnb
contract DeployBNB is BNBScript {
  function run() external broadcast {
    DeploymentLibrary._deployBNB();
  }
}

// deploy-command: make deploy-ledger contract=scripts/Deploy.s.sol:DeployScroll chain=scroll
contract DeployScroll is ScrollScript {
  function run() external broadcast {
    DeploymentLibrary._deployScroll();
  }
}

library DeploymentLibrary {
  function _deployL2(
    address poolAddressesProvider,
    address pool,
    address poolConfigurator
  ) internal returns (address) {
    address poolImpl = address(
      new L2PoolInstanceWithCustomInitialize(IPoolAddressesProvider(poolAddressesProvider))
    );
    return _deployPayload(poolAddressesProvider, pool, poolConfigurator, poolImpl);
  }

  function _deployL1(
    address poolAddressesProvider,
    address pool,
    address poolConfigurator
  ) internal returns (address) {
    address poolImpl = address(
      new PoolInstanceWithCustomInitialize(IPoolAddressesProvider(poolAddressesProvider))
    );
    return _deployPayload(poolAddressesProvider, pool, poolConfigurator, poolImpl);
  }

  function _deployPayload(
    address poolAddressesProvider,
    address pool,
    address poolConfigurator,
    address poolImpl
  ) internal returns (address) {
    address poolDataProvider = address(
      new AaveProtocolDataProvider(IPoolAddressesProvider(poolAddressesProvider))
    );

    return
      address(
        new UpgradePayload(
          poolAddressesProvider,
          pool,
          poolConfigurator,
          poolImpl,
          poolDataProvider
        )
      );
  }

  function _deployPolygon() internal returns (address) {
    return
      _deployL1(
        address(AaveV3Polygon.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Polygon.POOL),
        address(AaveV3Polygon.POOL_CONFIGURATOR)
      );
  }

  function _deployEthereum() internal returns (address) {
    return
      _deployL1(
        address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Ethereum.POOL),
        address(AaveV3Ethereum.POOL_CONFIGURATOR)
      );
  }

  function _deployAvalanche() internal returns (address) {
    return
      _deployL1(
        address(AaveV3Avalanche.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Avalanche.POOL),
        address(AaveV3Avalanche.POOL_CONFIGURATOR)
      );
  }

  function _deployArbitrum() internal returns (address) {
    return
      _deployL2(
        address(AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Arbitrum.POOL),
        address(AaveV3Arbitrum.POOL_CONFIGURATOR)
      );
  }

  function _deployOptimism() internal returns (address) {
    return
      _deployL2(
        address(AaveV3Optimism.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Optimism.POOL),
        address(AaveV3Optimism.POOL_CONFIGURATOR)
      );
  }

  function _deployBase() internal returns (address) {
    return
      _deployL2(
        address(AaveV3Base.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Base.POOL),
        address(AaveV3Base.POOL_CONFIGURATOR)
      );
  }

  function _deployGnosis() internal returns (address) {
    return
      _deployL1(
        address(AaveV3Gnosis.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Gnosis.POOL),
        address(AaveV3Gnosis.POOL_CONFIGURATOR)
      );
  }

  function _deployMetis() internal returns (address) {
    return
      _deployL2(
        address(AaveV3Metis.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Metis.POOL),
        address(AaveV3Metis.POOL_CONFIGURATOR)
      );
  }

  function _deployBNB() internal returns (address) {
    return
      _deployL1(
        address(AaveV3BNB.POOL_ADDRESSES_PROVIDER),
        address(AaveV3BNB.POOL),
        address(AaveV3BNB.POOL_CONFIGURATOR)
      );
  }

  function _deployScroll() internal returns (address) {
    return
      _deployL2(
        address(AaveV3Scroll.POOL_ADDRESSES_PROVIDER),
        address(AaveV3Scroll.POOL),
        address(AaveV3Scroll.POOL_CONFIGURATOR)
      );
  }
}
