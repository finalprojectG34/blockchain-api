pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {

  function testUserSignUpDeployedContract() {
    SupplyChain supplyChain = SupplyChain(DeployedAddresses.SupplyChain());

    string memory _mongoId = "user1";
    string memory _name = "Nati";
    string memory _email = "nathnael@gmail.com";
    string memory _deliveryAddress = "addis ababa";

    supplyChain.userSignUp(_mongoId, _name, _email, _deliveryAddress);

    Assert.equal(supplyChain.getUserByAddress(tx.origin).mongoId, _mongoId, "Mongo Id not the same");
    Assert.equal(supplyChain.getUserByAddress(tx.origin)._name, _name, "_name not the same");
    Assert.equal(supplyChain.getUserByAddress(tx.origin)._email, _email, "_email not the same");
    Assert.equal(supplyChain.getUserByAddress(tx.origin)._deliveryAddress, _deliveryAddress, "_deliveryAddress not the same");
  }

  function testUserSignUpWithNewSupplyChain() {
    SupplyChain supplyChain = new SupplyChain();

    string memory _mongoId = "user2";
    string memory _name = "Biruk";
    string memory _email = "bura@gmail.com";
    string memory _deliveryAddress = "Jemmo";

    supplyChain.userSignUp(_mongoId, _name, _email, _deliveryAddress);

    Assert.equal(supplyChain.getUserByAddress(tx.origin).mongoId, _mongoId, "Mongo Id not the same");
    Assert.equal(supplyChain.getUserByAddress(tx.origin)._name, _name, "_name not the same");
    Assert.equal(supplyChain.getUserByAddress(tx.origin)._email, _email, "_email not the same");
    Assert.equal(supplyChain.getUserByAddress(tx.origin)._deliveryAddress, _deliveryAddress, "_deliveryAddress not the same");
  }

//buyProduct(string memory _productId)
//cancelOrder(string memory _productId, uint _purchaseId)
//changeProductAvailability(string memory productId, bool _available)
//updateShipment(uint _purchaseId, string memory _newShipmentStatus)
//getProductHistory(string memory _productId) public view returns(History[] memory)
//getUserOrders() public view returns(UserOrders[] memory)
//getUserOrderDetail (uint _index) public view returns (string memory, string memory, uint, string memory)
//getPlacedOrders() public view returns (OrdersPlaced[] memory)
//getPlacedOrderDetail(uint _index) public view returns (string memory, uint, address, string memory)
//getShipments() public view returns(SellerShipment[] memory)
//getShipmentDetails(uint _purchaseId) public view returns(string memory, string memory, address, string memory)
//getAllProducts() public view returns (Pro[] memory)
//getAllUser() public view returns (Usr[] memory)
//getProductById(string memory _productId) public view returns (Product memory)
//getUserByAddress(address _userId) public view returns (User memory)
}
