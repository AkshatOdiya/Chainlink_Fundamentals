// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract TimeBased{
    uint256 counter = 0;
    function count() external{
        counter++;
    }
    function getCount() public view returns(uint256){
        return counter;
    }

}