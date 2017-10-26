const FanToken = artifacts.require("./FanToken.sol");
const CrowdsaleController = artifacts.require("./CrowdsaleController");

module.exports = async (deployer) => {
  await deployer.deploy(FanToken);
  deployer.deploy(CrowdsaleController, FanToken.address, 0x0);
};
