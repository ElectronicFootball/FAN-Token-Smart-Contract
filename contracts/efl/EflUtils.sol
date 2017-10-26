pragma solidity ^0.4.11;

import "../Owned.sol";
import "../Utils.sol";
import "../interfaces/IEflRegistry.sol";

/*
    EFL Utilities (Common utils and Efl registry functions)
*/
contract EflUtils is Owned, Utils {
    IEflRegistry public eflRegistry;

    modifier registeredToEfl() {
        require(address(eflRegistry) != 0x0);
        _;
    }

    function setEflRegistry(IEflRegistry _eflRegistry)
        public
        ownerOnly
        validAddress(_eflRegistry)
    {
        eflRegistry = _eflRegistry;

    }
}