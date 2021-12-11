const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Bitfruit", function () {
  it("Should return the symbol when it is deployed", async function () {
    const Bitfruit = await ethers.getContractFactory("Bitfruit");
    const bitfruit = await Bitfruit.deploy();
    await bitfruit.deployed();

    const name = await bitfruit.name();
    expect(name).equal('BitFruit');
  });
});
