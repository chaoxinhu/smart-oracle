pragma solidity ^0.4.25;

import "./OrgDatastore.sol";

contract Oracle {
    // key: org name, value: org datastore address
    mapping (bytes32 => address) private addrMap;

    function putDatastore(bytes32 id, address addr) public {
        addrMap[id] = addr;
    }

    function getDatastore(bytes32 id) public view returns (address) {
        return addrMap[id];
    }

    function query(bytes32 id, bytes32 request) public view returns (bytes32) {
        OrgDatastore datastore = OrgDatastore(addrMap[id]);
        return datastore.get(request);
    }
}