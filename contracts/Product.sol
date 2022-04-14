// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./Library.sol";

contract Product is Ownable {

    string id;
    string name;
    uint price;
    //other item information
    Library.State productState = Library.State.CREATED;
    History[] histories;

    struct History{
        address owner;
        //item information at the time of purchase
        uint transferDate;
    }

    constructor(string memory _id, string memory _name, uint _price){
        id = _id;
        name = _name;
        price = _price;
    }

    function getId() public view returns(string memory){
        return id;
    }

    function getName() public view returns(string memory){
        return name;
    }

    function getPrice() public view returns(uint){
        return price;
    }

    function getHistory() public view returns(History[] memory){
        return histories;
    }

    function addToHistory(address prevOwner) private {
        histories.push(History(prevOwner, block.timestamp)) ;
    }

    function transferProductOwner(address newOwner) public {
        address prevOwner = owner();
        transferOwnership(newOwner);
        require(owner() == newOwner);
        addToHistory(prevOwner);
    }

}