// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPool} from 'aave-v3-origin/core/contracts/interfaces/IPool.sol';

import {UpgradePayloadTest} from './UpgradePayload.t.sol';

abstract contract UpgradePayloadTestWithStableSwap is UpgradePayloadTest {
  address internal USER_WITH_STABLE;
  address internal RESERVE_WITH_STABLE;

  constructor(
    string memory network,
    uint256 blocknumber,
    address userWithStable,
    address reserveWithStable,
    uint256 voOffLimit
  ) UpgradePayloadTest(network, blocknumber, voOffLimit) {
    USER_WITH_STABLE = userWithStable;
    RESERVE_WITH_STABLE = reserveWithStable;
  }

  // ****** tests for swap to variable ******
  function test_swap_to_variable_works(address user) public proposalExecuted {
    _adjustUser(user);
    (
      ,
      uint256 currentStableDebtBefore,
      uint256 currentVariableDebtBefore,
      ,
      ,
      ,
      ,
      ,

    ) = AAVE_PROTOCOL_DATA_PROVIDER.getUserReserveData(RESERVE_WITH_STABLE, USER_WITH_STABLE);

    vm.deal(user, 1e18);
    vm.prank(user);
    POOL.swapToVariable(RESERVE_WITH_STABLE, USER_WITH_STABLE);

    (
      ,
      uint256 currentStableDebtAfter,
      uint256 currentVariableDebtAfter,
      ,
      ,
      ,
      ,
      ,

    ) = AAVE_PROTOCOL_DATA_PROVIDER.getUserReserveData(RESERVE_WITH_STABLE, USER_WITH_STABLE);

    assertEq(currentStableDebtAfter, 0);
    assertEq(currentVariableDebtAfter, currentStableDebtBefore + currentVariableDebtBefore);
  }

  function test_swap_stable_to_variable_works() public proposalExecuted {
    (
      ,
      uint256 currentStableDebtBefore,
      uint256 currentVariableDebtBefore,
      ,
      ,
      ,
      ,
      ,

    ) = AAVE_PROTOCOL_DATA_PROVIDER.getUserReserveData(RESERVE_WITH_STABLE, USER_WITH_STABLE);

    vm.prank(USER_WITH_STABLE);
    IPool(POOL).swapBorrowRateMode(RESERVE_WITH_STABLE, 1);

    (
      ,
      uint256 currentStableDebtAfter,
      uint256 currentVariableDebtAfter,
      ,
      ,
      ,
      ,
      ,

    ) = AAVE_PROTOCOL_DATA_PROVIDER.getUserReserveData(RESERVE_WITH_STABLE, USER_WITH_STABLE);

    assertEq(currentStableDebtAfter, 0);
    assertEq(currentVariableDebtAfter, currentStableDebtBefore + currentVariableDebtBefore);
  }

  function test_not_reverts_swap_borrow_rate_reserve_frozen() public proposalExecuted {
    vm.prank(ACL_ADMIN);
    CONFIGURATOR.setReserveFreeze(RESERVE_WITH_STABLE, true);

    vm.prank(USER_WITH_STABLE);
    POOL.swapBorrowRateMode(RESERVE_WITH_STABLE, 1);
  }

  function test_not_reverts_swap_to_variable_reserve_frozen(address user) public proposalExecuted {
    _adjustUser(user);

    vm.prank(ACL_ADMIN);
    CONFIGURATOR.setReserveFreeze(RESERVE_WITH_STABLE, true);

    vm.deal(user, 1e18);
    vm.prank(user);
    POOL.swapToVariable(RESERVE_WITH_STABLE, USER_WITH_STABLE);
  }
}
