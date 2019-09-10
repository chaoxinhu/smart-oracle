pragma solidity ^0.4.25;

/** 
 * Organizational view data store. Organizational view data will be uploaded into
 * this datastore, e.g. exchangeRates etc.
 */
contract OrgDatastore is Datastore {
    // Base rate when denominator is 1, which means the precision can be up to 1/RATE_BASE
    uint256 public constant RATE_BASE = 100000;

    struct ExchangeRate {
        // The asset pair, separated by "/", e.g. usd/hkd, btc/usdt, bac001/bac002
        // Pair is the key index hence is unique
        bytes32 pair;
        // Rates Numerator in uint256 manner。 Can store multiple values。
        // uint256 rateN;
        uint256[] rateN;
        // Rates Denominator in uint256 manner. If this is 1, then the numerator will be of default base value
        uint256[] rateD;
        // The exact timestamp 
        uint256 timestamp;
        // Extra values
        bytes32[] extra;
    }

    // key: asset pair name, value: actual exchangeRate struct; list for counting and indexing purpose
    mapping (bytes32 => ExchangeRate) private exchangeRateMap;
    bytes32[] private exchangeRateList;
}