pragma solidity ^0.4.25;

contract CallbackHandler {
    // Simple return
    function processCallback(bytes reply) public view returns (bytes) {
        return reply;
    }
}