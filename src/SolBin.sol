// SPDX-License-Identifier: MIT
/// @notice Library for working with binary numbers, including conversions, bit counting, and Hamming distance calculation.
/// @author Solthodox (https://github.com/Solthodox/solbin)

pragma solidity ^0.8.4;

import "forge-std/console.sol";

library SolBin {
    /// @dev Returns the binary string representation of a uint256 value.
    /// @param value The decimal value to convert to binary.
    /// @return str Binary string representation of the input value.
    /// @notice This function efficiently converts a decimal value to its binary representation as a string.
    function toBinaryString(uint256 value) internal pure returns (string memory str) {
        /// @solidity memory-safe-assembly
        assembly {
            // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
            // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 word for the trailing zeros padding, 1 word for the length,
            // and 8 words for a maximum of 256 digits.
            str := add(mload(0x40), 0x120)
            // Update the free memory pointer to allocate.
            mstore(0x40, add(str, 0x20))
            // Zeroize the slot after the string.
            mstore(str, 0)
            // Cache the end of the memory to calculate the length later.
            let end := str
            let w := not(0) // Tsk.
            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            for { let temp := value } 1 {} {
                str := add(str, w) // `sub(str, 1)`.
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 2)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 2)
                if iszero(temp) { break }
            }
            let length := sub(end, str)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 0x20)
            // Store the length.
            mstore(str, length)
        }
    }

    /// @dev Returns the binary string representation of a uint256 value with a "0b" prefix.
    /// @param value The decimal value to convert to binary.
    /// @return Binary string representation with a "0b" prefix.
    function toBinaryStringPrefixed(uint256 value) internal pure returns (string memory) {
        return string.concat("0b", toBinaryString(value));
    }

    /// @dev Returns the binary string representation of a uint256 value, filling all leading zeros to a total length of 256 characters.
    /// @param value The decimal value to convert to binary.
    /// @return Binary string representation with leading zeros.
    function toBinaryStringFillAllBits(uint256 value) internal pure returns (string memory) {
        string memory bin = toBinaryString(value);
        uint256 len = bytes(bin).length;
        if (len < 256) {
            bytes memory leadingZeroes = new bytes(256-len);
            for (uint256 i = 0; i < 256 - len;) {
                leadingZeroes[i] = 0x30;
                unchecked {
                    ++i;
                }
            }
            bin = string.concat(string(leadingZeroes), bin);
        }
        return bin;
    }

    /// @dev Returns the binary string representation of a uint256 value with a "0b" prefix, filling all leading zeros to a total length of 256 characters.
    /// @param value The decimal value to convert to binary.
    /// @return Binary string representation with "0b" prefix and leading zeros.
    function toBinaryStringFillAllBitsPrefixed(uint256 value) internal pure returns (string memory) {
        return string.concat("0b", toBinaryStringFillAllBits(value));
    }

    /// @dev Returns the number of set (1) and unset (0) bits in a binary string.
    /// @param bin The binary string to analyze.
    /// @return set The count of set bits.
    /// @return unset The count of unset bits.
    /// @notice This function counts the number of '1's and '0's in the binary string and returns the counts as (set, unset).
    function countBits(string memory bin) internal pure returns (uint256 set, uint256 unset) {
        //cast to bytes
        bytes memory _bin = bytes(bin);
        // cache length
        uint256 len = _bin.length;
        // loop thorugh bytes
        unchecked {
            for (uint256 i = 0; i < len;) {
                // bytes1 0x31 == "1"
                if (_bin[i] == 0x31) {
                    set++;
                }
                // bytes1 0x30 == "0"
                else if (_bin[i] != 0x30 && _bin[i] != 0x31) {
                    revert("Invalid binary");
                }
                ++i;
            }
            unset = len - set;
        }
        return (set, unset);
    }

    /// @dev Returns the Hamming distance between two equal-length binary strings.
    /// @param bin1 The first binary string.
    /// @param bin2 The second binary string.
    /// @return distance The Hamming distance between the two binary strings.
    /// @notice The Hamming distance is the number of positions at which the bits differ between two binary strings of equal length.
    function getHammingDistance(string memory bin1, string memory bin2) internal pure returns (uint256 distance) {
        bytes memory _bin1;
        bytes memory _bin2;
        assembly {
            _bin1 := bin1
            _bin2 := bin2
        }
        uint256 len = _bin1.length;
        require(_bin2.length == len, "len");
        for (uint256 i = 0; i < len;) {
            unchecked {
                // for each bit that is different the distance increases by 1
                if (_bin1[i] != _bin2[i]) distance++;
                ++i;
            }
        }
    }

    /// @dev Converts a binary string to a decimal uint256 value.
    /// @param bin The binary string to convert.
    /// @return res The decimal representation of the binary string.
    function from(string memory bin) internal pure returns (uint256) {
        uint256 res;
        bytes memory _bin = bytes(bin);
        uint256 len = _bin.length;
        for (uint256 i = 0; i < len;) {
            if (_bin[len - i - 1] == 0x31) {
                res += 2 ** i;
            }
            unchecked {
                ++i;
            }
        }
        return res;
    }

    /// @dev Inserts or modifies a bit at a specific position in a binary number.
    /// @param value The original binary number.
    /// @param bitPosition The position (1-based) of the bit to insert or modify.
    /// @param set A boolean indicating whether to set the bit to 1 (true) or 0 (false).
    /// @return The modified binary number.
    function insert(uint256 value, uint8 bitPosition, bool set) internal pure returns (uint256) {
        // isolate the bit
        uint256 _value = (value & (1 << bitPosition));
        // if the bit is already as desired return the initial value
        if ((_value != 0 && set) || (_value == 0 && !set)) {
            return value;
        }
        // if not add or substract the bit decimal depresentation
        else {
            if (_value != 0) return value - (2 ** bitPosition);
            if (_value == 0) return value + (2 ** bitPosition);
        }
    }

    /// @dev Returns wether a specific bit of a number is set(true) o r unset(false)
    /// @param value The original binary number.
    /// @param bitPosition The position (1-based) of the bit to read.
    function get(uint256 value, uint8 bitPosition) internal pure returns(bool) {
        return (value & (1 << bitPosition)) != 0;
    }
}
