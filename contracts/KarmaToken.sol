// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract KarmaToken is ERC20, Pausable, AccessControl {
    struct VestingSchedule {
        uint256 start;
        uint256 cliff;
        uint256 duration;
        uint256 amount;
        uint256 released;
    }

    enum WalletType { Seed, Private, Strategic, Public, Reserv, TTech, Operations, Marketing, Rewards, Liquidity }

    mapping(address => VestingSchedule) public vestingSchedules;
    mapping(WalletType => address[]) public walletAddresses;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    constructor() ERC20("KarmaToken", "KARMA") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
    }

    /**
     * @dev Adds a wallet with a specific vesting schedule.
     * @param _wallet The wallet address to which the vesting schedule applies.
     * @param _type The type of wallet from the WalletType enum.
     * @param _cliff The duration in seconds before which tokens begin to vest.
     * @param _vestingDuration The total duration in seconds over which tokens will vest.
     * @param _amount The total amount of tokens that will be vested.
     */
    function addWallet(address _wallet, WalletType _type, uint256 _cliff, uint256 _vestingDuration, uint256 _amount) public {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");

        VestingSchedule memory schedule = VestingSchedule({
            start: block.timestamp,
            cliff: block.timestamp + _cliff,
            duration: _vestingDuration,
            amount: _amount,
            released: 0
        });

        vestingSchedules[_wallet] = schedule;
        walletAddresses[_type].push(_wallet);
    }

    /**
     * @dev Releases vested tokens to a wallet.
     * @param _wallet The wallet address releasing its tokens.
     */
    function releaseTokens(address _wallet) public {
        VestingSchedule storage schedule = vestingSchedules[_wallet];

        require(block.timestamp > schedule.cliff, "Cliff period has not ended");
        uint256 unreleased = releasableAmount(_wallet);

        require(unreleased > 0, "No tokens are due for release");

        schedule.released += unreleased;
        _transfer(address(this), _wallet, unreleased);
    }

    /**
     * @dev Calculates the amount of tokens that can be released from vesting.
     * @param _wallet The wallet address for which to calculate the releasable amount.
     * @return The amount of tokens that can be released.
     */
    function releasableAmount(address _wallet) public view returns (uint256) {
        VestingSchedule storage schedule = vestingSchedules[_wallet];
        if (block.timestamp < schedule.cliff) {
            return 0;
        } else if (block.timestamp >= schedule.start + schedule.duration) {
            return schedule.amount - schedule.released;
        } else {
            uint256 totalVestingTime = block.timestamp - schedule.start;
            uint256 totalVestedAmount = (schedule.amount * totalVestingTime) / schedule.duration;
            return totalVestedAmount - schedule.released;
        }
    }

    // You might want to override the transfer and transferFrom functions of ERC20
    // to prevent transfers of locked tokens.

    // Additional functions for managing the contract and implementing ERC20 functionalities
    // would also be needed, depending on your specific requirements.
}