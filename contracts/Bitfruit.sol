// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


import "hardhat/console.sol";

contract Bitfruit is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public owner;

    mapping(uint256 => Fruit) tokenIdToFruit;

    struct Fruit {
      uint256 tokenId;
      string data;
      uint256 created;
    }

    constructor() ERC721("BitFruit", "BFT") {
      owner = payable(msg.sender);
    }

    function createFruit(string memory data) public returns (uint256) {
        require(validateData(data), 'Invalid Data');

        uint256 newTokenId = _tokenIds.current();
        _tokenIds.increment();
        
        tokenIdToFruit[newTokenId] = Fruit(
          newTokenId,
          data,
          block.timestamp
        );

        _mint(msg.sender, newTokenId);
        
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
      uint256 randomNumber = uint256(keccak256(abi.encodePacked(uint2str(seed))));
      string memory data = createNewData(A.data, B.data, randomNumber);
      uint256 childTokenId = createFruit(data);
      
      return childTokenId;
      // return childTokenId;
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

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
      if (_i == 0) {
          return "0";
      }
      uint j = _i;
      uint len;
      while (j != 0) {
          len++;
          j /= 10;
      }
      bytes memory bstr = new bytes(len);
      uint k = len;
      while (_i != 0) {
          k = k-1;
          uint8 temp = (48 + uint8(_i - _i / 10 * 10));
          bytes1 b1 = bytes1(temp);
          bstr[k] = b1;
          _i /= 10;
      }
      return string(bstr);
    }
}