// SPDX-License-Identifier: 
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "ERC721Council";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract EthereumDataProtection is ERC721Council {

    // Lets define the problem of elections as out-of-scope, and assume there exist a set of DCP members
    // Due to standardization, this is best represented trough ERC-20 or ERC-721 tokens. ERC-20 is the most flexible
    // but requires that the ERC-20 system remains unchanged in a voting period. We can rather use ERC-721 to represent
    // council seats. A collection of ERC-721 exists, where the size of the collection is the number of seats.
    // If a person votes on an RFD, the vote is tied to the NFT rather than the person. So if there is a change in
    // DCP membership, if the new DCP member took over the NFT that already voted, the new member cannot vote.
    // This is implemented in ERC721Council

    constructor(uint256 maxSeats_) {
        ERC721Council("Ethereum Data Protection Council", "EDPC", maxSeats_)
    }

    // Requests For Deletion
    struct NewRFD {
        bool open;
        address submittedBy;
        uint256 requestBlockNumber;
        bytes32 requestTx;
        string requestJustification;
    }

    function hashNewRFD(address submittedBy, uint256 requestBlockNumber, bytes32 requestTx, string requestJustification) public view returns (bytes32) {
        return keccak256(abi.encodePacked(submittedBy, requestBlockNumber, requestTx, requestJustification));
    }

    mapping (bytes32 => NewRFD) newRFDs;

    function submitNewRFD(uint256 requestBlockNumber, bytes32 requestTx, string requestJustification) public {
        bytes32 hsh = hashNewRFD(submittedBy, requestBlockNumber, requestTx, requestJustification);
        NewRFD storage rfd = newRFDs[hsh];
        require(rfd.submittedBy != address(0), "New RFD already exists");
        rfd.submittedBy = msg.sender;
        rfd.requestBlockNumber = requestBlockNumber;
        rfd.requestTx = requestTx;
        rfd.justification = justification;

        _addProposal(hsh, msg.sender);
    }

    function vote(bytes32 hashedProposal, uint256 tokenId, bool yesVote, string justification) public {
        CouncilProposal storage prop = councilProposals[hashedProposal];
        require(prop.open, "proposal is not open");
        _vote(hashedProposal, tokenId, yesVote, justification);

        // check vote result
        CouncilProposal storage prop = councilProposals[hashedProposal];
        uint256 requiredVotes = maxSeats() / 2 + 1;
        if (prop.yesVotes >= requiredVotes) {
            // proposal passed
            // TODO add RFD
            prop.open = false;
        } else if (prop.noVotes >= requiredVotes) {
            // proposal failed
            prop.open = false;
        }
    }

    
    


    
    // function submitRFD

    // Defered TODO withdrawRFD

    /* A request should remain open untill it is resolved, for example, if one DCP council refuses to vote on a
    RFD, the community may consider electing a different council for the next epoch.
    Therefor votes will reset every epoch.

    An RFD is marked done / processed under the following condiditons
    - The proposal recieved enough votes in one category such that no additional vote will have an impact
    - The proposal recieved over the minimum required votes AND it is the next epoch

    It might be prudent to split the election epoch and RFD epoch so RFDs can be processed faster than elections.
    */
    // function voteRFD onlyDCP w

}
