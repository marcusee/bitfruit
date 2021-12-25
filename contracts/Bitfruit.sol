// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract Bitfruit is ERC721 {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  address private owner;

  mapping(uint256 => Fruit) private tokenIdToFruit;

  struct Fruit {
    uint256 tokenId;
    string data;
    uint256 created;
  }

  string public baseUrl = '';

  constructor() ERC721("BitFruit", "BFT") {
    owner = payable(msg.sender);
  }

  function seedFruits() public {
    createFruit('33AA578377749A2352AA42A6A662A398753299A58A3537136A337981A75478A2');
    createFruit('95677547764889713155AA889A23A1644852A779857579883421A77A69A76813');
    createFruit('95677547764889713155AA889A23A1644852A779857579883421A77A69A76813');
    createFruit('A168751A937A1974975544A4428288349659487976A62987111694862A15273A');
    createFruit('A6A6A4339A791992418126333816653833571589113897648138754655756133');
  }

  function changeBaseUrl(string memory newUrl) public {
    baseUrl = newUrl;
  }

  function tokenURI(uint256 _tokenId) override public view returns (string memory) {
    return string(abi.encodePacked(baseUrl, Strings.toString(_tokenId)));
  }

  function createFruit(string memory data) private returns (uint256) {
      require(validateData(data), 'Invalid Data');

      uint256 newTokenId = _tokenIds.current();
      
      tokenIdToFruit[newTokenId] = Fruit(
        newTokenId,
        data,
        block.timestamp
      );
          
      _mint(msg.sender, newTokenId);
      _tokenIds.increment();
      return newTokenId;
  }

  function getFruit(uint256 tokenId) public view returns (Fruit memory) {
    require(tokenId <= _tokenIds.current(), 'Non existing fruit');
    return tokenIdToFruit[tokenId];
  }

  // Only accepts 0-9 and A-F
  function validateData(string memory data) private pure returns (bool) {
    bytes memory b = bytes(data);
    for(uint i = 0; i<b.length; i++) {
      bytes1 char = b[i];

      if(!(char >= 0x30 && char <= 0x39)) {
        if (!(char >= 0x41 && char <= 0x46)){
          return false;
        }
      }

      if (i > 64) return false;
    }

    return true;
  }

  function propagate(uint256 parentA, uint256 parentB) public returns (uint256) {
    // TODO: Error checking

    Fruit memory A = tokenIdToFruit[parentA];
    Fruit memory B = tokenIdToFruit[parentB];

    // INSECURE gotta use that stupid chain link random thing
    uint256 seed = block.timestamp;
    uint256 randomNumber = uint256(keccak256(abi.encodePacked(Strings.toString(seed))));
    string memory data = createNewData(A.data, B.data, randomNumber);
    uint256 childTokenId = createFruit(data);
    
    return childTokenId;
  }

  function createNewData(string memory dataA, string memory dataB, uint256 randomNumber) private pure returns (string memory) {
    bytes memory byteDataA = bytes(dataA);
    bytes memory byteDataB = bytes(dataB);
    bytes memory newDataBytes = bytes(dataA);

    for(uint i = 0 ; i < 64; i++) {
      uint digit = randomNumber % 10;
      if (digit > 4) {
        // Get Parent A color
        newDataBytes[i] = byteDataA[i];
      } else {
        // Get Parent B color
        newDataBytes[i] = byteDataB[i];
      } 

      randomNumber = randomNumber / 10;
    }

    return string(newDataBytes);
  }
}