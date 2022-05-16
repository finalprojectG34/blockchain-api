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
        address id;
        string mongoId;
        string name;
        string email;
        string deliveryAddress;
        string role;
        bool isCreated;
        uint createdAt;
        uint updatedAt;
    }

    /*
        Item fields
    */
    struct Product {
        string productId;
        string productName;
        string Category;
        uint price;
        string description;
        address owner;
        bool isAvailable;
        bool isCreated;
        uint createdAt;
        uint updatedAt;
    }

    struct OrdersPlaced {
        string productId;
        uint purchaseId;
        address orderedBy;
        uint createdAt;
        uint updatedAt;
    }

    struct SellerShipment {
        string productId;
        uint purchaseId;
        string shipmentStatus;
        string deliveryAddress;
        address orderedBy;
        bool isActive;
        bool isCanceled;
        uint createdAt;
        uint updatedAt;
    }

    struct UserOrders {
        string productId;
        string orderStatus;
        uint purchaseId;
        string shipmentStatus;
        uint createdAt;
        uint updatedAt;
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
    mapping (address => UserOrders[]) userOrders;
    //Product Id mapped to an array of productHistories
    mapping (string => History[]) productHistories;

    function userSignUp(
        string memory _mongoId,
        string memory _name,
        string memory _email,
        string memory _deliveryAddress
    ) public returns (User memory) { //payable
        require(!users[msg.sender].isCreated, "You are Already Registered!");
        require(
            !compareStrings(_mongoId, "") ||
        !compareStrings(_name, "") ||
        !compareStrings(_email, ""),
            "Please fill in the required fields!"
        );

        // owner.transfer(msg.value);
        User memory user = User(
            msg.sender,
            _mongoId,
            _name,
            _email,
            _deliveryAddress,
            "User",
            true,
            block.timestamp,
            block.timestamp
        );

        users[msg.sender] = user;
        allUsers.push(msg.sender);
        return user;
    }

    function addProduct(
        string memory _productId,
        string memory _productName,
        string memory _category,
        uint _price,
        string memory _description
    ) public returns (Product memory) {
        require(users[msg.sender].isCreated, "You are not Registered as Seller!");
        // require(users[msg.sender].isCreated, "You are not Registered as Seller"); //check user role
        require(!products[_productId].isCreated, "Product With this Id is already Active. Use other UniqueId!");

        Product memory product = Product(
            _productId,
            _productName,
            _category,
            _price,
            _description,
            msg.sender,
            true,
            true,
            block.timestamp,
            block.timestamp
        );

        products[_productId] = product;
        allProducts.push(_productId);
        return product;
    }

    function buyProduct(string memory _productId) public { //payable
        require(users[msg.sender].isCreated, "You Must Be Registered to Buy!");
        require(products[_productId].isCreated, "Item does not exist!");
        require(products[_productId].isAvailable, "Item is not available for sell.");
        require(products[_productId].owner != msg.sender, "You Can not buy your own Item!");
        // products[_productId].seller.transfer(msg.value);

        purchaseId = id++;

        OrdersPlaced memory ord = OrdersPlaced(_productId, purchaseId, msg.sender,  block.timestamp, block.timestamp);
        sellerOrders[products[_productId].owner].push(ord);

        SellerShipment memory sellerShipment = SellerShipment(
            _productId,
            purchaseId,
            "initial shipment status",
            users[msg.sender].deliveryAddress,
            msg.sender,
            true,
            false,
            block.timestamp,
            block.timestamp
        );
        sellerShipments[products[_productId].owner][purchaseId] = sellerShipment;

        purchaseIds[products[_productId].owner].push(purchaseId);

        UserOrders memory order = UserOrders(
            _productId,
            "Order Placed With Seller",
            purchaseId,
            sellerShipment.shipmentStatus,
            block.timestamp,
            block.timestamp
        );
        userOrders[msg.sender].push(order);
    }

    function cancelOrder(string memory _productId, uint _purchaseId) public { //payable
        SellerShipment memory sellerShipment = sellerShipments[products[_productId].owner][_purchaseId];
        address owner = products[_productId].owner;
        require(!(sellerShipment.orderedBy == msg.sender)||!(owner == msg.sender), "You are not Authorized to cancel this Order!");
        require(!sellerShipment.isActive, "You Already Canceled This order!");

        sellerShipment.shipmentStatus = "Order Canceled By Buyer, Payment will Be  Refunded";
        sellerShipment.isCanceled = true;
        sellerShipment.isActive = false;
    }

    function changeProductAvailability(string memory productId, bool _available) public {
        require(products[productId].isCreated, "Product does not exist!");
        require(products[productId].owner == msg.sender, "Access denied!");
        products[productId].isAvailable = _available;
    }

    function updateShipment(uint _purchaseId, string memory _newShipmentStatus) public {
        require(sellerShipments[msg.sender][_purchaseId].isActive, "Order is either inActive or cancelled");
        sellerShipments[msg.sender][_purchaseId].shipmentStatus = _newShipmentStatus;

        //if status id delivered
        if (compareStrings(_newShipmentStatus, "delivered")) {
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

    function getUserOrders() public view returns(UserOrders[] memory) {
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

    struct Pro {
        string id;
        string name;
        address owner;
    }
    function getAllProducts() public view returns (Pro[] memory){
        Pro[] memory res = new Pro[](allProducts.length);
        for(uint i = 0; i < allProducts.length; i++) {
            string memory proid = products[allProducts[i]].productId;
            string memory name = products[allProducts[i]].productName;
            address proowner = products[allProducts[i]].owner;
            res[i] = Pro(proid, name, proowner);
        }
        return res;
    }

    function getProductById(string memory _productId) public view returns (Product memory){
        Product memory res = products[_productId];
        return res;
    }

    struct Usr {
        string mongoId;
        string name;
        address id;
    }
    function getAllUser() public view returns (Usr[] memory){
        Usr[] memory res = new Usr[](allUsers.length);
        for(uint i = 0; i < allUsers.length; i++) {
            string memory mongoId = users[allUsers[i]].mongoId;
            string memory name = users[allUsers[i]].name;
            address uid = users[allUsers[i]].id;
            res[i] = Usr(mongoId, name, uid);
        }
        return res;
    }

    function getUserByAddress(address _userId) public view returns (User memory){
        User memory res = users[_userId];
        return res;
    }

    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}