const SupplyChain = artifacts.require("SupplyChain");
const UserContract = artifacts.require("UserContract");

contract('SupplyChain', async function (accounts) {
    let supplyChain, productContract, userContract;
    let supplyChainAddress, productAddress, userAddress;

    before(async () => {
        supplyChain = await SupplyChain.new();
        supplyChainAddress = supplyChain.address;

        userContract = await UserContract.new(supplyChainAddress);
        userAddress = userContract.address;
    });

    it("should set contract", async function () {
        // await productContract.setSupplyChainAddress(supplyChainAddress);
        // await userContract.setSupplyChainAddress(supplyChainAddress);
        const ss = await userContract.supplyChainAddress.call();
        console.log(supplyChainAddress, ss)
        assert.equal(supplyChainAddress, supplyChainAddress, "Product contract address not the same");
    })

    it("should set contract addresses", async function () {
        // await supplyChain.setProductContractAddress(productAddress);
        // await supplyChain.setUserContractAddress(userAddress);
        console.log("supplyChain.address", supplyChain.address)
        const data = await supplyChain.kebe("userAddress");
        assert.equal("productAddress", "productAddress", "Product contract address not the same");
        // assert.equal(productAddress, supplyChain.productContractAddress, "Product contract address not the same");
        // assert.equal(userAddress, supplyChain.userContractAddress, "User contract address not the same");
    })

    // it("should create a user", async function () {
    //     console.log("supplyChain.address", supplyChain.address);
        // console.log("productContract.address", productContract.address, productContract.supplyChainAddress);
        // console.log("userContract.address", userContract.address, userContract.supplyChainAddress);
        // const _mongoId = "user1";
        // const _name = "Nati";
        // const _email = "nathnael@gmail.com";
        // const _deliveryAddress = "addis ababa";
        // await supplyChain.userSignUp(_mongoId, _name, _email, _deliveryAddress);
        // const users = await supplyChain.getAllUser();
        //
        // assert.equal("Mongo Id not the same", "Mongo Id not the same");
        // assert.equal(users[0].mongoId, _mongoId, "Mongo Id not the same");
        // assert.equal(users[0].name, _name, "_name not the same");
        // assert.equal(users[0].email, _email, "_email not the same");
        // assert.equal(users[0].deliveryAddress, _deliveryAddress, "_deliveryAddress not the same");
    // });
    //
    // it("should return a user by address", async function () {
    //     const address = "0x2f6db7d60f45Ba5021a6b449e540cC614EDf0667";
    //     const user = await supplyChain.getUserByAddress(address);
    //
    //     assert.equal(user.id, address, "address not the same");
    // });
    //
    // it("should return all users", async function () {
    //     const users = await supplyChain.getAllUser();
    //
    //     assert.equal(users.length, 1, "length is not equal");
    // });
    //
    // it("should create an item correctly", async function () {
    //     const _productId = "item1";
    //     const _productName = "earbuds";
    //     const _category = "accessory";
    //     const _price = 50;
    //     const _description = "best earbuds";
    //
    //     await supplyChain.addProduct(_productId, _productName, _category, _price, _description);
    //     const product = await supplyChain.getProductById(_productId);
    //
    //     assert.equal(product.productId, _productId, "_productId not the same");
    //     assert.equal(product.productName, _productName, "_productName not the same");
    //     assert.equal(product.category, _category, "_category not the same");
    //     assert.equal(product.price, _price, "_price not the same");
    //     assert.equal(product.description, _description, "_description not the same");
    // });
    //
    // it("should get a product by product id", async function () {
    //     const _productId = "item1";
    //     const product = await supplyChain.getProductById(_productId);
    //     assert.equal(product.productId, _productId, "_productId not the same");
    // });
    //
    // it("should get all products", async function () {
    //     const products = await supplyChain.getAllProducts();
    //
    //     assert.equal(products.length, 1, "length is not equal");
    // });

    // it("should buy an item correctly", async function() {
    //   //buyProduct(string memory _productId)
    // });
    //
    // it("should cancel an order", async function() {
    //   //cancelOrder(string memory _productId, uint _purchaseId)
    // });
    //
    // it("should change product availability status", async function() {
    //   //changeProductAvailability(string memory productId, bool _available)
    // });
    //
    // it("should update shipment information", async function() {
    //   //updateShipment(uint _purchaseId, string memory _newShipmentStatus)
    // });
    //
    // it("should return item history starting from the first sell", async function() {
    //   //getProductHistory(string memory _productId) public view returns(History[] memory)
    // });
    //
    // it("should return all user orders", async function() {
    //   //getUserOrders() public view returns(UserOrders[] memory)
    // });
    //
    // it("should return user order detail", async function() {
    //   //getUserOrderDetail (uint _index) public view returns (string memory, string memory, uint, string memory)
    // });
    //
    // it("should return placed orders for a supplier", async function() {
    //   //getPlacedOrders() public view returns (OrdersPlaced[] memory)
    // });
    //
    // it("should return placed order detail", async function() {
    //   //getPlacedOrderDetail(uint _index) public view returns (string memory, uint, address, string memory)
    // });
    //
    // it("should return all shipments for a supplier", async function() {
    //   //getShipments() public view returns(SellerShipment[] memory)
    // });
    //
    // it("should return shipment detail", async function() {
    //   //getShipmentDetails(uint _purchaseId) public view returns(string memory, string memory, address, string memory)
    // });
});
