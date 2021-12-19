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
    it ('should create a fruit', async () => {
      const Bitfruit = await ethers.getContractFactory("Bitfruit");
      const bitfruit = await Bitfruit.deploy();
      await bitfruit.createFruit(data1);
      
      const fruit = await bitfruit.getFruit(0);
      const svgURI = await bitfruit.tokenURI(0);
      expect(fruit.data).equal(data1);

    })

    it ('Should fail if invalid data', async () => {
      const Bitfruit = await ethers.getContractFactory("Bitfruit");
      const bitfruit = await Bitfruit.deploy();
      await expect(
        bitfruit.createFruit('nonsense') 
      ).to.be.revertedWith("Invalid Data");
    });

    it('Should be able to create fruits with these values' , async () => {
      const Bitfruit = await ethers.getContractFactory("Bitfruit");
      const bitfruit = await Bitfruit.deploy();

      // const test0 =  Array(64).fill('0').join('');
      // const test1 =  Array(64).fill('1').join('');
      // const test2 =  Array(64).fill('2').join('');
      // const test3 =  Array(64).fill('3').join('');
      // const test4 =  Array(64).fill('4').join('');
      // const test5 =  Array(64).fill('5').join('');
      // const test6 =  Array(64).fill('6').join('');
      // const test7 =  Array(64).fill('7').join('');
      // const test8 =  Array(64).fill('8').join('');
      // const test9 =  Array(64).fill('9').join('');
      // const testA =  Array(64).fill('A').join('');
      // const testB =  Array(64).fill('B').join('');
      // const testC =  Array(64).fill('C').join('');
      // const testD =  Array(64).fill('D').join('');
      // const testE =  Array(64).fill('E').join('');
      // const testF =  Array(64).fill('F').join('');

      // await bitfruit.createFruit(test0);
      // await bitfruit.createFruit(test1);
      // await bitfruit.createFruit(test2);
      // await bitfruit.createFruit(test3);
      // await bitfruit.createFruit(test4);
      // await bitfruit.createFruit(test5);
      // await bitfruit.createFruit(test6);
      // await bitfruit.createFruit(test7);
      // await bitfruit.createFruit(test8);
      // await bitfruit.createFruit(test9);
      // await bitfruit.createFruit(testA);
      // await bitfruit.createFruit(testB);
      // await bitfruit.createFruit(testC);
      // await bitfruit.createFruit(testD);
      // await bitfruit.createFruit(testE);
      // await bitfruit.createFruit(testF);
    });

    it('Should not be able to create fruit if data char not between A-F' , async () => {
      const Bitfruit = await ethers.getContractFactory("Bitfruit");
      const bitfruit = await Bitfruit.deploy();

      const testG =  Array(64).fill('G').join('');
      const testAt =  Array(64).fill('@').join('');

      await expect(
        bitfruit.createFruit(testG)
      ).to.be.revertedWith('Invalid Data');

      await expect(
        bitfruit.createFruit(testAt)
      ).to.be.revertedWith('Invalid Data');
    });

    it("Should propagate a fruit", async function () {
      const BitFruit = await hre.ethers.getContractFactory("Bitfruit");
      const bitfruit = await BitFruit.deploy();
      await bitfruit.deployed();
      let transaction1 = await bitfruit.createFruit(data1);
      let transaction2 = await bitfruit.createFruit(data2);
  
      let a = await bitfruit.getFruit(0);
      let b = await bitfruit.getFruit(1);
      await bitfruit.propagate(0,1);
  
      let c = await bitfruit.getFruit(2);
      expect(c.tokenId).equal(2);
  
      let aa =  await bitfruit.getFruit(0);
      let bb =  await bitfruit.getFruit(1);
  
      expect( aa.data).equal(data1);
      expect( bb.data).equal(data2);
  
    });
  });

  describe('create fruit', () => {
    it('create seeded fruit', async () => {
      const Bitfruit = await ethers.getContractFactory("Bitfruit");
      const bitfruit = await Bitfruit.deploy();

      await bitfruit.createFruit('33AA578377749A2352AA42A6A662A398753299A58A3537136A337981A75478A2');
    
    });
  });

});


