//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/// @title This contract is a factory for item NFT and everything related to it
/// @author Jake
/// @notice It inherits from openzepplin's ERC721 contract as each item is unique
contract ItemFactory is ERC721 {
    constructor() ERC721("ItemNFT", "ITM") {}
    event NewItem(string name, string model, string itemType, uint salePrice, uint purchaseDate);

    struct Item {
        // uint by default is uint256, this int is way too large and we do not need this much.
        // We can optimize here by using uint32, 2^32 should be more than enough to price goods.
        string name;
        string model;
        string itemType;
        uint32 salePrice;
        uint32 purchaseDate;
    }

    // This will be the ledger for the item. This struct is used to store all the information
    struct LedgerEntry {
        string description;
        bool needsRepair;
        uint32 date;
    }

    // Array of all the items which will go through this contract
    Item[] items;

    // map of every item to its owner
    mapping (uint => address) itemToOwner;

    // how many items this owner holds. Mainly for view purposes
    mapping (address => uint) ownerItemCount;

    // Item to all of its ledger entries
    mapping (uint => LedgerEntry[]) itemToLedger;

    function _createItemAndGetId(
        uint _salePrice, string memory _name, string memory _model, string memory _itemType, uint _purchaseDate
        ) internal returns(uint) {
        items.push(Item(_name, _model, _itemType, uint32(_salePrice), uint32(_purchaseDate)));

        uint id = items.length - 1;
        itemToLedger[id].push(LedgerEntry("First entry, just minted", false, uint32(_purchaseDate)));
        itemToOwner[id] = msg.sender;
        
        emit NewItem(_name, _model, _itemType, _salePrice, _purchaseDate);
        return id;
    }

    function mint(
        uint _salePrice, string calldata _name, string calldata _model, string calldata _itemType, uint _purchaseDate
        ) public payable {
        uint tokenId = _createItemAndGetId(_salePrice, _name, _model, _itemType, uint32(_purchaseDate));
        _safeMint(msg.sender, tokenId);
    }
}
