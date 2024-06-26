import {AaveV3Ethereum} from '@bgd-labs/aave-address-book';

enum Networks {
  MAINNET = 'MAINNET',
  FACTORY_LOCAL = 'FACTORY_LOCAL',
}

const CONTRACTS: ContractsType = {
  [Networks.FACTORY_LOCAL]: {
    POOL: {
      name: 'Pool',
      path: 'lib/aave-v3-origin/src/core/instances/PoolInstance.sol',
    },
    POOL_CONFIGURATOR: {
      name: 'PoolConfigurator',
      path: 'lib/aave-v3-origin/src/core/instances/PoolConfiguratorInstance.sol',
    },
    BORROW_LOGIC: {
      name: 'BorrowLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol',
    },
    BRIDGE_LOGIC: {
      name: 'BridgeLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/BridgeLogic.sol',
    },
    CONFIGURATOR_LOGIC: {
      name: 'ConfiguratorLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol',
    },
    EMODE_LOGIC: {
      name: 'EModeLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/EModeLogic.sol',
    },
    FLASHLOAN_LOGIC: {
      name: 'FlashLoanLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/FlashLoanLogic.sol',
    },
    LIQUIDATION_LOGIC: {
      name: 'LiquidationLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/LiquidationLogic.sol',
    },
    POOL_LOGIC: {
      name: 'PoolLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/PoolLogic.sol',
    },
    SUPPLY_LOGIC: {
      name: 'SupplyLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/SupplyLogic.sol',
    },
    CALLDATA_LOGIC: {
      name: 'CalldataLogic',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/libraries/logic/CalldataLogic.sol',
    },
    DEFAULT_INTEREST_RATE_STRATEGY: {
      name: 'DefaultReserveInterestRateStrategy',
      path: 'lib/aave-v3-origin/src/core/contracts/protocol/pool/DefaultReserveInterestRateStrategyV2.sol',
    },
  },
  [Networks.MAINNET]: {
    POOL: {
      name: 'Pool',
      path: 'Pool/lib/aave-v3-factory/src/core/contracts/protocol/pool/Pool.sol',
      address: AaveV3Ethereum.POOL,
    },
    POOL_CONFIGURATOR: {
      name: 'PoolConfigurator',
      path: 'PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol',
      address: AaveV3Ethereum.POOL_CONFIGURATOR,
    },
    BORROW_LOGIC: {
      name: 'BorrowLogic',
      path: 'BorrowLogic/src/core/contracts/protocol/libraries/logic/BorrowLogic.sol',
      address: '0x5547D7d54d10C359108e36d098016c4020443Fd4',
    },
    BRIDGE_LOGIC: {
      name: 'BridgeLogic',
      path: 'BridgeLogic/src/core/contracts/protocol/libraries/logic/BridgeLogic.sol',
      address: '0xd948Cfb92eBF175E4bD772305fdEe8f39e934520',
    },
    CONFIGURATOR_LOGIC: {
      name: 'ConfiguratorLogic',
      path: 'ConfiguratorLogic/src/core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol',
      address: '0x433c792f11D102249DccD55452dDD84c7A2Ef8f2',
    },
    EMODE_LOGIC: {
      name: 'EModeLogic',
      path: 'EModeLogic/src/core/contracts/protocol/libraries/logic/EModeLogic.sol',
      address: '0xB341e4f99c73caA2136302f468ac3b75827C1736',
    },
    FLASHLOAN_LOGIC: {
      name: 'FlashLoanLogic',
      path: 'FlashLoanLogic/lib/aave-v3-factory/src/core/contracts/protocol/libraries/logic/FlashLoanLogic.sol',
      address: '0x0063Bcd116694c21F6A94AA78E10eF4d7819a609',
    },
    LIQUIDATION_LOGIC: {
      name: 'LiquidationLogic',
      path: 'LiquidationLogic/src/core/contracts/protocol/libraries/logic/LiquidationLogic.sol',
      address: '0x5125bCf6380C5D5Ccad4d4A88C3664DF646Bc6c3',
    },
    POOL_LOGIC: {
      name: 'PoolLogic',
      path: 'PoolLogic/src/core/contracts/protocol/libraries/logic/PoolLogic.sol',
      address: '0x7b8186933eAd860f49114fb10e3a7f17a11bEd8a',
    },
    SUPPLY_LOGIC: {
      name: 'SupplyLogic',
      path: 'SupplyLogic/src/core/contracts/protocol/libraries/logic/SupplyLogic.sol',
      address: '0x589F82Ff8162Fa96545b435435713E9D6ca79fBB',
    },
    DEFAULT_INTEREST_RATE_STRATEGY: {
      name: 'DefaultReserveInterestRateStrategy',
      path: 'DefaultReserveInterestRateStrategy/lib/aave-address-book/lib/aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol',
      address: '0xf1e5355cEcaA71036CE21cdF8F9d04061B1BC6E1',
    },
  }
};

interface ContractInfo {
  name: string;
  path: string;
  address?: string;
}

type ContractsType = {
  [key in Networks]: {
    [contractName: string]: ContractInfo;
  };
};

const PROXIES = [
  'POOL',
  'POOL_CONFIGURATOR',
];

const CHAIN_ID = {
  [Networks.MAINNET]: 1,
  [Networks.FACTORY_LOCAL]: undefined,
};

export {CONTRACTS, PROXIES, CHAIN_ID, Networks};
