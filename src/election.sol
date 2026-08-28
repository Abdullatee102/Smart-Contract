// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Election {
    // Custom Errors for gas efficiency
    error Election__NotChairman();
    error Election__Not18Yet();
    error Election__CandidateDeleted();
    error Election__NotRegistered();
    error Election__VotedAlready();
    error Election__ElectionNotStarted();

    struct Candidate {
        address candidateAddr;
        string candidateName;
        uint256 totalCandidateVote;
    }

    address public chairman;
    bool private isElectionStarted = false;

    // Dynamic array to store candidates
    Candidate[] public candidates;

    // Mappings
    mapping(address => bool) public registeredVoters;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public candidateAddressToId; // Maps candidate address to their ID

    uint256 public highestVoterId; // Stores the array index/ID of the leading candidate

    constructor() {
        chairman = msg.sender; // Set the deployer as the chairman
    }

    modifier onlyChairman() {
        if (msg.sender != chairman) {
            revert Election__NotChairman();
        }
        _;
    }

    // 1. Create Candidates (Chairman only)
    function createCandidate(address _candidateAddress, string memory _name) public onlyChairman {
        candidates.push(Candidate({
            candidateAddr: _candidateAddress,
            candidateName: _name,
            totalCandidateVote: 0
        }));

        // Assign an ID (using index + 1)
        uint256 candidateId = candidates.length;
        candidateAddressToId[_candidateAddress] = candidateId;
    }

    // 2. Start the Election (Chairman only)
    function startElection() public onlyChairman {
        isElectionStarted = true;
    }

    // 3. Register Voters (Chairman only)
    function registerVoter(address _voter, uint16 _age) public onlyChairman {
        if (_age < 18) {
            revert Election__Not18Yet();
        }
        registeredVoters[_voter] = true;
    }

    // 4. Vote for a Candidate
    function vote(uint256 _candidateId) public {
        if (!isElectionStarted) {
            revert Election__ElectionNotStarted();
        }
        if (!registeredVoters[msg.sender]) {
            revert Election__NotRegistered();
        }
        if (hasVoted[msg.sender]) {
            revert Election__VotedAlready();
        }
        
        // Ensure valid candidate ID (Index is ID - 1)
        if (_candidateId == 0 || _candidateId > candidates.length) {
            revert Election__CandidateDeleted();
        }

        uint256 index = _candidateId - 1;
        
        // Check if candidate address is active/valid
        if (candidates[index].candidateAddr == address(0)) {
            revert Election__CandidateDeleted();
        }

        // Record vote
        candidates[index].totalCandidateVote += 1;
        hasVoted[msg.sender] = true;

        // Update winner dynamically
        if (candidates[index].totalCandidateVote > candidates[highestVoterId].totalCandidateVote) {
            highestVoterId = index;
        }
    }

    // 5. Get Winner Details
    function getWinner() public view returns (string memory winnerName, uint256 winningVotes) {
        if (candidates.length == 0) {
            return ("No candidates available", 0);
        }
        Candidate memory winningCandidate = candidates[highestVoterId];
        return (winningCandidate.candidateName, winningCandidate.totalCandidateVote);
    }
}