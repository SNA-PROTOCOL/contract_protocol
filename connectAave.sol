// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AaveUSDTHandler {
    IERC20 public immutable usdt;
    IPool public immutable aavePool;
    address public constant AAVE_POOL;
    address public constant USDT;

    mapping(address => uint256) private _balances;

    constructor() {
        usdt = IERC20(USDT);
        aavePool = IPool(AAVE_POOL);
    }

    // Stake with approval limit
    function stake(uint256 amount, uint256 maxApproval) external {
        require(usdt.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        // Set approval with limit
        usdt.approve(AAVE_POOL, maxApproval);
        
        aavePool.supply(USDT, amount, address(this), 0);
        _balances[msg.sender] += amount;
    }

    // Unstake with amount control
    function unstake(uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Exceeds staked balance");
        _balances[msg.sender] -= amount;
        aavePool.withdraw(USDT, amount, msg.sender);
    }

    // Custom approval function
    function approveSpender(address spender, uint256 amount) external {
        usdt.approve(spender, amount);
    }

    // View staked balance
    function stakedBalance(address user) external view returns (uint256) {
        return _balances[user];
    }
}
