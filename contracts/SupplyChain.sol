// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Product.sol";

contract SupplyChain {

    uint numberOfStores;
    uint numberOfProducts;

    struct Shop{
        string id;
        string name;
    }

    mapping(string => Shop) shops;

    mapping(string => Product) products;

    function createShop(string calldata id, string calldata name) public {
        shops[id] = Shop(id, name);
        numberOfStores++;
    }

    function createProduct(string calldata id, string calldata name, uint price) public{
        products[id] = new Product(id, name, price);
        numberOfProducts++;
    }

    function getProductById(string calldata id) public view returns(Product){
        return products[id];
    }

    function transferProduct(address receiver, string calldata productId) public {
        Product product = products[productId];
        product.transferProductOwner(receiver);
    }

}