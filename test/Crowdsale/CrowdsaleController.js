const web3 = require("web3");
const FanToken = artifacts.require("./FanToken.sol");
const CrowdsaleController = artifacts.require("./CrowdsaleController.sol");
const assertJump = require("zeppelin-solidity/test/helpers/assertJump.js");

contract('CrowdsaleController', (accounts) => {
  it("fallback must validate state, investment amount and data", async () => {
    const USD_RATE = '300.00';
    const value = 4000000000000000;

    const tokenInstance = await FanToken.new();
    const controller = await CrowdsaleController.new(tokenInstance.address, accounts[0]);

    try {
      await controller.send(1, { from: accounts[1] });
    } catch (error) {
      assertJump(error);
    }

    // Set active state
    await controller.setActiveState({ from: accounts[0] });
    try {
      await controller.send(1, { from: accounts[1] });
    } catch (error) {
      assertJump(error);
    }

    // Set USD Rate
    await controller.setUsdRate(USD_RATE, { from: accounts[0] });
    try {
      await controller.send(1, { from: accounts[1] });
    } catch (error) {
      assertJump(error);
    }

    // Set DATA
    const txData = web3.utils.stringToHex('test-string');

    const data = await controller.sendTransaction({ value: value, from: accounts[1], data: txData });
    const purchaseEvent = data.logs[0];
    assert.equal(purchaseEvent.event, 'TokenPurchased');
    assert.equal(purchaseEvent.args.from, accounts[1]);
    assert.equal(purchaseEvent.args.value, value);
    assert.equal(purchaseEvent.args.currentUsdRate, 30000);
    assert.equal(purchaseEvent.args.txData, txData);
  });

  it("should not allow to call issueTokens if controller is inactive", async () => {
    const token = await FanToken.new();
    const controller = await CrowdsaleController.new(token.address, accounts[0]);

    try {
      await controller.issueTokens(accounts[2], 100);
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should not allow to call issueTokens by not owner", async () => {
    const token = await FanToken.new();
    const controller = await CrowdsaleController.new(token.address, accounts[0]);

    // Make sure controller is active
    await token.transferOwnership(controller.address);
    await controller.acceptTokenOwnership();

    try {
      await controller.issueTokens(accounts[2], 100, {from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should allow to call issueTokens by owner and update balance of recipient balance", async () => {
    const token = await FanToken.new();
    const controller = await CrowdsaleController.new(token.address, accounts[0]);

    // Make sure controller is active
    await token.transferOwnership(controller.address);
    await controller.acceptTokenOwnership();


    assert.equal((await token.balanceOf(accounts[2])).valueOf(), 0);

    await controller.issueTokens(accounts[2], 100);
    const newBalance = await token.balanceOf(accounts[2]);
    assert.equal(newBalance.valueOf(), 100, 'should update recipient balance');
  });

  it("should not allow to call setBeneficiary by not owner", async () => {
    const token = await FanToken.new();
    const controller = await CrowdsaleController.new(token.address, 0x0);

    try {
      await controller.setBeneficiary(accounts[2], {from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should allow to call setBeneficiary by owner and updates its value", async () => {
    const token = await FanToken.new();
    const controller = await CrowdsaleController.new(token.address, 0x0);

    assert.equal(await (controller.beneficiary()).valueOf(), 0x0);
    await controller.setBeneficiary(accounts[2]);
    assert.equal(await (controller.beneficiary()).valueOf(), accounts[2]);
  });
});

