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

    // Base rate when denominator is 1, which means the precision can be up to 1/RATE_BASE
    uint256 constant public RATE_BASE = 100000;

    // Event
    event setExchangeRateLog(uint256 retCode, address account, bytes32 pair);

    struct ExchangeRate {
        // The asset pair, separated by "/", e.g. usd/hkd, btc/usdt, bac001/bac002
        // Pair is the key index hence is unique
        bytes32 pair;
        // Rates Numerator in uint256 manner。 Can store multiple values。
        uint256[] rateN;
        // Rates Denominator in uint256 manner. If this is 1, then the numerator will be of default base value
        uint256[] rateD;
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
        uint256[] memory rateNval,
        uint256[] memory rateDval,
        uint256 timestampval,
        bytes32[] memory extraval
    )
        public
        onlyOwner
        returns (uint256)
    {
        // Permission check
        // Param validity check
        if (pairval == bytes32(0) || timestampval == uint256(0)) {
            emit setExchangeRateLog(RET_ILLEGAL_INPUT, tx.origin, pairval);
            return RET_ILLEGAL_INPUT;
        }
        // biz logic
        if (exchangeRates[pairval].timestamp == uint256(0)) {
            // a new rate pair, record it
            exchangeRatePairs.push(pairval);
        }
        ExchangeRate memory exchangeRate = ExchangeRate(pairval, rateNval, rateDval, timestampval, extraval);
        exchangeRates[pairval] = exchangeRate;
        emit setExchangeRateLog(RET_SUCCESS, tx.origin, pairval);
        return RET_SUCCESS;
    }

    // get single
    function getExchangeRate(bytes32 pairval)
        public
        view
        returns (bytes32, uint256[], uint256[], uint256, bytes32[])
    {
        return (pairval, exchangeRates[pairval].rateN, exchangeRates[pairval].rateD, exchangeRates[pairval].timestamp, exchangeRates[pairval].extra);
    }
}