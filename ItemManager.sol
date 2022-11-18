// SPDX-Licence-Identifier : MIT

pragma solidity 0.8.17;
import "./Item.sol";
import "./Ownable.sol";



contract ItemManager is Ownable {

    enum SupplyChainSteps{Created,Paid,Delivered}

    struct S_Item {
         Item _item;
         ItemManager.SupplyChainSteps _step;
         string _identifier;

    }

    uint itemIndex;
    mapping(uint => S_Item) public items;

    event SupplyChainState(uint _itemIndex,uint _state, address _address);

   function createItem(string memory _identifier, uint _priceInWei) public onlyOwner {
        Item item = new Item(this,_priceInWei,itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._step = SupplyChainSteps.Created;
        emit SupplyChainState(itemIndex,uint(items[itemIndex]._step),address(item));
        itemIndex++;
   } 


    function triggerPayment(uint index) public payable {
         Item item = items[index]._item;
         require (address(item) == msg.sender, "only the item contract can trigger payment");
         require(item.priceInWei() == msg.value, "the price is not correct");
         require(items[index]._step == SupplyChainSteps.Created, "the Item is further in the process");
         items[index]._step = SupplyChainSteps.Paid;
         emit SupplyChainState(index,uint(items[index]._step), address(item));
    }


    function triggerDelivery(uint index) public onlyOwner {
         require(items[index]._step == SupplyChainSteps.Paid, "the Item is further in the process");
         items[index]._step = SupplyChainSteps.Delivered;
         emit SupplyChainState(index,uint(items[index]._step), address(items[index]._item));
    }







}
