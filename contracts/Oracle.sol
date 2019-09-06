pragma solidity ^0.4.25;

import "./Datastore.sol";

contract Oracle {
    // The static oracle example

    mapping (bytes32 => address) private datastoreAddressMap;

    function putDatastore(bytes32 id, address addr) public {
        datastoreAddressMap[id] = addr;
    }

    function getDatastore(bytes32 id) public view returns (address) {
        return datastoreAddressMap[id];
    }

    function query(bytes32 id, bytes32 request) public view returns (uint256) {
        Datastore datastore = Datastore(datastoreAddressMap[id]);
        return datastore.get(request);
    }
}