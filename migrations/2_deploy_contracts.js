var MyContract = artifacts.require("MyContract");
const biconomyForwarder = require("../relayer/biconomyForwarder.json");

module.exports = function (deployer, network) {
  const getBiconomyForwarderByNetwork = biconomyForwarder[network];
  if (getBiconomyForwarderByNetwork) {
    deployer.deploy(MyContract, getBiconomyForwarderByNetwork);
  } else {
    console.log("No Biconomy Forwarder Found in the desired network!");
  }
};