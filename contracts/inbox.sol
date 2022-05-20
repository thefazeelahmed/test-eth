// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;



contract Inbox {
    string public message;

    struct candidate {
        int votecount;
        string name;
    }

    struct vote {
        address candidateAddress;
        address voterAddress;
    }

    struct voter {
        address voterAddress;
    }

    constructor(string memory initialmsg) {
        message = initialmsg;
    }

    function setMessage(string memory mymsg) public {
        message = mymsg;
    }
}