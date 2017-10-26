pragma solidity ^0.4.11;
import "./IOwned.sol";
import "./IEflRegistered.sol";

/*
    EFL Contract interface.
    Contract that handles EFL platform activities and should
    send bounties to users must be inherited from this interface.
*/
contract IEflContract is IOwned, IEflRegistered {
    function name() public constant returns (string) {}
    function description() public constant returns (string) {}
    function version() public constant returns (string) {}
}