// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MonthlyBooksNFTSection is ERC721URIStorage {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	string[] firstBooks = [
		"The lean startup",
		"Getting to plan B",
		"Sprint",
		"The way of the wolf",
		"There are no rules",
		"The 4 hour work week"
	];
	string[] secondBooks = [
		"Atomic habits",
		"The talent code",
		"Writing that works",
		"Show your work!",
		"Why we sleep",
		"Rich dad poor dad"
	];
	string[] thirdBooks = [
		"The intelligent investor",
		"One million followers",
		"That will never work",
		"The art of the war",
		"Measure what matters",
		"Limitless"
	];

	event NewMonthlyBookSectionNFTMinted(address sender, uint256 tokenId);

	constructor() ERC721("SquareNFT", "SQUARE") {
		console.log("This is my NFT contract. Woah!");
		_tokenIds.increment();
	}

	function random(string memory input) internal pure returns (uint256) {
		return uint256(keccak256(abi.encodePacked(input)));
	}

	function pickRandomFirstBook(uint256 tokenId)
		public
		view
		returns (string memory)
	{
		return pluck(tokenId, "FIRST_BOOK", firstBooks);
	}

	function pickRandomSecondBook(uint256 tokenId)
		public
		view
		returns (string memory)
	{
		return pluck(tokenId, "SECOND_BOOK", secondBooks);
	}

	function pickRandomThirdBook(uint256 tokenId)
		public
		view
		returns (string memory)
	{
		return pluck(tokenId, "THIRD_BOOK", thirdBooks);
	}

	function pluck(
		uint256 tokenId,
		string memory keyPrefix,
		string[] memory sourceArray
	) internal pure returns (string memory) {
		uint256 rand = random(
			string(abi.encodePacked(keyPrefix, Strings.toString(tokenId)))
		);
		string memory output = sourceArray[rand % sourceArray.length];
		return output;
	}

	function makeMonthlyBooksNFT() public {
		uint256 newItemId = _tokenIds.current();
		require(newItemId <= 2000, "nft_limit_number_reached");

		string[7] memory parts;

		parts[
			0
		] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: rgba(8,145,178,1); font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#101726" /><text x="10" y="20" class="base">';

		parts[1] = pickRandomFirstBook(newItemId);

		parts[2] = '</text><text x="10" y="40" class="base">';

		parts[3] = pickRandomSecondBook(newItemId);

		parts[4] = '</text><text x="10" y="60" class="base">';

		parts[5] = pickRandomThirdBook(newItemId);

		parts[6] = "</text></svg>";

		string memory finalSvg = string(
			abi.encodePacked(
				parts[0],
				parts[1],
				parts[2],
				parts[3],
				parts[4],
				parts[5],
				parts[6]
			)
		);

		// Get all the JSON metadata in place and base64 encode it.
		string memory json = Base64.encode(
			bytes(
				string(
					abi.encodePacked(
						'{"name": "EDMBN book recommendation #',
						// We set the title of our NFT as the generated word.
						Strings.toString(newItemId),
						'", "description": "EDMBN monthly book recommendation", "image": "data:image/svg+xml;base64,',
						// We add data:image/svg+xml;base64 and then append our base64 encode our svg.
						Base64.encode(bytes(finalSvg)),
						'"}'
					)
				)
			)
		);

		// Just like before, we prepend data:application/json;base64, to our data.
		string memory finalTokenUri = string(
			abi.encodePacked("data:application/json;base64,", json)
		);

		console.log("\n--------------------");
		console.log(finalTokenUri);
		console.log("--------------------\n");

		_safeMint(msg.sender, newItemId);

		// Update your URI!!!
		_setTokenURI(newItemId, finalTokenUri);

		_tokenIds.increment();
		console.log(
			"An NFT w/ ID %s has been minted to %s",
			newItemId,
			msg.sender
		);
		emit NewMonthlyBookSectionNFTMinted(msg.sender, newItemId);
	}

	function getTotalNFTsMinted() public view returns (uint256) {
		uint256 nextItemId = _tokenIds.current();
		return nextItemId - 1;
	}
}
