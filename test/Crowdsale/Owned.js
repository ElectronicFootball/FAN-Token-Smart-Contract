const FanToken = artifacts.require("./FanToken.sol");
const CrowdsaleController = artifacts.require("./CrowdsaleController.sol");
const assertJump = require("zeppelin-solidity/test/helpers/assertJump.js");

contract("CrowdsaleController#Owned", (accounts) => {
  it("must transfer ownership", async () => {
    const tokenInstance = await FanToken.new();
    const controller = await CrowdsaleController.new(tokenInstance.address, accounts[0]);

    assert.equal((await controller.owner()).valueOf(), accounts[0]);
    assert.equal((await controller.newOwner()).valueOf(), 0x0);

    await controller.transferOwnership(accounts[1]);
    assert.equal((await controller.owner()).valueOf(), accounts[0]);
    assert.equal((await controller.newOwner()).valueOf(), accounts[1]);

    await controller.acceptOwnership({from: accounts[1]});
    assert.equal((await controller.owner()).valueOf(), accounts[1]);
    assert.equal((await controller.newOwner()).valueOf(), 0x0);
  });

  it("must validate new owner on transfer", async () => {
    const tokenInstance = await FanToken.new();
    const controller = await CrowdsaleController.new(tokenInstance.address, accounts[0]);
    try {
      await controller.transferOwnership(accounts[0]);
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("must validate new owner", async () => {
    const tokenInstance = await FanToken.new();
    const controller = await CrowdsaleController.new(tokenInstance.address, accounts[0]);
    await controller.transferOwnership(accounts[2]);

    try {
      await controller.acceptOwnership({from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });
});
