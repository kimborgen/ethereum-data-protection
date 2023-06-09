// SPDX-License-Identifier: 
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract EthereumDataProtection {

    //uint256 public RFDRequiredVotes;
    //uint256 public amountCouncilMembers = 0;

    // Lets define the problem of elections as out-of-scope, and assume there exist a set of DCP members
    // Due to standardization, this is best represented trough ERC-20 or ERC-721 tokens. ERC-20 is the most flexible
    // but requires that the ERC-20 system remains unchanged in a voting period. We can rather use ERC-721 to represent
    // council seats. A collection of ERC-721 exists, where the size of the collection is the number of seats.
    // If a person votes on an RFD, the vote is tied to the NFT rather than the person. So if there is a change in
    // DCP membership, if the new DCP member took over the NFT that already voted, the new member cannot vote.

    constructor() {
        
    }

    // Requests For Deletion
    struct RFD {
        bool open;
        address submittedBy;
        uint256 submittedInEpoch;
        uint256 requestBlockNumber;
        bytes32 requestTx;
        string requestJustification;
        // DB Location?
        uint256 yesVotes;
        uint256 noVotes;
        mapping (uint256 => uint256) yesVotes; // epoch number => yesVotes
        mapping (uint256 => uint256) noVotes; // epoch number => noVotes 
        mapping(address => string) DCPJustifications; // less need for epoch number
    }

    // ID = hash(submittedBy, requestBlockNumber, requestTx, requestJustification)
    mapping (bytes32 => RFD) RFDs;
    
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
