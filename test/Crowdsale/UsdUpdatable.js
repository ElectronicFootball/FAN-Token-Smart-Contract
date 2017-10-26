const FanToken = artifacts.require("./FanToken.sol");
const CrowdsaleController = artifacts.require("./CrowdsaleController.sol");
const assertJump = require("zeppelin-solidity/test/helpers/assertJump.js");

contract('CrowdsaleController#UsdUpdatable', (accounts) => {
  it("should not allow to set setUsdRate by not owner", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    try {
      await instance.setUsdRate('100.00', {from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should change usd rate and emmit event by setUsdRate", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    const rateData = await instance.setUsdRate('300.00', {from: accounts[0]});
    const newUsdRate = rateData.logs[0];

    assert.equal(newUsdRate.event, 'newUsdRate');
    assert.equal(newUsdRate.args.rate, '300.00');
    assert.equal(await instance.USD_RATE.call({ from: accounts[0]}), 30000);
  });

  it("should not allow to set startUsdUpdates by not owner", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    try {
      await instance.startUsdUpdates({from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should not allow to set stopUsdUpdates by not owner", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    try {
      await instance.stopUsdUpdates({from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });
});
