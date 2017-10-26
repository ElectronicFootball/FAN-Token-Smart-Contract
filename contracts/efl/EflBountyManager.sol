pragma solidity ^0.4.0;

import "./EflUtils.sol";
import "../Owned.sol";
import "../interfaces/IEflContract.sol";
import "../interfaces/IEflBountyManager.sol";

/*
    EFL Bounty v0.1.
    Manages rewarding EFL users with FanToken. This contract should hold
    FanToken allocated as rewards pool and transfer tokens to user by request
    of admin or EFL smart contract.
*/
contract EflBountyManager is IEflBountyManager, Owned, EflUtils {
    string public version = '0.1';

    // Checks that sender is admin or one of registered EFL contracts.
    modifier ownerOrEflContract() {
        assert(msg.sender == owner || eflRegistry.isEflContract(msg.sender));
        _;
    }

    /*
        @dev transfers FanToken from this contract balance to user. Validates
        sender address and state.

        @param _to address of user
        @param _value FanToken amount to send
    */
    function transfer(address _to, uint256 _value)
        public
        registeredToEfl
        ownerOrEflContract
        returns (bool success)
    {
        assert(eflRegistry.fanToken().transfer(_to, _value));
        return true;
    }
}