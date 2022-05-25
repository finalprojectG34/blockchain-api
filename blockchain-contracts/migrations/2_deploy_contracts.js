const Library = artifacts.require("Library");
const SupplyChain = artifacts.require("SupplyChain");
const ProductContract = artifacts.require("ProductContract");
const UserContract = artifacts.require("UserContract");

module.exports = function(deployer) {
  deployer.deploy(Library);
  deployer.link(Library, SupplyChain);
  deployer.link(Library, ProductContract);
  deployer.link(Library, UserContract);
  deployer.deploy(SupplyChain).then(function () {
    return deployer.deploy(ProductContract, SupplyChain.address).then(function () {
      return deployer.deploy(UserContract, SupplyChain.address)
    })
  });
};
