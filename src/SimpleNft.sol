// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleNft is ERC721URIStorage, Ownable {

    string public constant TOKEN_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    uint256 public s_tokenCounter;

    mapping(uint256 => string) private s_tokenURIs;

    uint256 public constant MAX_SUPPLY = 100;

    uint public constant MINT_PRICE = 0.01 ether;

    uint public constant MAX_PER_MINT = 5;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function mintMultipleNfts(uint256 _count) public payable {
        uint256 totalMinted = s_tokenCounter;
        
        require(totalMinted + _count <= MAX_SUPPLY, "Not enough NFTs");
        require(_count > 0 && _count <= MAX_PER_MINT, "Cannot mint specified number of NFTs");
        require(msg.value >= MINT_PRICE * _count, "Not enough Ether");

        for(uint i = 0; i < _count; i++) {
            mintNft();
        }

    }

    function mintNft() public payable returns (uint256) {
        require(msg.value >= MINT_PRICE, "Not enough funds");
        require(s_tokenCounter < MAX_SUPPLY, "Max supply reached");

        _safeMint(msg.sender, s_tokenCounter);
        _setTokenURI(s_tokenCounter, TOKEN_URI);
        s_tokenCounter = s_tokenCounter + 1;
        return s_tokenCounter; //Token counter is the unique tokenId of each NFT in an NFT collection
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Balance is Zero");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed");
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        return s_tokenURIs[tokenId];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

}