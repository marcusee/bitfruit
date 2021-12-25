const { expect } = require("chai");
const { ethers } = require("hardhat");

const data1 = '1111111111111111111111111111111111111111111111111111111111111111';
const data2 = '2222222222222222222222222222222222222222222222222222222222222222';

describe("Bitfruit", function () {
  it("Should return the symbol when it is deployed", async function () {
    const Bitfruit = await ethers.getContractFactory("Bitfruit");
    const bitfruit = await Bitfruit.deploy();
    await bitfruit.deployed({value : 100});

    const name = await bitfruit.name();
    expect(name).equal('BitFruit');
  });

  
  describe('Bit fruit creation' , async () => {
    it("Should propagate a fruit", async function () {
      // const BitFruit = await hre.ethers.getContractFactory("Bitfruit");
      // const bitfruit = await BitFruit.deploy();
      // await bitfruit.deployed();
      // let transaction1 = await bitfruit.createFruit(data1);
      // let transaction2 = await bitfruit.createFruit(data2);
  
      // let a = await bitfruit.getFruit(0);
      // let b = await bitfruit.getFruit(1);
      // await bitfruit.propagate(0,1);
  
      // let c = await bitfruit.getFruit(2);
      // expect(c.tokenId).equal(2);
  
      // let aa =  await bitfruit.getFruit(0);
      // let bb =  await bitfruit.getFruit(1);
  
      // expect( aa.data).equal(data1);
      // expect( bb.data).equal(data2);
  
    });
  });
});


