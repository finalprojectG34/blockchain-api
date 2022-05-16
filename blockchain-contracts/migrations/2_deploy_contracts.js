// const Library = artifacts.require("../contracts/Library.sol");
const SupplyChain = artifacts.require("../contracts/SupplyChain.sol");

module.exports = function(deployer) {
  // deployer.deploy(Library);
  // deployer.link(Library, SupplyChain);
  deployer.deploy(SupplyChain);
};
