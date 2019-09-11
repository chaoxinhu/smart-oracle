pragma solidity ^0.4.25;

/** 
 * Datastore factory - serves as all datastore factory class with necessary logic e.g. roles assigner.
 */
 import "./ExchangeRateData.sol";

contract DataFactory {
    // RetCodes
    uint256 constant private RET_SUCCESS = 0;
    uint256 constant private RET_ILLEGAL_INPUT = 500001;

    // data content
    uint256 constant private EXCHANGE_RATE = 0;

    // Events
    event CreateDatastoreLog(uint256 retCode, uint256 content, address addr, address from);

    function createDataContract(uint256 content) public returns (bool) {
        if (content == EXCHANGE_RATE) {
            ExchangeRateData exchangeRateData = new ExchangeRateData();
            exchangeRateData.addOwner(tx.origin);
            // TODO in future add regulatory address
            emit CreateDatastoreLog(RET_SUCCESS, content, exchangeRateData, tx.origin);
            return true;
        }
        emit CreateDatastoreLog(RET_ILLEGAL_INPUT, content, 0x0, tx.origin);
        return false;
    }
}