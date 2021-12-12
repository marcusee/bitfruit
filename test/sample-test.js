const { expect } = require("chai");
const { ethers } = require("hardhat");

const data1 = '1111111111111111111111111111111111111111111111111111111111111111';
const data2 = '2222222222222222222222222222222222222222222222222222222222222222';

describe("Bitfruit", function () {
  it("Should return the symbol when it is deployed", async function () {
    const Bitfruit = await ethers.getContractFactory("Bitfruit");
    const bitfruit = await Bitfruit.deploy();
    await bitfruit.deployed();

    const name = await bitfruit.name();
    expect(name).equal('BitFruit');
  });

  describe('Bit fruit creation' , async () => {
    const Bitfruit = await ethers.getContractFactory("Bitfruit");
    const bitfruit = await Bitfruit.deploy();
    await bitfruit.createFruit(data1);
    
    const fruit = await bitfruit.getFruit(0);
    
    expect(fruit.data).equal(data1);
  });
});
