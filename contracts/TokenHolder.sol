pragma solidity ^0.4.11;
import './Owned.sol';
import './Utils.sol';
import './interfaces/IERC20Token.sol';
import './interfaces/ITokenHolder.sol';

contract TokenHolder is ITokenHolder, Owned, Utils {
    function TokenHolder() {
    }

    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
        public
        ownerOnly
        validAddress(_token)
        validAddress(_to)
        notThis(_to)
    {
        assert(_token.transfer(_to, _amount));
    }
}
