// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/ownership/Ownable.sol";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, 
 * forked and modified from the openzeppelin implementation of ERC721
 TODO add implementation of ERC721Enumerable
 */
contract ERC721Council is ERC721Enumerable {

    // The amount of current seats is implicitly available at ERC721Enumerable.totalSupply()
    uint256 private _maxSeats;

    // Minimum amount of required votes for a proposal to pass
    // uint256 private _requiredVotes;

    /**
     * @dev Initializes the contract and base contracts
     */
    constructor(string memory name_, string memory symbol_, uint256 maxSeats_) ERC721(name_, symbol_) {
        
        //_requiredVotes = requiredVotes_;
        _maxSeats = maxSeats_;
    }

    // @dev Gets the minimal amount of required votes
    //function requiredVotes() public view returns(uint256) {
    //   return _requiredVotes;
    //}

    //function _setRequiredVotes(uint256 requiredVotes_) internal {
    //    require(requiredVotes_ <= _maxSeats, "The amount of required votes cannot be larger than the amount of seats");
    //    _requiredVotes = requiredVotes_;
    //}

    /**
     * @dev Returns the current value of the _maxSeats variable.
     * @return The current value of _maxSeats.
     */
    function maxSeats() public view returns (uint256) {
        return _maxSeats;
    }

    /**
     * @dev Sets a new value for the _maxSeats variable.
     * @param maxSeats_ The new value to be set.
     */
    function _setMaxSeats(uint256 maxSeats_) internal {
        _maxSeats = maxSeats_;
    }

    function _setSeat(address newMember, uint256 tokenId) internal {
        _requireMinted(tokenId);
        address oldMember = ownerOf(tokenId);
        _safeTransfer(oldMember, newMember, tokenId, new bytes(0));
    }

    function _addSeat(address newMember) internal {
        // IDs are numerically iterating from 0
        // The new ID is the current number of tokens
        uint256 tokenId = totalSupply();
        require(tokenId <= _maxSeats, "Maximum amount of tokens exists");
        _safeMint(newMember, tokenId);
    }

    event ProposalAdded(bytes32 indexed hashedProposal, address indexed submittedBy, uint256 timestamp);
    event VoteCasted(bytes32 indexed hashedProposal, address indexed voter, uint256 indexed tokenId, bool yesVote, string justification);


    struct CouncilProposal {
        bytes32 hashedProposal; // external id
        address submittedBy;
        uint256 timestamp;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(uint256 => string) justification; // tokenId => justification , must be non empty string
    }

    mapping(bytes32 => CouncilProposal) public councilProposals;

    function _addProposal(bytes32 hashedProposal, address submittedBy) internal {
        CouncilProposal storage prop = councilProposals[hashedProposal];
        require(prop.hashedProposal == 0, "Proposal already exists");

        prop.hashedProposal = hashedProposal;
        prop.submittedBy = submittedBy;
        prop.timestamp = block.timestamp; 
        emit ProposalAdded(hashedProposal, submittedBy, block.timestamp);
    }

    function _vote(bytes32 hashedProposal, uint256 tokenId, bool yesVote, string memory justification) internal {
        require(_isApprovedOrOwner(msg.sender, tokenId), "msg.sender is not approved or owner of given seat tokenId");
        require(bytes(justification).length > 0, "justification is empty");
        CouncilProposal storage prop = councilProposals[hashedProposal];
        require(bytes(prop.justification[tokenId]).length == 0, "tokenId already voted");
        if (yesVote) {
            prop.yesVotes += 1;
        } else {
            prop.noVotes += 1;
        }
        prop.justification[tokenId] = justification;
        emit VoteCasted(hashedProposal, msg.sender, tokenId, yesVote, justification);
    }
}
