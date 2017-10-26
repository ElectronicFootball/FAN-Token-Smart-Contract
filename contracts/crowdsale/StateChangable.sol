pragma solidity ^0.4.0;
import "../Owned.sol";

/*
  Crowdsale state management
*/
contract StateChangable is Owned {
    enum TokenSaleState { Stopped, Active }
    TokenSaleState public tokenSaleState = TokenSaleState.Stopped;

    function StateChangable() {
    }

    modifier activeStateOnly {
        require(tokenSaleState == TokenSaleState.Active);
        _;
    }

    function setActiveState() public ownerOnly {
        tokenSaleState = TokenSaleState.Active;
    }

    function setStoppedState() public ownerOnly {
        tokenSaleState = TokenSaleState.Stopped;
    }
}