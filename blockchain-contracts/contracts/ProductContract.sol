// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Library.sol";

contract ProductContract {
    /*
        The owner of the contract is the deployer
    */
    address _owner;
    address public supplyChainAddress;
    // address payable public owner;

    /*
        Set owner of the contract to the deployer
    */
    constructor(address add) {
        _owner = msg.sender;
        supplyChainAddress = add;
    }

    function setSupplyChainAddress(address add) external {
        require(msg.sender == _owner, "Unauthorized access!");
        supplyChainAddress = add;
    }

    uint id;
    uint purchaseId;
    uint productId;

    /*
        Item fields
    */
    struct Product {
        uint productId;
        string mongoId;
        string productName;
        string category;
        uint price;
        string description;
        address owner;
        bool isAvailable;
        bool isCreated;
        uint createdAt;
        uint updatedAt;
    }
    struct ProductView {
        uint productId;
        string mongoId;
        string name;
        uint price;
        string category;
        string description;
        address owner;
    }

    struct History{
        address prevOwner;
        uint productId;
        string mongoId;
        string productName;
        string category;
        uint price;
        string description;
        uint transferDate;
    }

    struct OrderShipment {
        uint purchaseId;
        uint productId;
        string mongoId;
        string shipmentStatus;
        string deliveryAddress;
        address orderedBy;
        bool isConfirmed;
        bool isActive;
        bool isCanceled;
        uint createdAt;
        uint updatedAt;
    }

    struct ShipmentHistory{
        string location;
        string description;
        uint arrivedAt;
        uint sentAt;
    }

    mapping (uint => Product) products;
    mapping (address => uint[]) ownerProducts;
    //Product Id mapped to an array of productHistories
    mapping (uint => History[]) productHistories;
    string[] public allProducts;
    mapping (uint => OrderShipment) orderShipments;
    mapping (address => uint[]) userPurchaseIds;
    mapping (address => uint[]) sellerPurchaseIds;
    mapping (uint => ShipmentHistory[]) shipmentHistoryHistories;

    function addProduct(
        string memory _mongoId,
        string memory _productName,
        string memory _category,
        uint _price,
        string memory _description,
        uint _instanceNumber,
        address productOwner
    ) external {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        // require(users[msg.sender].isCreated, "You are not Registered as Seller"); //check user role

        for (uint i = 0; i < _instanceNumber; i++){
            Product memory product = Product(
                productId,
                _mongoId,
                _productName,
                _category,
                _price,
                _description,
                productOwner,
                true,
                true,
                block.timestamp,
                block.timestamp
            );

            products[productId] = product;
            ownerProducts[productOwner].push(productId);
            productId += 1;
        }
    }

    function getSingleProductById(uint _productId) external view returns (Product memory){
        Product memory res = products[_productId];
        return res;
    }

    function getAllProducts() external view returns (ProductView[] memory){
        ProductView[] memory res = new ProductView[](productId);
        for(uint i = 0; i < productId; i++) {
            string memory mongoId = products[i].mongoId;
            uint product_id = products[i].productId;
            string memory name = products[i].productName;
            uint price = products[i].price;
            string memory category = products[i].category;
            string memory description = products[i].description;
            address productOwner = products[i].owner;
            res[i] = ProductView(product_id, mongoId, name, price, category, description, productOwner);
        }
        return res;
    }

    function getUserProducts(address _productOwner) external view returns (ProductView[] memory){
        require(msg.sender == supplyChainAddress, "Unauthorized access!");

        uint[] memory op = ownerProducts[_productOwner];
        ProductView[] memory res = new ProductView[](op.length);
        for(uint i = 0; i < op.length; i++) {
            string memory mongoId = products[op[i]].mongoId;
            uint product_id = products[op[i]].productId;
            string memory name = products[op[i]].productName;
            uint price = products[op[i]].price;
            string memory category = products[op[i]].category;
            string memory description = products[op[i]].description;
            address productOwner = products[op[i]].owner;
            res[i] = ProductView(product_id, mongoId, name, price, category, description, productOwner);
        }
        return res;
    }

    function getProductHistory(uint _productId) external view returns(History[] memory) {
        return productHistories[_productId];
    }

    function changeProductAvailability(uint _productId, bool _available, address productOwner) external {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(products[_productId].isCreated, "Product does not exist!");
        require(products[_productId].owner == productOwner, "Access denied!");
        products[_productId].isAvailable = _available;
    }

    function buyProduct(uint _productId, address buyerAddress, string memory buyerDeliveryAddress) external { //payable
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(products[_productId].isCreated, "Item does not exist!");
        require(products[_productId].isAvailable, "Item is not available for sell.");
        require(products[_productId].owner != buyerAddress, "You Can not buy your own Item!");
        // products[_productId].seller.transfer(msg.value);

        purchaseId = id++;

        OrderShipment memory order = OrderShipment(
            purchaseId,
            _productId,
            products[_productId].mongoId,
            "initial shipment status",
            buyerDeliveryAddress,
            buyerAddress,
            false,
            true,
            false,
            block.timestamp,
            block.timestamp
        );
        orderShipments[purchaseId] = order;

        userPurchaseIds[buyerAddress].push(purchaseId);
        sellerPurchaseIds[products[_productId].owner].push(purchaseId);
    }

    function getUserOrders(address userAddress) external view returns(OrderShipment[] memory) {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");

        uint[] memory purchaseIds = userPurchaseIds[userAddress];
        OrderShipment[] memory orders = new OrderShipment[](purchaseIds.length);
        for(uint i = 0; i < purchaseIds.length; i++){
            orders[i] = orderShipments[purchaseIds[i]];
        }
        return orders;
    }

    function getUserPurchaseId(uint _purchaseId, address userAddress) private view returns (bool) {
        uint[] memory purchaseIds = userPurchaseIds[userAddress];
        for(uint i = 0; i < purchaseIds.length; i++){
            if (purchaseIds[i] == _purchaseId){
                return true;
            }
        }
        return false;
    }

    function getUserOrderDetail (uint _purchaseId, address userAddress) external view returns (OrderShipment memory) {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");

        require(getUserPurchaseId(_purchaseId, userAddress), "Purchase Id does not exist");
        return orderShipments[_purchaseId];
    }

    function getSellerOrders(address sellerAddress) external view returns (OrderShipment[] memory) {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");

        uint[] memory purchaseIds = sellerPurchaseIds[sellerAddress];
        OrderShipment[] memory orders = new OrderShipment[](purchaseIds.length);
        for(uint i = 0; i < purchaseIds.length; i++){
            orders[i] = orderShipments[purchaseIds[i]];
        }
        return orders;
    }

    function getSellerPurchaseId(uint _purchaseId, address sellerAddress) private view returns (bool) {
        uint[] memory purchaseIds = sellerPurchaseIds[sellerAddress];
        for(uint i = 0; i < purchaseIds.length; i++){
            if (purchaseIds[i] == _purchaseId){
                return true;
            }
        }
        return false;
    }

    function getSellerOrderDetail (uint _purchaseId, address sellerAddress) external view returns (OrderShipment memory) {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(getSellerPurchaseId(_purchaseId, sellerAddress), "Purchase Id does not exist");
        return orderShipments[_purchaseId];
    }

    function updateShipmentStatus(
        uint _purchaseId,
        string memory _newShipmentStatus,
        address deliveryUserAddress,
        address sellerAddress,
        string memory deliveryUserRole
    ) external {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(getSellerPurchaseId(_purchaseId, sellerAddress), "Purchase Id does not exist");
        require(orderShipments[_purchaseId].isActive, "Order is either inActive or cancelled");
        require(Library.compareStrings(deliveryUserRole, "DELIVERY"), "User is not registered as a delivery agent.");

        OrderShipment memory shipment = orderShipments[_purchaseId];
        orderShipments[_purchaseId].shipmentStatus = _newShipmentStatus;

        uint product_id = shipment.productId;
        //if status id delivered
        if (Library.compareStrings(_newShipmentStatus, "DELIVERED")) {
            products[product_id].owner = shipment.orderedBy;
        } else {
            products[product_id].owner = deliveryUserAddress;
            sellerPurchaseIds[deliveryUserAddress].push(_purchaseId);
        }

        Product memory product = products[product_id];

        string memory mongoId = product.mongoId;
        string memory productName = product.productName;
        string memory category = product.category;
        uint price = product.price;
        string memory description = product.description;

        History memory history = History(
            sellerAddress,
            product_id,
            mongoId,
            productName,
            category,
            price,
            description,
            block.timestamp
        );
        productHistories[product_id].push(history);
    }

    function confirmUserOrder (uint _purchaseId, address userAddress) external {
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(getUserPurchaseId(_purchaseId, userAddress), "Purchase Id does not exist");
        orderShipments[_purchaseId].isConfirmed = true;
    }

    function cancelOrder(uint _purchaseId, address userAddress) external { //payable
        require(msg.sender == supplyChainAddress, "Unauthorized access!");
        require(
            getUserPurchaseId(_purchaseId, userAddress) ||
            getSellerPurchaseId(_purchaseId, userAddress),
            "Purchase Id does not exist"
        );
        require(!orderShipments[_purchaseId].isActive, "You Already Canceled This order!");
        require(!Library.compareStrings(orderShipments[_purchaseId].shipmentStatus, "initial shipment status"),
            "You Already Canceled This order!");

        orderShipments[_purchaseId].isActive = false;
    }
}