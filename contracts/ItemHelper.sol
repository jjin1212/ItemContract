//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ItemOwnable.sol";

/// @title This contract is a helper contract
/// @author Jake
/// @notice It inherits from ItemOwnable contract
contract ItemHelper is ItemOwnable {
    event NewEntryToItemsLedger(string desc, uint date, uint tokenId, bool needsRepair);

    function addAnEntry(string calldata desc, uint date, uint tokenId, bool needsRepair) external onlyOwnerOf(tokenId) {
        itemToLedger[tokenId].push(LedgerEntry(desc, needsRepair, uint32(date)));
        emit NewEntryToItemsLedger(desc, date, tokenId, needsRepair);
    }

    function getItemLedgerEntries(uint tokenId) external view returns(LedgerEntry[] memory) {
        return(itemToLedger[tokenId]);
    }
}
