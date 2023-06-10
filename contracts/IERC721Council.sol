// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title ERC-721 Non-Fungible Token Standard, Council extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Council is IERC721 {
    /**
     * @dev Gets the minimum amount of votes required 
     */
    function requiredVotes() public view virtual returns (uint256);
}
