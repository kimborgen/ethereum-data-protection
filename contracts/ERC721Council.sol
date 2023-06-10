// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IERC721Council";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, 
 * forked and modified from the openzeppelin implementation of ERC721
 TODO add implementation of ERC721Enumerable
 */
contract ERC721Council is ERC721Enumerable, IERC721Council {

    // The amount of current seats is implicitly available at ERC721Enumerable.totalSupply()
    // TODO Extension: set maxSeats and limit _mint

    // Minimum amount of required votes for a proposal to pass
    uint256 private _requiredVotes;

    /**
     * @dev Initializes the contract and base contracts
     */
    constructor(string memory name_, string memory symbol_, uint256 requiredVotes_) {
        ERC721(name_, symbol_)
        _requiredVotes = requiredVotes_;
    }

    // @dev Gets the minimal amount of required votes
    function requiredVotes() public view virtual override returns(uint256) {
        return _requiredVotes;
    }
}
