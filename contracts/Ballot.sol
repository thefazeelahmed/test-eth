// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Ballot {

    struct Candidate {
        address candidateAddress;
        string name;
        uint votes;
    }

    struct Vote {
        address candidateAddress;
        address voterAddress;
    }

    struct Voter {
        address voterAddress;
    }

    //mapping(address => uint) public votes;
    Candidate[] public candidates;

    enum State {created,voting,ended}

    State public state;


    constructor() {
        Candidate memory cand1 = Candidate({
            candidateAddress:0x7deF3308aeF9eD686F0C27A60d9e85897b536A1D,
            name:"",
            votes:0
        });

        Candidate memory cand2 = Candidate({
            candidateAddress:0x7deF3308aeF9eD686F0C27A60d9e85897b536A1D,
            name:"",
            votes:2
        });

        candidates.push(cand1);
        candidates.push(cand2);
        startVoting();
    }

    function startVoting() public  {
        state = State.voting;
    }

    function endVoting() public {
        state = State.ended;
        
        winnerName();
    }

    function winnerName() public view
            returns (string memory winnerName_)
    {
        winnerName_ = candidates[winningCandidate()].name;
    }


     function winningCandidate() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < 2; p++) {
            if (candidates[p].votes > winningVoteCount) {
                winningVoteCount = candidates[p].votes;
                winningProposal_ = p;
            }
        }
    }

}
