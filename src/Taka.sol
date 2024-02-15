// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Taka Stable Coin
/// @author Yash Sharma (iamyxsh.dev)
/// @notice This is an ERC20 contract that is controlled by another smart contract
///         - TakaEngine which is responsible for minting and burning of tokens.
/// @notice Taka (Bengali for Currency) is pegged to the value of 1 India Ruppee.
/// @notice This contract is inspired by MakerDAO's DAI.
/// @dev This contract extends ERC20, ERC20Burnable, and Ownable for standard token functionality
///      and ownership control. It is designed to be controlled by the TakaEngine contract.

contract Taka is ERC20, ERC20Burnable, Ownable {

    ////////////////// //////////////////
    ///                               ///
    ///            Errors             ///
    ///                               ///
    ////////////////// //////////////////
    error Taka__AmountZero();
    error Taka__AddressZero();
    error Taka__BurnAmountMoreThanBalance();


    ////////////////// //////////////////
    ///                               ///
    ///           Modifiers           ///
    ///                               ///
    ////////////////// //////////////////
    modifier zeroAddress(address _to) {
        if (_to == address(0)) {
            revert Taka__AddressZero();
        }
        _;
    }

    modifier zeroAmount(uint256 _amount) {
        if (_amount == 0) {
            revert Taka__AmountZero();
        }
        _;
    }

    ////////////////// //////////////////
    ///                               ///
    ///           Functions           ///
    ///                               ///
    ////////////////// //////////////////
    constructor(address _owner) ERC20("Taka", "TAKA") Ownable(_owner) {}


    ////////////////////////
    ///                  ///
    /// External, Public ///
    ///                  ///
    ////////////////////////
    function mint(address _to, uint256 _amount) external onlyOwner zeroAddress(_to) zeroAmount(_amount) {
        super._mint(_to, _amount);
    }

    function burn(address _owner, uint256 _amount) external onlyOwner zeroAmount(_amount) {
        if (super.balanceOf(_owner) <= _amount) {
            revert Taka__BurnAmountMoreThanBalance();
        }
        super._burn(_owner, _amount);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}
