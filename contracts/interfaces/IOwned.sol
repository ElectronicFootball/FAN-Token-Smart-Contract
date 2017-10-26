pragma solidity ^0.4.11;

contract IOwned {
    function owner() public constant returns (address) {}

    function transferOwnership(address _newOwner) public;
    function acceptOwnership() public;
}