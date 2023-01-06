const SingleCrowdfunding = artifacts.require("SingleCrowdfunding");

module.exports = function (deployer) {
  deployer.deploy(SingleCrowdfunding);
};