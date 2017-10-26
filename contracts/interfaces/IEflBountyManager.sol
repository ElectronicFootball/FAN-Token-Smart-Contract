pragma solidity ^0.4.0;
import "./IOwned.sol";
import "./IEflRegistry.sol";
import "./IEflRegistered.sol";

/*
    EFL Bounty Manager Interface
*/
contract IEflBountyManager is IOwned, IEflRegistered {
    function version() public constant returns (string) {}
}
