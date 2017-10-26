pragma solidity ^0.4.0;

import "../Owned.sol";
import "../Utils.sol";
import "../interfaces/IEflRegistry.sol";
import "../interfaces/IEflBountyManager.sol";
import "../interfaces/IEflContract.sol";
import "../interfaces/ISmartToken.sol";

/*
    EFL Registry v0.1
    Needed for handling connections between FanToken, EFL Smart Contracts and EFL Bounty manager.
*/
contract EflRegistry is IEflRegistry, Owned, Utils {
    string public version = '0.1';

    ISmartToken public fanToken;
    IEflBountyManager public bountyManager;
    mapping(address => bool) private eflContracts;

    // Set FanToken address
    function setFanToken(ISmartToken _fanToken) public ownerOnly validAddress(_fanToken) {
        fanToken = _fanToken;
    }

    // Set bounty manager address
    function setBountyManager(IEflBountyManager _bountyManager) public ownerOnly validAddress(_bountyManager) {
        bountyManager = _bountyManager;
    }

    // Adds EFL Contract to registry
    function addEflContract(IEflContract _eflContract) public ownerOnly validAddress(_eflContract) {
        eflContracts[_eflContract] = true;
    }

    // Removes EFL contract address if it exists in registry
    function removeEflContract(IEflContract _eflContract) public ownerOnly validAddress(_eflContract) {
        require(eflContracts[_eflContract]);
        delete eflContracts[_eflContract];
    }

    // Checks that passed contract address registered as EFL contract.
    function isEflContract (address _contract) public constant returns (bool) {
        return eflContracts[_contract];
    }
}