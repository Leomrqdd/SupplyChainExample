// SPDX-Licence-Identifier : MIT


pragma solidity 0.8.17;
import "./ItemManager.sol";

contract Item {

    uint public index;
    uint public priceInWei;
    uint public paidWei;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        parentContract = _parentContract;
        priceInWei = _priceInWei;
        index = _index;
    }


    receive() external payable {
        require(priceInWei == msg.value, "this is not the correct price");
        require(paidWei == 0, "the item is already paid ! ");
        paidWei += msg.value;
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require (success, "something wrong happened, canceling...");
    }


    fallback() external {
        
    }

}

