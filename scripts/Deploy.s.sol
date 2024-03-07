// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {UpgradePayload} from '../src/contracts/UpgradePayload.sol';
import {UpgradePayloadL2} from '../src/contracts/UpgradePayloadL2.sol';
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

library DeploymentLibrary {
  function _deployPolygon() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Polygon.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Polygon.POOL),
          address(AaveV3Polygon.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployEthereum() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Ethereum.POOL),
          address(AaveV3Ethereum.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployAvalanche() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Avalanche.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Avalanche.POOL),
          address(AaveV3Avalanche.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployArbitrum() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Arbitrum.POOL),
          address(AaveV3Arbitrum.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployOptimism() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Optimism.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Optimism.POOL),
          address(AaveV3Optimism.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployBase() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Base.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Base.POOL),
          address(AaveV3Base.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployGnosis() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Gnosis.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Gnosis.POOL),
          address(AaveV3Gnosis.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployMetis() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Metis.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Metis.POOL),
          address(AaveV3Metis.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployBNB() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3BNB.POOL_ADDRESSES_PROVIDER),
          address(AaveV3BNB.POOL),
          address(AaveV3BNB.POOL_CONFIGURATOR)
        )
      );
  }

  function _deployScroll() internal returns (address) {
    return
      address(
        new UpgradePayload(
          address(AaveV3Scroll.POOL_ADDRESSES_PROVIDER),
          address(AaveV3Scroll.POOL),
          address(AaveV3Scroll.POOL_CONFIGURATOR)
        )
      );
  }
}
