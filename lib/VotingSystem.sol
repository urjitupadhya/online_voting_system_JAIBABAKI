// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;

    enum VoteStatus { NotVoted, Voted }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
    }

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "You are not a registered voter");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        _;
    }

    event VoterRegistered(address voterAddress);
    event CandidateRegistered(string candidateName);
    event Voted(address voterAddress, string candidateName);

    constructor( ) public {
        owner = msg.sender;
    }

    function registerVoter(address _voterAddress) external onlyOwner {
        require(!voters[_voterAddress].isRegistered, "Voter already registered");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
    }

    function registerCandidate(string calldata _candidateName) external onlyOwner {
        candidates.push(Candidate(_candidateName, 0));
        emit CandidateRegistered(_candidateName);
    }

    function vote(string calldata _candidateName) external onlyRegisteredVoter hasNotVoted {
        bool candidateExists = false;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i].name)) == keccak256(abi.encodePacked(_candidateName))) {
                candidateExists = true;
                break;
            }
        }
        require(candidateExists, "Candidate does not exist");

        voters[msg.sender].hasVoted = true;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i].name)) == keccak256(abi.encodePacked(_candidateName))) {
                candidates[i].voteCount++;
                break;
            }
        }

        emit Voted(msg.sender, _candidateName);
    }

    function getResults() external view onlyOwner returns (Candidate[] memory) {
        return candidates ;
    }
}
