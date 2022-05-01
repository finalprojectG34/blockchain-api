// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    /*
    The owner of the contract is the deployer
    */
    address public _owner;
    // address payable public owner;

    /*
    Set owner of the contract to the deployer
    */
    constructor() {
        _owner = msg.sender;
    }

    uint id;
    uint purchaseId;

    /*
    Any registered user can sell and buy a product
    */
    struct User {
        string name;
        string email;
        address addr;
        string deliveryAddress;
        string role;
        uint createdAt;
        uint updatedAt;
        bool isCreated;
    }

    struct Product {
        string productId;
        string productName;
        string Category;
        uint price;
        string description;
        address owner;
        bool isAvailable;
        bool isCreated;
    }

    struct OrdersPlaced {
        string productId;
        uint purchaseId;
        address orderedBy;
    }

    struct SellerShipment {
        string productId;
        uint purchaseId;
        string shipmentStatus;
        string deliveryAddress;
        address orderedBy;
        bool isActive;
        bool isCanceled;
    }

    struct Orders {
        string productId;
        string orderStatus;
        uint purchaseId;
        string shipmentStatus;
    }

    struct History{
        address prevOwner;
        //item information at the time of purchase
        uint transferDate;
    }

    mapping (address => User) users;
    address[] public allUsers;
    mapping (string => Product) products;
    string[] public allProducts;
    mapping (address => OrdersPlaced[]) sellerOrders;
    mapping (address => mapping(uint => SellerShipment)) sellerShipments;
    mapping (address => uint[]) purchaseIds;
    mapping (address => Orders[]) userOrders;
    mapping (string => History[]) productHistories;

    function userSignUp(string memory _name, string memory _email, string memory _deliveryAddress) public { //payable
        require(!users[msg.sender].isCreated, "You are Already Registered");

        // owner.transfer(msg.value);
        User memory user = users[msg.sender];
        user.name = _name;
        user.email = _email;
        user.deliveryAddress = _deliveryAddress;
        user.addr = msg.sender;
        user.isCreated = true;
        allUsers.push(msg.sender);
    }

    function addProduct(string memory _productId, string memory _productName, string memory _category, uint _price, string memory _description) public {
        require(users[msg.sender].isCreated, "You are not Registered as Seller");
        require(users[msg.sender].isCreated, "You are not Registered as Seller"); //check user role
        require(!products[_productId].isCreated, "Product With this Id is already Active. Use other UniqueId");

        Product memory product = products[_productId];
        product.productId = _productId;
        product.productName = _productName;
        product.Category = _category;
        product.description = _description;
        product.price = _price;
        product.owner = msg.sender;
        product.isAvailable = false;
        product.isCreated = true;
        allProducts.push(_productId);
    }

    function buyProduct(string memory _productId) public { //payable
        require(users[msg.sender].isCreated, "You Must Be Registered to Buy");

        // products[_productId].seller.transfer(msg.value);

        purchaseId = id++;

        OrdersPlaced memory ord = OrdersPlaced(_productId, purchaseId, msg.sender);
        sellerOrders[products[_productId].owner].push(ord);

        SellerShipment memory sellerShipment = sellerShipments[products[_productId].owner][purchaseId];
        sellerShipment.shipmentStatus = "initial shipment status";
        sellerShipment.productId = _productId;
        sellerShipment.orderedBy = msg.sender;
        sellerShipment.purchaseId = purchaseId;
        sellerShipment.deliveryAddress = users[msg.sender].deliveryAddress;
        sellerShipment.isActive = true;
        purchaseIds[products[_productId].owner].push(purchaseId);

        Orders memory order = Orders(_productId, "Order Placed With Seller", purchaseId, sellerShipment.shipmentStatus);
        userOrders[msg.sender].push(order);
    }

    function cancelOrder(string memory _productId, uint _purchaseId) public payable {
        SellerShipment memory sellerShipment = sellerShipments[products[_productId].owner][_purchaseId];

        require(sellerShipment.orderedBy == msg.sender, "You are not Authorized to This Product PurchaseId!");
        require(sellerShipment.isActive, "You Already Canceled This order!");

        sellerShipment.shipmentStatus = "Order Canceled By Buyer, Payment will Be  Refunded";
        sellerShipment.isCanceled = true;
        sellerShipment.isActive = false;
    }

    function updateShipment(uint _purchaseId, string memory _newShipmentStatus) public {
        require(sellerShipments[msg.sender][_purchaseId].isActive, "Order is either inActive or cancelled");
        sellerShipments[msg.sender][_purchaseId].shipmentStatus = _newShipmentStatus;

        //if status id delivered
        if (compareStrings(_newShipmentStatus,"delivered")) {
            string memory product_id = sellerShipments[msg.sender][_purchaseId].productId;
            products[product_id].owner = sellerShipments[msg.sender][_purchaseId].orderedBy;
            History memory history = History(msg.sender, block.timestamp);
            productHistories[product_id].push(history);
        }
    }

    // function refund(string memory _productId, uint _purchaseId) public { //payable
    //     require (sellerShipments[msg.sender][_purchaseId].isCanceled, "Order is not Yet Cancelled");
    //     require (!sellerShipments[products[_productId].seller][purchaseId].isActive,"Order is Active and not yet Cancelled");
    //     // require(msg.value==products[_productId].price,"Value Must be Equal to Product Price");
    //     // sellerShipments[msg.sender][_purchaseId].orderedBy.transfer(msg.value);
    //     sellerShipments[products[_productId].seller][_purchaseId].shipmentStatus= "Order Canceled By Buyer, Payment Refunded";
    // }

    function getProductHistory(string memory _productId) public view returns(History[] memory) {
        return productHistories[_productId];
    }

    function getUserOrders() public view returns(Orders[] memory) {
        return userOrders[msg.sender];
    }

    function getUserOrderDetail (uint _index) public view returns (string memory, string memory, uint, string memory) {
        return (
        userOrders[msg.sender][_index].productId,
        userOrders[msg.sender][_index].orderStatus,
        userOrders[msg.sender][_index].purchaseId,
        sellerShipments[products[userOrders[msg.sender][_index].productId].owner][userOrders[msg.sender][_index].purchaseId].shipmentStatus
        );
    }

    function getPlacedOrders() public view returns (OrdersPlaced[] memory) {
        return sellerOrders[msg.sender];
    }

    function getPlacedOrderDetail(uint _index) public view returns (string memory, uint, address, string memory) {
        return (
        sellerOrders[msg.sender][_index].productId,
        sellerOrders[msg.sender][_index].purchaseId,
        sellerOrders[msg.sender][_index].orderedBy,
        sellerShipments[msg.sender][sellerOrders[msg.sender][_index].purchaseId].shipmentStatus
        );
    }

    function getShipments() public view returns(SellerShipment[] memory) {
        SellerShipment[] memory shipments = new SellerShipment[](purchaseIds[msg.sender].length);
        for(uint i = 0; i < purchaseIds[msg.sender].length; i++) {
            shipments[i] = sellerShipments[msg.sender][purchaseIds[msg.sender][i]];
        }
        return shipments;
    }

    function getShipmentDetails(uint _purchaseId) public view returns(string memory, string memory, address, string memory) {
        return (
        sellerShipments[msg.sender][_purchaseId].productId,
        sellerShipments[msg.sender][_purchaseId].shipmentStatus,
        sellerShipments[msg.sender][_purchaseId].orderedBy,
        sellerShipments[msg.sender][_purchaseId].deliveryAddress
        );
    }

    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}