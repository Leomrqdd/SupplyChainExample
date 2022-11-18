// SPDX-Licence-Identifier : MIT

pragma solidity 0.8.17;


contract Ownable {

    address public _owner ;

    constructor() {
        _owner = msg.sender;
  }

    function isOwner() public view returns (bool) {
        return (msg.sender ==_owner);
    }

    modifier onlyOwner() {
        require(isOwner(), "You are not the owner");
        _;
    }

}
