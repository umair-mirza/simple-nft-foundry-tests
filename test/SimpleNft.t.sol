// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/mocks/MockSimpleNft.sol";

contract MockSimpleNftTest is Test {
    MockSimpleNft public simpleNft;
    ERC721 public token;

    address owner = address(0x1234);
    address userOne = address(0x1122);


    //Setup Function
    function setUp() public {
        vm.startPrank(owner);
        simpleNft = new MockSimpleNft();
        vm.stopPrank(); 
    }

    //A token can not be minted if less value than cost (0.01) is provided
    function testFailMint() public {
        vm.startPrank(userOne);
        vm.deal(userOne, 2 ether);

        simpleNft.mintNft{value: 0.001 ether}();
        vm.stopPrank();
        assertEq(simpleNft.balanceOf(userOne), 1);
    }

    //No more than 100 tokens can be minted
    function testFailMaxMint() public {
        vm.startPrank(userOne);
        vm.deal(userOne, 2 ether);
        simpleNft.newTokenCounter();
        simpleNft.mintNft{value: 0.01 ether}();
        vm.stopPrank();
        assertEq(simpleNft.balanceOf(userOne), 1);
    }


}