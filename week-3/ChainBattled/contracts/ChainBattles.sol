// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    struct Character {
        uint256 Level;
        uint256 Speed;
        uint256 Strength;
        uint256 Life;
    }

    mapping(uint256 => Character) public tokenIdToCharacter;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLife(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToCharacter[tokenId].Level;
        return levels.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToCharacter[tokenId].Strength;
        return levels.toString();
    }
    
    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToCharacter[tokenId].Speed;
        return levels.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToCharacter[tokenId].Life;
        return levels.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function randomInitialAttribute(uint256 number) public view returns (uint256) {
        return uint256(blockhash(block.number-1)) % number;
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToCharacter[newItemId] = Character(
            0,
            randomInitialAttribute(3),
            randomInitialAttribute(3),
            randomInitialAttribute(3)
        );
        
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        
        tokenIdToCharacter[tokenId].Level++;
        tokenIdToCharacter[tokenId].Strength++;
        tokenIdToCharacter[tokenId].Speed++;
        tokenIdToCharacter[tokenId].Life++;

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}