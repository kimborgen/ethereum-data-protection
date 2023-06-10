// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./ERC721Council.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./RequestsForDeletion.sol";

contract EthereumDataProtection is ERC721Council, Ownable {

    // Lets define the problem of elections as out-of-scope, and assume there exist a set of DCP members
    // Due to standardization, this is best represented trough ERC-20 or ERC-721 tokens. ERC-20 is the most flexible
    // but requires that the ERC-20 system remains unchanged in a voting period. We can rather use ERC-721 to represent
    // council seats. A collection of ERC-721 exists, where the size of the collection is the number of seats.
    // If a person votes on an RFD, the vote is tied to the NFT rather than the person. So if there is a change in
    // DCP membership, if the new DCP member took over the NFT that already voted, the new member cannot vote.
    // This is implemented in ERC721Council
    
    RequestsForDeletion implementedRFDs;

    constructor(uint256 maxSeats_, RequestsForDeletion implementedRFDs_) ERC721Council("Ethereum Data Protection Council", "EDPC", maxSeats_){
        implementedRFDs = RequestsForDeletion(implementedRFDs_);
    }

    // Requests For Deletion
    struct NewRFD {
        bool open;
        address submittedBy;
        uint256 requestBlockNumber;
        bytes32 requestTx;
        string requestJustification;
    }

    function hashNewRFD(address submittedBy, uint256 requestBlockNumber, bytes32 requestTx, string memory requestJustification) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(submittedBy, requestBlockNumber, requestTx, requestJustification));
    }

    mapping (bytes32 => NewRFD) newRFDs;

    function submitNewRFD(uint256 requestBlockNumber, bytes32 requestTx, string memory requestJustification) public {
        bytes32 hsh = hashNewRFD(msg.sender, requestBlockNumber, requestTx, requestJustification);
        NewRFD storage rfd = newRFDs[hsh];
        require(rfd.submittedBy != address(0), "New RFD already exists");
        rfd.submittedBy = msg.sender;
        rfd.requestBlockNumber = requestBlockNumber;
        rfd.requestTx = requestTx;
        rfd.requestJustification = requestJustification;

        _addProposal(hsh, msg.sender);
    }

    function vote(bytes32 hashedProposal, uint256 tokenId, bool yesVote, string memory justification) public {
        NewRFD storage rfd = newRFDs[hashedProposal];
        require(rfd.open, "proposal is not open");
        _vote(hashedProposal, tokenId, yesVote, justification);

        CouncilProposal storage prop = councilProposals[hashedProposal];

        // check vote result
        uint256 requiredVotes = maxSeats() / 2 + 1;
        if (prop.yesVotes >= requiredVotes) {
            // proposal passed
            // add RFD to list of sucesfull RFDs
            implementedRFDs.addRFD(hashedProposal, newRFDs[hashedProposal].requestTx);
            rfd.open = false;
        } else if (prop.noVotes >= requiredVotes) {
            // proposal failed
            rfd.open = false;
        }
    }

    // setSeat

    function setSeat(address newMember, uint256 tokenId) public onlyOwner {
        _setSeat(newMember, tokenId);
    }

    function addSeat(address newMember) public onlyOwner {
        _addSeat(newMember);
    }

}
