// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'forge-std/Test.sol';

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {PoolInstance} from '../src/contracts/PoolInstance.sol';

contract SwapToVariable is Test {
  PoolInstance public pool = PoolInstance(address(AaveV3Polygon.POOL));
  address public constant alice = 0xc5543b3a2973dd3b9d156376E1e8E7d0dCAc3664;
  address public constant asset = AaveV3PolygonAssets.DAI_UNDERLYING;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 50710149);
    PoolInstance poolImpl = new PoolInstance(AaveV3Polygon.POOL_ADDRESSES_PROVIDER);

    vm.prank(AaveV3Polygon.ACL_ADMIN);
    AaveV3Polygon.POOL_ADDRESSES_PROVIDER.setPoolImpl(address(poolImpl));
  }

  function test_swap_to_variable_works(address user) public {
    vm.assume(user != address(0));
    (
      ,
      uint256 currentStableDebtBefore,
      uint256 currentVariableDebtBefore,
      ,
      ,
      ,
      ,
      ,

    ) = AaveV3Polygon.AAVE_PROTOCOL_DATA_PROVIDER.getUserReserveData(asset, alice);

    vm.deal(user, 1e18);
    vm.prank(user);
    pool.swapToVariable(asset, alice);

    (, uint256 currentStableDebtAfter, uint256 currentVariableDebtAfter, , , , , , ) = AaveV3Polygon
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getUserReserveData(asset, alice);

    assertEq(currentStableDebtAfter, 0);
    assertEq(currentVariableDebtAfter, currentStableDebtBefore + currentVariableDebtBefore);
  }

  function test_swap_stable_to_variable_works() public {
    (
      ,
      uint256 currentStableDebtBefore,
      uint256 currentVariableDebtBefore,
      ,
      ,
      ,
      ,
      ,

    ) = AaveV3Polygon.AAVE_PROTOCOL_DATA_PROVIDER.getUserReserveData(asset, alice);

    vm.prank(alice);
    pool.swapBorrowRateMode(asset, 1);

    (, uint256 currentStableDebtAfter, uint256 currentVariableDebtAfter, , , , , , ) = AaveV3Polygon
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getUserReserveData(asset, alice);

    assertEq(currentStableDebtAfter, 0);
    assertEq(currentVariableDebtAfter, currentStableDebtBefore + currentVariableDebtBefore);
  }

  function test_not_reverts_swap_borrow_rate_reserve_frozen() public {
    vm.prank(AaveV3Polygon.ACL_ADMIN);
    AaveV3Polygon.POOL_CONFIGURATOR.setReserveFreeze(asset, true);

    vm.prank(alice);
    pool.swapBorrowRateMode(asset, 1);
  }

  function test_not_reverts_swap_to_variable_reserve_frozen(address user) public {
    vm.assume(user != address(0));

    vm.prank(AaveV3Polygon.ACL_ADMIN);
    AaveV3Polygon.POOL_CONFIGURATOR.setReserveFreeze(asset, true);

    vm.deal(user, 1e18);
    vm.prank(user);
    pool.swapToVariable(asset, alice);
  }
}
