pragma solidity ^0.4.25;

import "./SafeMath.sol";

/** 
 * Compute handler demo.
 */

contract ComputeHandler {

    using SafeMath for uint256;

    function integrationTest() public pure returns (bool) {
        // compute: convert 1 usd token to ?? cny via the med price
        uint256 inputUsd = SafeMath.mul(1, 10**18);
        uint256 result = convertAmount(inputUsd, 704710, 100000);
        assert(result == 7047100000000000000);
        return true;
    }

    function convertAmount(uint256 inputAmountWei, uint256 rate, uint256 base) public pure returns (uint256) {
        return SafeMath.getPartialAmountFloor(rate, base, inputAmountWei);
    }
}