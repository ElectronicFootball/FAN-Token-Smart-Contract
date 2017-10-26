pragma solidity ^0.4.11;
import '../Owned.sol';
import '../Utils.sol';
import '../interfaces/IBancorFormula.sol';

contract BancorFormulaProxy is IBancorFormula, Owned, Utils {
    IBancorFormula public formula;

    function BancorFormulaProxy(IBancorFormula _formula)
        validAddress(_formula)
    {
        formula = _formula;
    }

    function setFormula(IBancorFormula _formula)
        public
        ownerOnly
        validAddress(_formula)
        notThis(_formula)
    {
        formula = _formula;
    }

    function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256) {
        return formula.calculatePurchaseReturn(_supply, _reserveBalance, _reserveRatio, _depositAmount);
    }

    function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256) {
        return formula.calculateSaleReturn(_supply, _reserveBalance, _reserveRatio, _sellAmount);
    }
}