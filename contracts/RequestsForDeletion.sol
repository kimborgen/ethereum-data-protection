// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/ownership/Ownable.sol";

/**
 * @dev This contracts stores sucesfully processed Requests For Deletion
 * Ethereum node implementions should listen to this contract and process requests.
 * This contract is owned by a EthereumDataProtection instance.
 */
contract RequestsForDeletion is Ownable {
    
    Event AddedRFD(bytes32 indexed hashedProposal, bytes32 indexed requestTx);
    
    struct RFD {
        bytes32 hashedProposal;
        bytes32 requestTx;
        // Todo data location?
    }

    mapping (bytes32 => RFD) public requests;

    function addRFD(bytes32 hashedProposal, bytes32 requestTx) public onlyOwner {
        require(hashedProposal != 0, "hashedProposal cannot be empty");
        require(requestTx != 0, "requestTx cannot be empty");
        RFD storage req = requests[hashedProposal];
        require(req.requestTx == 0, "RFD already added");
        req.requestTx = requestTx;
        emit AddedRFD(hashedProposal, requestTx);
    }
}
