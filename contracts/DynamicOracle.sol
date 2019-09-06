pragma solidity ^0.4.25;

import "./CallbackHandler.sol";

contract DynamicOracle {
    // The dynamic oracle example

    private address callbackHanderAddress;

    private uint256 currentId = 0;

    // Only a single reply - keep the Oracle simple!
    private bytes latestReply;

    // All query event records
    event queryRequest(address account, uint256 id, bytes request);
    // ALL callback event records
    event callbackReply(uint256 id, bytes reply);

    function query(bytes request) public returns (uint256) {
        currentId++;
        emit queryRequest(tx.origin, request, currentId);
        return currentId;
    }

    function getResult() public view returns (uint256) {
        return latestReply;
    }

    function setCallbackHandlerAddress(address addr) public {
        callbackHanderAddress = addr;
    }

    function callback(uint256 id, bytes reply) external {
        // called by external source
        // sender verification needed
        latestReply = reply;
        emit callbackReply(id, reply);
        if (callbackHanderAddress != 0x0) {
            CallbackHandler handler = CallbackHandler(callbackHanderAddress);
            handler.processCallback(reply);
        }
    }
}