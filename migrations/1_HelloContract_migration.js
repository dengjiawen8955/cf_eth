const HelloContract = artifacts.require("Crowdfunding.sol");

module.exports = function (deployer) {
  deployer.deploy(HelloContract);
};