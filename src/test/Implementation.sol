// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "../SolBin.sol";

// we use a contract so we can generate gas reports
contract Implementation {
    using SolBin for uint256;
    using SolBin for string;

    function toBinaryString(uint256 value) external pure returns (string memory) {
        return value.toBinaryString();
    }

    function toBinaryStringPrefixed(uint256 value) external pure returns (string memory) {
        return value.toBinaryStringPrefixed();
    }

    function countBits(string memory bin) external pure returns (uint256, uint256) {
        return bin.countBits();
    }

    function toBinaryStringFillAllBits(uint256 value) external pure returns (string memory) {
        return value.toBinaryStringFillAllBits();
    }

    function from(string memory bin) external pure returns (uint256) {
        return bin.from();
    }

    function insert(uint256 value, uint8 bit, bool set) external pure returns (uint256) {
        return value.insert(bit, set);
    }
}
