pragma solidity ^0.4.25;

import "./Oracle.sol";
import "./DynamicOracle.sol";

contract OracleFactory {
    uint constant private TYPE_STATIC = 0;
    uint constant private TYPE_DYNAMIC = 1;

    uint constant private RET_SUCCESS = 0;
    uint constant private RET_ILLEGAL_INPUT = 900001;

    event createOracleLog(uint retCode, address addr);

    function createOracle(uint type) public returns (bool) {
        if (type == TYPE_STATIC) {
            Oracle oracle = new Oracle();
            createOracleLog(RET_SUCCESS, oracle);
        } else if (type == TYPE_DYNAMIC) {
            DynamicOracle oracle = new DynamicOracle();
            createOracleLog(RET_SUCCESS, oracle);
        } else {
            createOracleLog(RET_ILLEGAL_INPUT, 0x0);
        }
    }
}