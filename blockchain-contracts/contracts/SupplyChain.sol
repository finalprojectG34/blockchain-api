// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProductContract.sol";
import "./UserContract.sol";
import "./Library.sol";

contract SupplyChain {
    /*
        The owner of the contract is the deployer
    */
    address _owner;
    address public productContractAddress;
    address public userContractAddress;

    ProductContract product;
    UserContract user;
    // address payable public owner;

    /*
        Set owner of the contract to the deployer
    */
    constructor() {
        _owner = msg.sender;
    }

    uint id;
    uint purchaseId;
    uint productId;

    function setProductContractAddress(address add) external {
        require(msg.sender == _owner, "Unauthorized access!");
        product = ProductContract(add);
        productContractAddress = add;
    }

    function setUserContractAddress(address add) external {
        require(msg.sender == _owner, "Unauthorized access!");
        user = UserContract(add);
        userContractAddress = add;
    }

    function userSignUp(
        string memory _mongoId,
        string memory _name,
        string memory _email,
        string memory _deliveryAddress,
        string memory _role
    ) public {//payable
        user.userSignUp(
            _mongoId,
            _name,
            _email,
            _deliveryAddress,
            _role,
            msg.sender
        );
        //transfer some balance to the registered account
        //        _owner.transfer(10);
    }

    function getUserByAddress(address _userId) public view returns (UserContract.User memory){
        return user.getUserByAddress(_userId);
    }

    function getAllUser() public view returns (UserContract.UserView[] memory){
        return user.getAllUser();
    }

    function addProduct(
        string memory _mongoId,
        string memory _productName,
        string memory _category,
        uint _price,
        string memory _description,
        uint _instanceNumber
    ) public {
        require(user.getUserByAddress(msg.sender).isCreated, "You are not Registered as Seller!");
        // require(users[msg.sender].isCreated, "You are not Registered as Seller"); //check user role

        product.addProduct(
            _mongoId,
            _productName,
            _category,
            _price,
            _description,
            _instanceNumber,
            msg.sender
        );
    }

    function getSingleProductById(uint _productId) public view returns (ProductContract.Product memory){
        return product.getSingleProductById(_productId);
    }

    function getAllProducts() public view returns (ProductContract.ProductView[] memory){
        return product.getAllProducts();
    }

    function getUserProducts() public view returns (ProductContract.ProductView[] memory){
        return product.getUserProducts(msg.sender);
    }

    function getProductHistory(uint _productId) public view returns (ProductContract.History[] memory) {
        return product.getProductHistory(_productId);
    }

    function changeProductAvailability(uint _productId, bool _available) public {
        return product.changeProductAvailability(_productId, _available, msg.sender);
    }

    function buyProduct(uint _productId) public {//payable
        require(user.getUserByAddress(msg.sender).isCreated, "You Must Be Registered to Buy!");
        product.buyProduct(_productId, msg.sender, user.getUserByAddress(msg.sender).deliveryAddress);
    }

    function getUserOrders() public view returns (ProductContract.OrderShipment[] memory) {
        return product.getUserOrders(msg.sender);
    }

    function getUserOrderDetail(uint _purchaseId) public view returns (ProductContract.OrderShipment memory) {
        return product.getUserOrderDetail(_purchaseId, msg.sender);
    }

    function getSellerOrders() public view returns (ProductContract.OrderShipment[] memory) {
        return product.getSellerOrders(msg.sender);
    }

    function getSellerOrderDetail(uint _purchaseId) public view returns (ProductContract.OrderShipment memory) {
        return product.getSellerOrderDetail(_purchaseId, msg.sender);
    }

    function updateShipmentStatus(
        uint _purchaseId,
        string memory _newShipmentStatus,
        address deliveryUserAddress
    ) public {

        product.updateShipmentStatus(
            _purchaseId,
            _newShipmentStatus,
            deliveryUserAddress,
            msg.sender,
            user.getUserByAddress(deliveryUserAddress).role
        );
    }

    function confirmUserOrder(uint _purchaseId) public {
        product.confirmUserOrder(_purchaseId, msg.sender);
    }

    function cancelOrder(uint _purchaseId) public {//payable
        product.cancelOrder(_purchaseId, msg.sender);
    }

}