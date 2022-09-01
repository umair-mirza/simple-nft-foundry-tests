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

    //No more than 5 tokens can be minted in a single transaction
    function testFailBatchMint() public {
        vm.startPrank(userOne);
        vm.deal(userOne, 1 ether);
        
        simpleNft.mintMultipleNfts{value: 1 ether}(6);
        vm.stopPrank();
        assertEq(simpleNft.balanceOf(userOne), 6);
    }

    //Owner can withdraw the funds collected from sale
    function testWithdraw() public {

        //first mint 5 NFTs via userOne
        vm.startPrank(userOne);
        vm.deal(userOne, 1 ether);
        
        simpleNft.mintMultipleNfts{value: 0.05 ether}(5);
        assertEq(simpleNft.balanceOf(userOne), 5);
        vm.stopPrank();
        // assertEq(simpleNft.balanceOf(owner), 0);

        //now verify the withdraw method by signing in the owner
        vm.startPrank(owner);
        simpleNft.withdraw();
        vm.stopPrank();
        assertEq(owner.balance, 0.05 ether);
    }

    //You can mint one token provided the correct amount of ETH
    function testMineOne() public {
        vm.startPrank(userOne);
        vm.deal(userOne, 0.01 ether);

        simpleNft.mintMultipleNfts{value: 0.01 ether}(1);
        assertEq(simpleNft.balanceOf(userOne), 1);
        vm.stopPrank();
    }

    //You can mint three tokens provided the correct amount of ETH
    //Check the balance of an account that has minted three tokens
    function testMintThree() public {
        vm.startPrank(userOne);
        vm.deal(userOne, 0.03 ether);

        simpleNft.mintMultipleNfts{value: 0.03 ether}(3);
        assertEq(simpleNft.balanceOf(userOne), 3);
        vm.stopPrank();
    }

}