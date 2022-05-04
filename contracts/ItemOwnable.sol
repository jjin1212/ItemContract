//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Itemfactory.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title This contract is an ownable contract, anything that deals with the owners
/// @author Jake
/// @notice It inherits from openzepplin's Ownable and our ItemFactory contracts
contract ItemOwnable is Ownable, ItemFactory {
    mapping (uint => address) itemApprovals;

    modifier onlyOwnerOf(uint itemId) {
        require(msg.sender == itemToOwner[itemId]);
        _;
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return ownerItemCount[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = itemToOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        ownerItemCount[from]--;
        ownerItemCount[to]++;
        itemToOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(msg.sender == itemToOwner[tokenId] || msg.sender == itemApprovals[tokenId]);
        _transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public virtual override onlyOwnerOf(tokenId) {
        itemApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }
}