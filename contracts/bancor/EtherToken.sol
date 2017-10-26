pragma solidity ^0.4.11;
import '../fan_token/ERC20Token.sol';
import '../TokenHolder.sol';
import '../Owned.sol';
import '../interfaces/IEtherToken.sol';

contract EtherToken is IEtherToken, Owned, ERC20Token, TokenHolder {
    event Issuance(uint256 _amount);
    event Destruction(uint256 _amount);

    function EtherToken()
        ERC20Token('Ether Token', 'ETH', 18) {
    }

    function deposit() public payable {
        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value);
        totalSupply = safeAdd(totalSupply, msg.value);

        Issuance(msg.value);
        Transfer(this, msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        withdrawTo(msg.sender, _amount);
    }

    function withdrawTo(address _to, uint256 _amount)
        public
        notThis(_to)
    {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount);
        totalSupply = safeSub(totalSupply, _amount);
        _to.transfer(_amount);

        Transfer(msg.sender, this, _amount);
        Destruction(_amount);
    }

    function transfer(address _to, uint256 _value)
        public
        notThis(_to)
        returns (bool success)
    {
        assert(super.transfer(_to, _value));
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
        public
        notThis(_to)
        returns (bool success)
    {
        assert(super.transferFrom(_from, _to, _value));
        return true;
    }

    function() public payable {
        deposit();
    }
}