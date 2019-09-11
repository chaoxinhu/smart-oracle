pragma solidity ^0.4.25;

/**
 * Library to handle ownership permissions. Allows multiple owners to a contract.
 */
contract Ownable {
    mapping(address => bool) private _owner;

    uint constant private ADD = 0;
    uint constant private REMOVE = 1;
    event modifyOwner(uint256 operation, address addr);

    constructor() internal {
        _owner[tx.origin] = true;
        emit modifyOwner(ADD, tx.origin);
    }

    modifier onlyOwner() {
        // move into RoleManager contract in future
        require(_owner[tx.origin], "500002: No permission");
        _;
    }

    function isOwner() public view returns (bool) {
        return _owner[tx.origin];
    }

    function addOwner(address addr) public onlyOwner {
        _owner[addr] = true;
        emit modifyOwner(ADD, addr);
    }

    function removeOwner(address addr) public onlyOwner {
        _owner[addr] = false;
        emit modifyOwner(REMOVE, addr);
    }
}