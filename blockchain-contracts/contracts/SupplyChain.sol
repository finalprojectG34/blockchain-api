// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    /*
        The owner of the contract is the deployer
    */
    address _owner;
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
    struct UserView {
        string mongoId;
        string name;
        string email;
        string deliveryAddress;
        address id;
    }

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

    mapping (address => User) users;
    address[] public allUsers;
    mapping (uint => Product) products;
    mapping (address => uint[]) ownerProducts;
    //Product Id mapped to an array of productHistories
    mapping (uint => History[]) productHistories;
    string[] public allProducts;
    mapping (uint => OrderShipment) orderShipments;
    mapping (address => uint[]) userPurchaseIds;
    mapping (address => uint[]) sellerPurchaseIds;
    mapping (uint => ShipmentHistory[]) shipmentHistoryHistories;

    function userSignUp(
        string memory _mongoId,
        string memory _name,
        string memory _email,
        string memory _deliveryAddress
    ) public { //payable
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
    }

    function getUserByAddress(address _userId) public view returns (User memory){
        User memory res = users[_userId];
        return res;
    }

    function getAllUser() public view returns (UserView[] memory){
        UserView[] memory res = new UserView[](allUsers.length);
        for(uint i = 0; i < allUsers.length; i++) {
            string memory mongoId = users[allUsers[i]].mongoId;
            string memory name = users[allUsers[i]].name;
            string memory email = users[allUsers[i]].email;
            string memory deliveryAddress = users[allUsers[i]].deliveryAddress;
            address uid = users[allUsers[i]].id;
            res[i] = UserView(mongoId, name, email, deliveryAddress, uid);
        }
        return res;
    }

    function addProduct(
        string memory _mongoId,
        string memory _productName,
        string memory _category,
        uint _price,
        string memory _description,
        uint _instanceNumber
    ) public {
        require(users[msg.sender].isCreated, "You are not Registered as Seller!");
        // require(users[msg.sender].isCreated, "You are not Registered as Seller"); //check user role

        for (uint i = 0; i < _instanceNumber; i++){
            Product memory product = Product(
                productId,
                _mongoId,
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

            products[productId] = product;
            ownerProducts[msg.sender].push(productId);
            productId += 1;
        }
    }

    function getProductById(uint _productId) public view returns (Product memory){
        Product memory res = products[_productId];
        return res;
    }

    function getAllProducts() public view returns (ProductView[] memory){
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

    function getUserProducts() public view returns (ProductView[] memory){
        uint[] memory op = ownerProducts[msg.sender];
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

    function getProductHistory(uint _productId) public view returns(History[] memory) {
        return productHistories[_productId];
    }

    function changeProductAvailability(uint _productId, bool _available) public {
        require(products[_productId].isCreated, "Product does not exist!");
        require(products[_productId].owner == msg.sender, "Access denied!");
        products[_productId].isAvailable = _available;
    }

    function buyProduct(uint _productId) public { //payable
        require(users[msg.sender].isCreated, "You Must Be Registered to Buy!");
        require(products[_productId].isCreated, "Item does not exist!");
        require(products[_productId].isAvailable, "Item is not available for sell.");
        require(products[_productId].owner != msg.sender, "You Can not buy your own Item!");
        // products[_productId].seller.transfer(msg.value);

        purchaseId = id++;

        OrderShipment memory order = OrderShipment(
            purchaseId,
            _productId,
            products[_productId].mongoId,
            "initial shipment status",
            users[msg.sender].deliveryAddress,
            msg.sender,
            true,
            false,
            block.timestamp,
            block.timestamp
        );
        orderShipments[purchaseId] = order;

        userPurchaseIds[msg.sender].push(purchaseId);
        sellerPurchaseIds[products[_productId].owner].push(purchaseId);
    }

    function getUserOrders() public view returns(OrderShipment[] memory) {
        uint[] memory purchaseIds = userPurchaseIds[msg.sender];
        OrderShipment[] memory orders = new OrderShipment[](purchaseIds.length);
        for(uint i = 0; i < purchaseIds.length; i++){
            orders[i] = orderShipments[purchaseIds[i]];
        }
        return orders;
    }

    function getUserPurchaseId(uint _purchaseId) private view returns (bool) {
        uint[] memory purchaseIds = userPurchaseIds[msg.sender];
        for(uint i = 0; i < purchaseIds.length; i++){
            if (purchaseIds[i] == _purchaseId){
                return true;
            }
        }
        return false;
    }

    function getUserOrderDetail (uint _purchaseId) public view returns (OrderShipment memory) {
        require(getUserPurchaseId(_purchaseId), "Purchase Id does not exist");
        return orderShipments[_purchaseId];
    }

    function getSellerOrders() public view returns (OrderShipment[] memory) {
        uint[] memory purchaseIds = sellerPurchaseIds[msg.sender];
        OrderShipment[] memory orders = new OrderShipment[](purchaseIds.length);
        for(uint i = 0; i < purchaseIds.length; i++){
            orders[i] = orderShipments[purchaseIds[i]];
        }
        return orders;
    }

    function getSellerPurchaseId(uint _purchaseId) private view returns (bool) {
        uint[] memory purchaseIds = sellerPurchaseIds[msg.sender];
        for(uint i = 0; i < purchaseIds.length; i++){
            if (purchaseIds[i] == _purchaseId){
                return true;
            }
        }
        return false;
    }

    function getSellerOrderDetail (uint _purchaseId) public view returns (OrderShipment memory) {
        require(getSellerPurchaseId(_purchaseId), "Purchase Id does not exist");
        return orderShipments[_purchaseId];
    }

    function updateShipmentStatus(uint _purchaseId, string memory _newShipmentStatus) public {
        require(getSellerPurchaseId(_purchaseId), "Purchase Id does not exist");
        require(orderShipments[_purchaseId].isActive, "Order is either inActive or cancelled");

        OrderShipment memory shipment = orderShipments[_purchaseId];
        orderShipments[_purchaseId].shipmentStatus = _newShipmentStatus;

        //if status id delivered
        if (compareStrings(_newShipmentStatus, "delivered")) {
            uint product_id = shipment.productId;
            products[product_id].owner = shipment.orderedBy;

            Product memory product = products[product_id];

            string memory mongoId = product.mongoId;
            string memory productName = product.productName;
            string memory category = product.category;
            uint price = product.price;
            string memory description = product.description;

            History memory history = History(
                msg.sender,
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
    }

    function cancelOrder(uint _purchaseId) public { //payable
        require(
            getUserPurchaseId(_purchaseId) ||
            getSellerPurchaseId(_purchaseId),
            "Purchase Id does not exist"
        );
        require(!orderShipments[_purchaseId].isActive, "You Already Canceled This order!");
        require(!compareStrings(orderShipments[_purchaseId].shipmentStatus, "initial shipment status"),
            "You Already Canceled This order!");

        orderShipments[_purchaseId].isActive = false;
    }

    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}