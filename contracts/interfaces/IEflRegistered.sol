pragma solidity ^0.4.11;
import "./IEflRegistry.sol";

/*
    EFL registered contract interface.
*/
contract IEflRegistered {
    function eflRegistry() public constant returns (IEflRegistry) {}
    function setEflRegistry(IEflRegistry _registry) public;
}