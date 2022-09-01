// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "../SimpleNft.sol";

contract MockSimpleNft is SimpleNft {

    //This function increments the s_tokenCounter value until its greater than the MAX_SUPPLY
    //For testing purposes
    function newTokenCounter() public {
        for(uint i = 0; i <= MAX_SUPPLY; i++) {
            s_tokenCounter = s_tokenCounter + i;
        }
    }

}