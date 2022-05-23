const assert = require("assert");
const ganache = require("ganache-cli");
const { beforeEach } = require("mocha");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const fs = require("fs");
const ethers = require("ethers");
const utils = ethers.utils;

let bytecode = fs.readFileSync("./contracts/ballot_sol_Ballot.bin").toString();
let abi = JSON.parse(
  fs.readFileSync("./contracts/ballot_sol_Ballot.abi").toString()
);

let accs, ballot;

beforeEach(async () => {
  //Get A List of All Accouts
  accs = await web3.eth.getAccounts();
  //Use One Of That Accounts to deploy contracts
  console.log("Test");
  try {
    ballot = await new web3.eth.Contract(abi)
      .deploy({
        data: bytecode,
        arguments: [],
      })
      .send({ from: accs[0], gas: 1000000 });
  } catch (ex) {
    console.log(ex);
  }
});

describe("ballot", () => {
  it("deploy successfully", () => {
    assert.ok(ballot.options.address);
  });

  it("creates candidate", async () => {
    let newCandidate = await ballot.methods
      .addCandidate({ candidateAddress: accs[0], name: "Ali", votes: 15 })
      .call();

    assert.equal(newCandidate, 1);
  });
});
