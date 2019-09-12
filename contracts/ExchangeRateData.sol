pragma solidity ^0.4.25;

import "./Ownable.sol";

/** 
 * Organizational view exchangeRate data store. 
 */
contract ExchangeRateData is Ownable {
    // RetCodes
    uint256 constant private RET_SUCCESS = 0;
    uint256 constant private RET_ILLEGAL_INPUT = 500001;
    uint256 constant private RET_NO_PERMISSION = 500002;

    // Event
    event setExchangeRateLog(uint256 retCode, address account, bytes32 pair);

    struct ExchangeRate {
        // The asset pair, separated by "/", e.g. usd/hkd, btc/usdt, bac001/bac002
        // Pair is the key index hence is unique
        bytes32 pair;
        // Rate in uint256 manner。 Can store multiple values。
        uint256[] rate;
        // Rates Denominator in uint256 manner. This MUST be a 10**decimal number.
        uint256 base;
        // The exact timestamp 
        uint256 timestamp;
        // Extra values
        bytes32[] extra;
    }

    // key: asset pair name, value: actual exchangeRate struct; list for counting and getAll
    mapping (bytes32 => ExchangeRate) private exchangeRates;
    bytes32[] private exchangeRatePairs;

    // set
    function setExchangeRate(
        bytes32 pairval,
        uint256[] memory rateval,
        uint256 baseval,
        uint256 timestampval,
        bytes32[] memory extraval
    )
        public
        onlyOwner
        returns (uint256)
    {
        // Permission check
        // Param validity check
        if (pairval == bytes32(0) || timestampval == uint256(0) || baseval == uint256(0)) {
            emit setExchangeRateLog(RET_ILLEGAL_INPUT, tx.origin, pairval);
            return RET_ILLEGAL_INPUT;
        }
        // base must be 10-based decimal
        if (baseval % 10 > 0) {
            emit setExchangeRateLog(RET_ILLEGAL_INPUT, tx.origin, pairval);
            return RET_ILLEGAL_INPUT;
        }
        // biz logic
        if (exchangeRates[pairval].timestamp == uint256(0)) {
            // a new rate pair, record it
            exchangeRatePairs.push(pairval);
        }
        ExchangeRate memory exchangeRate = ExchangeRate(pairval, rateval, baseval, timestampval, extraval);
        exchangeRates[pairval] = exchangeRate;
        emit setExchangeRateLog(RET_SUCCESS, tx.origin, pairval);
        return RET_SUCCESS;
    }

    // get single
    function getExchangeRate(bytes32 pairval)
        public
        view
        returns (bytes32, uint256[], uint256, uint256, bytes32[])
    {
        return (pairval, exchangeRates[pairval].rate, exchangeRates[pairval].base, exchangeRates[pairval].timestamp, exchangeRates[pairval].extra);
    }
}