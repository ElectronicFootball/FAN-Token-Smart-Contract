pragma solidity ^0.4.0;

import "../Owned.sol";
import "oraclize/usingOraclize.sol";

/*
    Crowdsale USD Exchange rate provider.
*/
contract UsdUpdatable is usingOraclize, Owned {
    uint public USD_RATE;
    uint public USD_RATE_UPDATE_INTERVAL = 7200;
    bool public isUsdUpdating;

    mapping (bytes32 => bool) validIds;

    event newOraclizeQuery(string description);
    event newUsdRate(string rate);

    function setUsdRate(string rate) public ownerOnly {
        newUsdRate(rate);
        USD_RATE = parseInt(rate, 2);
    }

    function startUsdUpdates() public payable ownerOnly {
        isUsdUpdating = true;
        updateUsdRate(0);
    }

    function stopUsdUpdates() public ownerOnly {
        isUsdUpdating = false;
    }

    function updateUsdRate(uint duration) private {
        if (oraclize_getPrice("URL") > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
            isUsdUpdating = false;
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId = oraclize_query(duration, "URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
            validIds[queryId] = true;
        }
    }

    function __callback(bytes32 myid, string result) {
        require(validIds[myid] && msg.sender == oraclize_cbAddress());
        delete validIds[myid];
        oraclizeCallback(result);
    }

    function oraclizeCallback(string result) private {
        newUsdRate(result);
        USD_RATE = parseInt(result, 2);
        if (isUsdUpdating) {
            updateUsdRate(USD_RATE_UPDATE_INTERVAL);
        }
    }
}