pragma solidity ^0.4.11;
import '../TokenHolder.sol';
import '../interfaces/ISmartToken.sol';

contract SmartTokenController is TokenHolder {
    ISmartToken public token;

    function SmartTokenController(ISmartToken _token)
        validAddress(_token)
    {
        token = _token;
    }

    modifier active() {
        assert(token.owner() == address(this));
        _;
    }

    modifier inactive() {
        assert(token.owner() != address(this));
        _;
    }

    function transferTokenOwnership(address _newOwner) public ownerOnly {
        token.transferOwnership(_newOwner);
    }

    function acceptTokenOwnership() public ownerOnly {
        token.acceptOwnership();
    }

    function disableTokenTransfers(bool _disable) public ownerOnly {
        token.disableTransfers(_disable);
    }

    function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
        token.withdrawTokens(_token, _to, _amount);
    }
}