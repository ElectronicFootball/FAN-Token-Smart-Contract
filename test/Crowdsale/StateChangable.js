const FanToken = artifacts.require("./FanToken.sol");
const CrowdsaleController = artifacts.require("./CrowdsaleController.sol");
const assertJump = require("zeppelin-solidity/test/helpers/assertJump.js");

contract('CrowdsaleController#StateChangable', (accounts) => {
  it("should not allow to set setActiveState by not owner", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    try {
      await instance.setActiveState({from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should not allow to set setStoppedState by not owner", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    try {
      await instance.setStoppedState({from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should change state of crowdsale state", async () => {
    const token = await FanToken.new();
    const instance = await CrowdsaleController.new(token.address, accounts[0]);

    assert.equal((await instance.tokenSaleState()).valueOf(), 0);

    await instance.setActiveState({from: accounts[0]});
    assert.equal((await instance.tokenSaleState()).valueOf(), 1);

    await instance.setStoppedState({from: accounts[0]});
    assert.equal((await instance.tokenSaleState()).valueOf(), 0);
  });
});
