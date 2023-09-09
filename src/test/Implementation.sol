// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "../SolBin.sol";

// we use a contract so we can generate gas reports
// do not use this contract in production, use the library directly
// instead
contract Implementation {
    using SolBin for uint256;
    using SolBin for string;

    function toBinaryString(uint256 value) external pure returns (string memory) {
        return value.toBinaryString();
    }

    function countBits(uint256 value) external pure returns (uint256, uint256) {
        return value.countBits();
    }

    function toBinaryStringFillAllBits(uint256 value) external pure returns (string memory) {
        return value.toBinaryStringFillAllBits();
    }

    function from(string memory bin) external pure returns (uint256) {
        return bin.from();
    }

    function set(uint256 value, uint8 bit, bool set) external pure returns (uint256) {
        return value.set(bit, set);
    }

    function getHammingDistance(uint256 a, uint256 b) external pure returns (uint256 distance) {
        return SolBin.getHammingDistance(a, b);
    }

    function get(uint256 value, uint8 bitPosition) external pure returns (bool) {
        return value.get(bitPosition);
    }

    function insert(uint256 value, uint8 fromBitPosition, uint256 bits) external pure returns (uint256) {
        return value.insert(fromBitPosition, bits);
    }
}
