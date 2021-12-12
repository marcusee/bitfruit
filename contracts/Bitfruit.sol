// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


import "hardhat/console.sol";

contract Bitfruit is ERC721URIStorage {
    Counters.Counter private _tokenIds;
    address public owner;

    constructor() ERC721("BitFruit", "BFT") {
      owner = payable(msg.sender);
    }

}