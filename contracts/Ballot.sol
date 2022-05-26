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

    
    enum States {pending,voting,ended}
    States state;

    constructor(Candidate[] memory candidates_) {
        for(uint i = 0; i < candidates_.length; i++) {
            candidates.push(candidates_[i]);
        }
        state = States.pending;
    }


    function returnError(uint errorType) internal pure returns (string memory errorMsg_){
        if(errorType == 1){
            errorMsg_ = "Must Have Two Or More Users ";
        }
        if(errorType ==2){
            errorMsg_="Cannot announce winner as voting has not ended yet.";
        }
        return errorMsg_;
    }

    function startVoting() public {
        if(countCandidates() >=2){
            state = States.voting;
        }
        else{
            returnError(1);
        }
        
    }


    function canVote() public view returns(bool){
        return state==States.voting;
    }

    function votingEnded() internal view returns(bool){
        return state==States.ended;
    }

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
            candidates[uint256(winningCandidate())].candidateAddress
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
        if(votingEnded()){
            if(winningCandidate() != -1){
            winnerName_ = candidates[uint(winningCandidate())].name;
            return winnerName_;
            }
            else{
                winnerName_ = returnError(2);
                return winnerName_;
            }
        }else{
            winnerName_ = returnError(2);
            return winnerName_;
        }
        
    }

    function winningCandidate() internal view returns (int256 winningProposal_) {
        uint256 winningVoteCount = 0;
        winningProposal_ =-1;
        if(votingEnded()){
            for (uint256 p = 0; p < 2; p++) {
                if (candidates[p].votes > winningVoteCount) {
                    winningVoteCount = candidates[p].votes;
                    winningProposal_ = int256(p);
                    return winningProposal_;
                }
            }
        }else{
            return winningProposal_;
        }
    }
}