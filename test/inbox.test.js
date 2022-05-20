const assert = require("assert");
const ganache = require("ganache-cli");
const { beforeEach } = require("mocha");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const fs = require("fs");
const ethers = require("ethers");
const utils = ethers.utils;

let bytecode = fs.readFileSync("./contracts/inbox_sol_Inbox.bin").toString();
let abi = JSON.parse(
  fs.readFileSync("./contracts/inbox_sol_Inbox.abi").toString()
);

const test = utils.formatBytes32String("test");

console.log(utils.parseBytes32String(test) === "test");

let accs, inbox;
beforeEach(async () => {
  //Get A List of All Accouts
  accs = await web3.eth.getAccounts();
  //Use One Of That Accounts to deploy contracts

  try {
    inbox = await new web3.eth.Contract(abi)
      .deploy({
        data: bytecode,
        arguments: ["test"],
      })
      .send({ from: accs[0], gas: 1000000 });
  } catch (ex) {
    console.log(ex);
  }
});

describe("inbox", () => {
  it("deploy successfully", () => {
    assert.ok(inbox.options.address);
  });

  it("Check Initial text", async () => {
    const msg = await inbox.methods.message().call();
    assert.equal("test", msg);
  });

  it("Check Updated text", async () => {
    await inbox.methods.setMessage("polo").send({ from: accs[0] });

    const msg = await inbox.methods.message().call();
    assert.equal(msg, "polo");
  });
});
