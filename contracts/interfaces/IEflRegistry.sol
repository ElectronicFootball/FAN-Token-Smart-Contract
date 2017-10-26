pragma solidity ^0.4.11;

import "./IOwned.sol";
import "./ISmartToken.sol";
import "./IEflContract.sol";
import "./IEflBountyManager.sol";

/*
  EFL Registry interface
*/
contract IEflRegistry is IOwned {
    function fanToken() public constant returns (ISmartToken) {}
    function bountyManager() public constant returns (IEflBountyManager) {}
    function isEflContract (address _contract) public constant returns (bool) {}

    function setFanToken(ISmartToken _fanToken) public;
    function setBountyManager(IEflBountyManager _bountyManager) public;
    function addEflContract(IEflContract _eflContract) public;
    function removeEflContract(IEflContract _eflContract) public;
}
