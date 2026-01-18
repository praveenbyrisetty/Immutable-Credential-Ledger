const ElimuChain = artifacts.require("ElimuChain");

module.exports = function (deployer) {
  deployer.deploy(ElimuChain);
};