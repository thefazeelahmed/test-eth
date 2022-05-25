// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    struct Candidate {
        address candidateAddress;
        string name;
        uint256 votes;
    }

    // struct Vote {
    //     address candidateAddress;
    //     address voterAddress;
    // }

    struct Voter {
        address voterAddress;
    }

    Candidate[] public candidates;

    string state;

    constructor(Candidate[] memory candidates_) {
        for(uint i = 0; i < candidates_.length; i++) {
            candidates.push(candidates_[i]);
        }
    }

    function startVoting() public {}

    function endVoting() public view {
        winnerName();
    }

    function addCandidate(Candidate memory candidate_)
        public
        returns (Candidate memory temp_)
    {
        candidates.push(candidate_);
        temp_ = candidate_;
        return temp_;
    }

    function countCandidates() public view returns (uint256 totalCount) {
        totalCount = candidates.length;
        return totalCount;
    }

    function transferEths(uint256 _value) public payable {
        address payable addr = payable(
            candidates[winningCandidate()].candidateAddress
        );
        addr.transfer(_value);
    }

    function castVote(address candidateAddress) public {
        for (uint256 p = 0; p < 2; p++) {
            if (candidates[p].candidateAddress == candidateAddress) {
                candidates[p].votes += 1;
            }
        }
    }

    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = candidates[winningCandidate()].name;
        return winnerName_;
    }

    function winningCandidate() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < 2; p++) {
            if (candidates[p].votes > winningVoteCount) {
                winningVoteCount = candidates[p].votes;
                winningProposal_ = p;
                return p;
            }
        }
    }
}