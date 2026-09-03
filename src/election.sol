// SPDX-License-Identifier: MIT
// changed the typo from Lincense to License
pragma solidity ^0.8.30;

contract Election {
    ////////// ERRORS //////////

    // changed and added new errors to make the code more readable and efficient
    error Election__NotChairman();
    error Election__Under18();
    error Election__CandidateNotFound();
    error Election__NotRegistered();
    error Election__AlreadyVoted();
    error Election__AlreadyStarted();
    error Election__NotStarted();
    error Election__InvalidAddress();
    error Election__CandidateAlreadyExists();
    error Election__PartyNotFound();
    error Election__NoCandidates();

    ////////// STRUCTS //////////

    // added Candidate struct to store candidate information
    struct Candidate {
        address candidateAddr;
        string candidateName;
        uint256 totalCandidateVote;
        uint256 partyId;
        bool active;
    }

    // added Party struct to support party creation
    struct Party {
        uint256 id;
        string name;
    }

    ////////// STATE VARIABLES //////////

    // changed chairman to automatically be the contract deployer
    address public immutable chairman;

    bool private isElectionStarted;

    Candidate[] public candidates;
    Party[] public parties;

    address[] public people;

    // Candidate address => candidate ID because IDs start from 1
    mapping(address => uint256) public candidateIdToAddr;

    mapping(address => bool) public is18Year;
    mapping(address => bool) public isRegistered;
    mapping(address => bool) public hasVoted;

    // Candidate IDs are 1-based, while array indexes start from 0
    uint256 private winnerCandidateId;
    uint256 private highestVoteCount;

    ////////// CONSTRUCTOR //////////

    // added constructor to set the chairman during deployment
    constructor() {
        chairman = msg.sender;
    }

    ////////// MODIFIERS //////////

    // added modifier to allow only the chairman to call restricted functions
    modifier onlyChairman() {
        if (msg.sender != chairman) {
            revert Election__NotChairman();
        }

        _;
    }

    // added modifier to prevent changes after the election starts
    modifier beforeElection() {
        if (isElectionStarted) {
            revert Election__AlreadyStarted();
        }

        _;
    }

    ////////// PARTY FUNCTIONS //////////

    // completed createParties() to create and assign a party ID
    function createParties (string memory _partyName) public onlyChairman beforeElection returns (uint256 partyId) {
        require(
            bytes(_partyName).length > 0,
            "Party name cannot be empty"
        );

        partyId = parties.length + 1;

        parties.push(
            Party({
                id: partyId,
                name: _partyName
            })
        );
    }

    ////////// CANDIDATE FUNCTIONS //////////

    // changed createCandidates() to support party assignment
    function createCandidates (address _candidateAddress, string memory _name, uint256 _partyId) public onlyChairman beforeElection {
        // added address validation
        if (_candidateAddress == address(0)) {
            revert Election__InvalidAddress();
        }

        // added duplicate candidate check
        if (candidateIdToAddr[_candidateAddress] != 0) {
            revert Election__CandidateAlreadyExists();
        }

        // added party validation
        if (_partyId == 0 || _partyId > parties.length) {
            revert Election__PartyNotFound();
        }

        candidates.push(
            Candidate({
                candidateAddr: _candidateAddress,
                candidateName: _name,
                totalCandidateVote: 0,
                partyId: _partyId,
                active: true
            })
        );

        // using candidates.length automatically gives us a 1-based ID here.
        candidateIdToAddr[_candidateAddress] = candidates.length;
    }

    // changed removeCandidates() to deactivate a candidate without shifting IDs
    function removeCandidates (address _candidateAddress) public onlyChairman beforeElection {
        uint256 candidateId = candidateIdToAddr[_candidateAddress];

        // added check to ensure the candidate exists
        if (candidateId == 0) {
            revert Election__CandidateNotFound();
        }

        // We don't delete from the array because that would disturb candidate IDs
        candidates[candidateId - 1].active = false;

        // so therefore, we delete from here..
        delete candidateIdToAddr[_candidateAddress];
    }

    ////////// VOTER FUNCTIONS //////////

    // changed voter registration to prevent duplicate voters
    function registerVoters (uint16 age, address voter) public onlyChairman beforeElection returns (bool) {
        // added address validation
        if (voter == address(0)) {
            revert Election__InvalidAddress();
        }

        // added age validation
        if (age < 18) {
            revert Election__Under18();
        }

        is18Year[voter] = true;

        // added check to prevent duplicate registration
        if (!isRegistered[voter]) {
            isRegistered[voter] = true;
            people.push(voter);
        }

        return true;
    }

    ////////// ELECTION FUNCTIONS //////////

    // changed election start to require at least one candidate
    function getElectionStarted() public onlyChairman beforeElection {
        if (candidates.length == 0) {
            revert Election__NoCandidates();
        }

        isElectionStarted = true;
    }

    // changed vote() to use the voter's msg.sender address
    function vote(uint256 id) public {
        // added check to ensure the election has started
        if (!isElectionStarted) {
            revert Election__NotStarted();
        }

        // added voter registration check
        if (
            !isRegistered[msg.sender] ||
            !is18Year[msg.sender]
        ) {
            revert Election__NotRegistered();
        }

        // added check to prevent multiple votes
        if (hasVoted[msg.sender]) {
            revert Election__AlreadyVoted();
        }

        // Candidate IDs are 1-based, so ID 1 maps to index 0
        if (
            id == 0 || id > candidates.length
        ) {
            revert Election__CandidateNotFound();
        }

        Candidate storage selectedCandidate =
            candidates[id - 1];

        // added check to prevent voting for removed candidates
        if (!selectedCandidate.active) {
            revert Election__CandidateNotFound();
        }

        selectedCandidate.totalCandidateVote += 1;

        hasVoted[msg.sender] = true;

        _updateWinner(id);
    }

    // changed winner tracking to store the candidate ID, not voter ID
    function _updateWinner(uint256 id) private {
        uint256 candidateVotes =
            candidates[id - 1].totalCandidateVote;

        if (candidateVotes > highestVoteCount) {
            highestVoteCount = candidateVotes;
            winnerCandidateId = id;
        }
    }

    ////////// GETTER FUNCTIONS //////////

    // completed getWinner() to return the winning candidate ID
    function getWinner() public view returns (uint256) {
        return winnerCandidateId;
    }

    // added getter to return detailed information about the winner
    function getWinnerDetails() public view returns (uint256 id, address candidateAddress, string memory candidateName, uint256 totalVotes, uint256 partyId) {
        id = winnerCandidateId;

        // return empty values if no candidate has received a vote
        if (id == 0) {
            return (
                0, address(0), "", 0, 0
            );
        }

        Candidate memory currentWinner = candidates[id - 1];

        return (
            id,
            currentWinner.candidateAddr,
            currentWinner.candidateName,
            currentWinner.totalCandidateVote,
            currentWinner.partyId
        );
    }

    // added getter to check whether the election has started
    function electionStarted() public view returns (bool) {
        return isElectionStarted;
    }
}