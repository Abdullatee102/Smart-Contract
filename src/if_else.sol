// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract if_else {
    //if else: is a stement that is used to run a bloock of code if the condition is true or not
    enum eligible_Status {
        over18,
        just18,
        underage
    }
    eligible_Status public s_Status;

    function checkEligibility(uint256 _ageOfThePerson) public {
        uint256 rightAge = 18;
        // <if (condition is true) { run this code}
        // else { run another code }>
        if (_ageOfThePerson > rightAge) {
            s_Status = eligible_Status.over18;
        } else if (_ageOfThePerson == rightAge) {
            s_Status = eligible_Status.just18;
        } else {
            s_Status = eligible_Status.underage;
        }
    }

    function checkCardfor18(uint256 _age) public {
        if (_age > 18 || _age == 18) {
            checkEligibility(_age);
        } else {
            s_Status = eligible_Status.underage;
        }
    }
}

// contract filesImport {
//     // ncjIIBLKC
// }
