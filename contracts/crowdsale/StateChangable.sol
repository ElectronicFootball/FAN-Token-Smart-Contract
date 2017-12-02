pragma solidity ^0.4.0;
import "../Owned.sol";

/*
  Crowdsale state management
*/
contract StateChangable is Owned {
    enum TokenSaleState { Stopped, PreSale, Active }
    TokenSaleState public tokenSaleState = TokenSaleState.Stopped;

    function StateChangable() {
    }

    modifier activeStateOnly {
        require(tokenSaleState == TokenSaleState.Active);
        _;
    }

    modifier preSaleStateOnly {
        require(tokenSaleState == TokenSaleState.PreSale);
        _;
    }

    function setPreSaleState() public ownerOnly {
        tokenSaleState = TokenSaleState.PreSale;
    }

    function setActiveState() public ownerOnly {
        tokenSaleState = TokenSaleState.Active;
    }

    function setStoppedState() public ownerOnly {
        tokenSaleState = TokenSaleState.Stopped;
    }
}