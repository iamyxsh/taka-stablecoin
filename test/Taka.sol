// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Taka} from "../src/Taka.sol";

contract TakaTest is Test {
    Taka public taka;

    address public OWNER = makeAddr("owner");
    uint256 public MINTING_AMOUNT = 10e6;

    ////////////////// //////////////////
    ///                               ///
    ///           Modifiers           ///
    ///                               ///
    ////////////////// //////////////////

    modifier minToAddress(address _to, uint256 _amount) {
        vm.prank(OWNER);
        taka.mint(_to, _amount);
        _;
    }

    function setUp() public {
        taka = new Taka(OWNER);
    }

    ////////////////// //////////////////
    ///                               ///
    ///           Happy Path          ///
    ///                               ///
    ////////////////// //////////////////

    function testInitialinfo() public {
        assertEq(taka.name(), "Taka");
        assertEq(taka.symbol(), "TAKA");
        assertEq(taka.decimals(), 6);
    }

    function testOwnerCanMint() public {
        vm.prank(OWNER);
        taka.mint(OWNER, MINTING_AMOUNT);
        assertEq(taka.balanceOf(OWNER), MINTING_AMOUNT);
    }

    function testOwnerCanBurn() public minToAddress(OWNER, MINTING_AMOUNT) {
        vm.prank(OWNER);
        taka.burn(OWNER, MINTING_AMOUNT - 1e6);
        assertEq(taka.balanceOf(OWNER),  1e6);
    }

    ////////////////// //////////////////
    ///                               ///
    ///            Reverts            ///
    ///                               ///
    ////////////////// //////////////////

    function testMintingZeroAddress() public {
        vm.prank(OWNER);
        vm.expectRevert(Taka.Taka__AddressZero.selector);
        taka.mint(address(0), MINTING_AMOUNT);
    }

    function testMintingZeroAmount() public {
        vm.prank(OWNER);
        vm.expectRevert(Taka.Taka__AmountZero.selector);
        taka.mint(OWNER, 0);
    }


    function testBurningZeroAmount() public  minToAddress(OWNER, MINTING_AMOUNT) {
        vm.prank(OWNER);
        vm.expectRevert(Taka.Taka__AmountZero.selector);
        taka.burn(OWNER, 0);
    }

    function testBurningAmountLessThanbalance() public  minToAddress(OWNER, MINTING_AMOUNT) {
        vm.prank(OWNER);
        vm.expectRevert(Taka.Taka__BurnAmountMoreThanBalance.selector);
        taka.burn(OWNER, MINTING_AMOUNT + 1e6);
    }

}
