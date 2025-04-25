// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface CRM {

    function stake(uint256 _unit) external ;

    function unstake(uint256 _amount) external ;

    function userData(address _addr) view external returns(uint256 total_unit,uint256 total_stake,uint256 available_stake,uint256 sc);
}
