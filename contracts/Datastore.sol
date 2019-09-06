pragma solidity ^0.4.25;

// Basic datastore adapter - ready for inheritance by other specific datastore impl
//  e.g. shrinking feature etc.
// Actual format TBD
contract Datastore {
    mapping (bytes32 => bytes) private map;

    function get(bytes32 id) public view returns (bytes) {
        return map[id];
    }

    function put(bytes32 id, bytes value) public {
        map[id] = value;
    }
}