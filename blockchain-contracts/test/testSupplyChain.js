const SupplyChain = artifacts.require("SupplyChain");

contract('SupplyChain', async function(accounts) {
  let supplyChain;
  before(async () => {
    supplyChain = await SupplyChain.deployed();
  });

  it("should create a user", async function() {
    const _mongoId = "user1";
    const _name = "Nati";
    const _email = "nathnael@gmail.com";
    const _deliveryAddress = "addis ababa";
    const user = await supplyChain.userSignUp(_mongoId, _name, _email, _deliveryAddress);

    assert.equal(user.mongoId, _mongoId, "Mongo Id not the same");
    assert.equal(user.name, _name, "_name not the same");
    assert.equal(user.email, _email, "_email not the same");
    assert.equal(user.deliveryAddress, _deliveryAddress, "_deliveryAddress not the same");
  });

  it("should return a user by address", async function() {
    //getUserByAddress(address) public view returns (Usr[] memory)
  });

  it("should return all users", async function() {
    //getAllUser() public view returns (Usr[] memory)
  });

  it("should create an item correctly", async function() {
    const _productId = "item1";
    const _productName = "earbuds";
    const _category = "accessory";
    const _price = 50;
    const _description = "best earbuds";

    await supplyChain.addProduct(_productId, _productName, _category, _price, _description);
    const product = await supplyChain.getProductById(_productId);

    assert.equal(product.productId, _productId, "_productId not the same");
    assert.equal(product.productName, _productName, "_productName not the same");
    assert.equal(product.category, _category, "_category not the same");
    assert.equal(product.price, _price, "_price not the same");
    assert.equal(product.description, _description, "_description not the same");
  });

  it("should get a product by product id", async function() {
    //getProductById() public view returns (Pro[] memory)
  });

  it("should get all products", async function() {
    //getAllProducts() public view returns (Pro[] memory)
  });

  it("should buy an item correctly", async function() {
    //buyProduct(string memory _productId)
  });

  it("should cancel an order", async function() {
    //cancelOrder(string memory _productId, uint _purchaseId)
  });

  it("should change product availability status", async function() {
    //changeProductAvailability(string memory productId, bool _available)
  });

  it("should update shipment information", async function() {
    //updateShipment(uint _purchaseId, string memory _newShipmentStatus)
  });

  it("should return item history starting from the first sell", async function() {
    //getProductHistory(string memory _productId) public view returns(History[] memory)
  });

  it("should return all user orders", async function() {
    //getUserOrders() public view returns(UserOrders[] memory)
  });

  it("should return user order detail", async function() {
    //getUserOrderDetail (uint _index) public view returns (string memory, string memory, uint, string memory)
  });

  it("should return placed orders for a supplier", async function() {
    //getPlacedOrders() public view returns (OrdersPlaced[] memory)
  });

  it("should return placed order detail", async function() {
    //getPlacedOrderDetail(uint _index) public view returns (string memory, uint, address, string memory)
  });

  it("should return all shipments for a supplier", async function() {
    //getShipments() public view returns(SellerShipment[] memory)
  });

  it("should return shipment detail", async function() {
    //getShipmentDetails(uint _purchaseId) public view returns(string memory, string memory, address, string memory)
  });
});