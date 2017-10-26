pragma solidity ^0.4.0;

import "./bancor/SmartToken.sol";

contract FanToken is SmartToken {
    function FanToken() SmartToken("FanToken", "FAN", 2) {
    }
}