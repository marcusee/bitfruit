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
}