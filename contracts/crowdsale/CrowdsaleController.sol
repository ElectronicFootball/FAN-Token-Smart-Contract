pragma solidity ^0.4.0;

import "../Owned.sol";
import "../TokenHolder.sol";
import "./StateChangable.sol";
import "./UsdUpdatable.sol";
import "../bancor/SmartTokenController.sol";
import "../interfaces/ISmartToken.sol";

/*
    FanToken crowdsale contract
*/
contract CrowdsaleController is SmartTokenController, UsdUpdatable, StateChangable {
    string public name = "FanToken Crowdsale";
    uint numPurchases;
    address public beneficiary;

    // Returns total raised amount during all crowdsale rounds in ETH.
    uint public etherRaised;

    // Returns total raised amount during all crowdsale rounds in USD.
    uint public fiatRaised;

    event TokenPurchased(uint256 id, uint256 value, address from, uint createdAt, uint currentUsdRate, bytes txData);

    /*
       Contribution amount validator
       Checks that amount not less than 1$
   */
    modifier validateAmount {
        require(msg.value >= (1 ether / (USD_RATE / 100)));
        _;
    }

    modifier validateData {
        require(msg.data.length != 0);
        _;
    }

    function CrowdsaleController(ISmartToken _token, address _beneficiary)
        SmartTokenController(_token)
    {
        beneficiary = _beneficiary;
    }

    /*
      Sets beneficiary address
    */
    function setBeneficiary(address _beneficiary) public ownerOnly validAddress(_beneficiary) {
        beneficiary = _beneficiary;
    }

    /*
      Updates value of fiatRaised counter.
    */
    function updateFiatRaisedCounter(uint _amount) public ownerOnly {
        fiatRaised = _amount;
    }

    /*
      Updates value of etherRaised counter.
    */
    function updateEtherRaisedCounter(uint _amount) public ownerOnly {
        etherRaised = _amount;
    }

    /*
        Sends specified amount of FanToken to user address.
    */
    function issueTokens(address _to, uint256 _amount) active ownerOnly {
        token.issue(_to, _amount);
    }

    /*
        Gives number to contribution and emits event.
        Sends contribution amount to beneficiary account.
    */
    function processPurchase(uint256 _value, address _from, bytes _data) private {
        require(beneficiary.send(msg.value));
        uint purchaseID = numPurchases++;
        TokenPurchased(purchaseID, _value, _from, now, USD_RATE, _data);
    }

    /*
        ETH contribution function
        Throws error if crowdsale not started or amount less than 1$
    */
    function ()
        payable
        activeStateOnly
        validateAmount
        validateData
    {
        processPurchase(msg.value, msg.sender, msg.data);
    }
}