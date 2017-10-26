const FanToken = artifacts.require("./FanToken.sol");
const assertJump = require("zeppelin-solidity/test/helpers/assertJump.js");

contract('FanToken', (accounts) => {
  it("Initial supply", async function() {
    const instance = await FanToken.new();
    const balance = await instance.totalSupply();
    assert.equal(balance.valueOf(), 0, "Initial supply must be 0");
  });


  it("should not allow to call issue by not owner", async function () {
    const instance = await FanToken.new();

    try {
      await instance.issue(accounts[1], 100, { from: accounts[1] });
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should update totalSupply and balanceOf for address after issue", async function () {
    const instance = await FanToken.new();
    const balance = await instance.balanceOf(accounts[1]);
    const supply = await instance.totalSupply();
    assert.equal(balance.valueOf(), 0, "Initial balance of address must be 0");
    assert.equal(supply.valueOf(), 0, "Initial totalSupply must be 0");

    await instance.issue(accounts[1], 100, {from: accounts[0]});

    const afterBalance = await instance.balanceOf(accounts[1]);
    const afterSupply = await instance.totalSupply();
    assert.equal(afterBalance.valueOf(), 100, "New balance of address must be 100");
    assert.equal(afterSupply.valueOf(), 100, "New totalSupply must be 100");
  });

  it("should emmit Issuance and Transfer events after issue", async function () {
    const instance = await FanToken.new();
    const issuance = await instance.issue(accounts[1], 100, {from: accounts[0]});
    const issuanceEvent = issuance.logs[0];
    const transferEvent = issuance.logs[1];

    assert.equal(issuanceEvent.args._amount, 100);
    assert.equal(transferEvent.args._from, instance.address);
    assert.equal(transferEvent.args._to, accounts[1]);
    assert.equal(transferEvent.args._value, 100);
  });

  it("should not allow to call disableTransfers by not owner", async function () {
    const instance = await FanToken.new();

    try {
      await instance.disableTransfers(true, { from: accounts[1] });
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should disable and enable transfers by owner", async function () {
    const instance = await FanToken.new();

    assert.equal((await instance.transfersEnabled()).valueOf(), true);

    // enable
    await instance.disableTransfers(true);
    assert.equal((await instance.transfersEnabled()).valueOf(), false);

    // disable
    await instance.disableTransfers(false);
    assert.equal((await instance.transfersEnabled()).valueOf(), true);
  });

  it("should not allow to destroy tokens from other accounts by not owner", async function () {
    const instance = await FanToken.new();

    try {
      await instance.destroy(accounts[1], 100, { from: accounts[2] });
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });

  it("should allow to destroy tokens from other accounts by owner", async function () {
    const instance = await FanToken.new();

    // issue tokens as owner
    await instance.issue(accounts[1], 100);
    assert.equal((await instance.balanceOf(accounts[1])).valueOf(), 100);

    // Destroy tokens as owner
    await instance.destroy(accounts[1], 100);
    assert.equal((await instance.balanceOf(accounts[1])).valueOf(), 0);
  });

  it("should allow to destroy tokens from own account", async function () {
    const instance = await FanToken.new();

    // issue tokens as owner of contract
    await instance.issue(accounts[1], 100);
    assert.equal((await instance.balanceOf(accounts[1])).valueOf(), 100);

    // Destroy tokens as owner of account
    await instance.destroy(accounts[1], 100, {from: accounts[1]});
    assert.equal((await instance.balanceOf(accounts[1])).valueOf(), 0);
  });


  it("should not allow to destroy amount bigger than balance", async function () {
    const instance = await FanToken.new();

    try {
      await instance.destroy(accounts[1], 100, {from: accounts[1]});
    } catch (error) {
      return assertJump(error);
    }
    assert.fail('should have thrown before');
  });


  it("should emmit Destruction and Transfer events after destroy", async function () {
    const instance = await FanToken.new();

    // issue tokens as owner
    await instance.issue(accounts[1], 100);
    assert.equal((await instance.balanceOf(accounts[1])).valueOf(), 100);

    // Destroy tokens as owner
    const destroy = await instance.destroy(accounts[1], 100);
    const transferEvent = destroy.logs[0];
    const destructionEvent = destroy.logs[1];

    assert.equal(destructionEvent.args._amount, 100);
    assert.equal(transferEvent.args._to, instance.address);
    assert.equal(transferEvent.args._from, accounts[1]);
    assert.equal(transferEvent.args._value, 100);
  });
});