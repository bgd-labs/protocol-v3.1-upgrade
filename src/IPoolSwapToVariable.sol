// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IPoolSwapToVariable {
  /**
   * @notice Allows a borrower to swap his debt between stable and variable mode,
   * @dev introduce in a flavor stable rate deprecation
   * @param asset The address of the underlying asset borrowed
   * @param user The address of the user to be swapped
   */
  function swapToVariable(address asset, address user) external;
}
