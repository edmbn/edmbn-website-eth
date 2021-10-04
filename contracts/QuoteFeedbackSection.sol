// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract QuoteFeedbackSection {
    uint256 totalLikes;
    uint256 totalDislikes;
    uint256 private seed;

    event NewQuoteFeedback(
        address indexed from,
        uint256 timestamp,
        bool quoteLiked
    );

    struct QuoteFeedback {
        bool quoteLiked;
        uint256 timestamp;
    }

    mapping(address => QuoteFeedback) public quoteFeedback;

    constructor() payable {
        console.log("Contract deployed");
    }

    function getRandomNumber() private returns (uint256) {
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
            100;

        console.log("Random # generated: %s", randomNumber);

        seed = randomNumber;

        return randomNumber;
    }

    function getPrizeResult() private {
        uint256 randomNumber = getRandomNumber();
        /*
         * Give a 5% chance that the user wins the prize.
         */
        if (randomNumber < 5) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;

            require(
                prizeAmount <= address(this).balance,
                "insuficient_balance_on_contract"
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");

            require(success, "Failed to withdraw money from contract.");
        }
    }

    function like() public {
        require(
            quoteFeedback[msg.sender].timestamp == 0,
            "sender_already_sent_feedback"
        );

        totalLikes += 1;
        quoteFeedback[msg.sender].quoteLiked = true;
        quoteFeedback[msg.sender].timestamp = block.timestamp;

        console.log("%s liked!", msg.sender);

        getPrizeResult();

        emit NewQuoteFeedback(msg.sender, block.timestamp, true);
    }

    function dislike() public {
        require(
            quoteFeedback[msg.sender].timestamp == 0,
            "sender_already_sent_feedback"
        );

        totalDislikes += 1;
        quoteFeedback[msg.sender].quoteLiked = false;
        quoteFeedback[msg.sender].timestamp = block.timestamp;

        console.log("%s disliked!", msg.sender);

        getPrizeResult();

        emit NewQuoteFeedback(msg.sender, block.timestamp, false);
    }

    function addressFeedbacked() public view returns (bool, bool) {
        bool senderFeedbacked = quoteFeedback[msg.sender].timestamp != 0;
        bool feedbackValue;
        if (senderFeedbacked == true) {
            feedbackValue = quoteFeedback[msg.sender].quoteLiked;
        }
        return (senderFeedbacked, feedbackValue);
    }

    function getTotalLikes() public view returns (uint256) {
        console.log("We have %d total likes", totalLikes);
        return totalLikes;
    }

    function getTotalDislikes() public view returns (uint256) {
        console.log("We have %d total dislikes", totalDislikes);
        return totalDislikes;
    }
}
