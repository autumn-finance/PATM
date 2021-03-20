// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "./openzeppelin/ERC20.sol";
import "./openzeppelin/Ownable.sol";
import "./openzeppelin/SafeERC20.sol";

/// @dev A `Prepare Token` for offering uses
contract PATM is ERC20, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public ATM = IERC20(0xfa3109e7593a286647794957Cb382Cb1e4600C7d);

    constructor () ERC20("Prepare Autumn", "PATM") {}

    /// @dev Whether PATM can be redeemed to ATM
    bool public canRedeem;

    function setCanRedeem(bool can_) onlyOwner() external {
        canRedeem = can_;
    }

    /// @dev Prepares ATM token to PATM pool
    function prepare(uint256 amount) external {
        ATM.safeTransferFrom(_msgSender(), address(this), amount);
        _mint(_msgSender(), amount);
    }

    /// @dev Redeems PATM to ATM
    function redeem(uint256 amount) external {
        require(canRedeem, "Cannot redeem");
        _burn(_msgSender(), amount);
        ATM.safeTransfer(_msgSender(), amount);
        emit Redeem(_msgSender(), amount);
    }

    /// @dev Emits when someone redeems PATM
    event Redeem(address sender, uint256 amount);
}