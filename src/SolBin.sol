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

    /// @dev Returns the binary string representation of a uint256 value, filling all leading zeros to a total length of 256 characters.
    /// @param value The decimal value to convert to binary.
    /// @param fillWithOnes false for all leading bits to be zeroes, true for them to be ones.
    /// @return Binary string representation with leading zeros.
    function toBinaryStringFillAllBits(uint256 value, bool fillWithOnes) internal pure returns (string memory) {
        string memory bin = toBinaryString(value);
        uint256 len = bytes(bin).length;
        if (len < 256) {
            bytes memory leadingZeroes = new bytes(256-len);
            for (uint256 i = 0; i < 256 - len;) {
                if(fillWithOnes){
                    leadingZeroes[i] = 0x31;
                }else{
                    leadingZeroes[i] = 0x30;
                }
                unchecked {
                    ++i;
                }
            }
            bin = string.concat(string(leadingZeroes), bin);
        }
        return bin;
    }
    /// @notice Counts the number of set (1) and unset (0) bits in a uint256 value.
    /// @param value The uint256 value to count bits for.
    /// @return setBits The count of set bits (1s).
    /// @return unsetBits The count of unset bits (0s).

    function countBits(uint256 value) public pure returns (uint256 setBits, uint256 unsetBits) {
        uint256 mask = 1;
        for (uint256 i = 0; i < 256; i++) {
            if ((value & mask) != 0) {
                setBits++;
            } else {
                unsetBits++;
            }
            mask <<= 1;
        }
    }

    /// @notice Calculates the Hamming distance between two uint256 values.
    /// @param a The first uint256 value.
    /// @param b The second uint256 value.
    /// @return distance The Hamming distance between the two values.
    function getHammingDistance(uint256 a, uint256 b) internal pure returns (uint256 distance) {
        uint256 xorResult = a ^ b;
        while (xorResult > 0) {
            if (xorResult % 2 == 1) {
                distance++;
            }
            xorResult >>= 1; // Right shift to check the next bit
        }
        return distance;
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

    /// @dev Modifies a bit at a specific position in a binary number.
    /// @param value The original binary number.
    /// @param bitPosition The position (1-based) of the bit to insert or modify.
    /// @param set A boolean indicating whether to set the bit to 1 (true) or 0 (false).
    /// @return The modified binary number.
    function set(uint256 value, uint8 bitPosition, bool set) internal pure returns (uint256) {
        // isolate the bit
        bool targetBit = get(value, bitPosition);
        // if the bit is already as desired return the initial value
        if ((targetBit == true && set) || (targetBit == false && !set)) {
            return value;
        }
        // if not add or substract the bit decimal depresentation
        else {
            if (targetBit == true) return value - (2 ** bitPosition);
            if (targetBit == false) return value + (2 ** bitPosition);
        }
    }

    /// @dev Returns wether a specific bit of a number is set(true) o r unset(false)
    /// @param value The original binary number.
    /// @param bitPosition The position (1-based) of the bit to read.
    function get(uint256 value, uint8 bitPosition) internal pure returns (bool) {
        return (value & (1 << bitPosition)) != 0;
    }

    /// @notice Inserts consecutive bits into a value starting from a specified bit position.
    /// @param value The original binary number.
    /// @param fromBitPosition The initial bit position to start modification from.
    /// @param bits The bits to be introduced consecutively.
    /// @return The modified binary number.
    function insert(uint256 value, uint256 fromBitPosition, uint256 bits) internal view returns (uint256) {
        require(fromBitPosition <= 255, "fromBitPosition must be in the range of 0 to 255");
        
        uint256 len;
        uint256 _bits = bits;
        
        if (bits == 0) {
            len = 1;
        } else {
            // Get the number of bits required to represent 'bits'
            while (_bits > 0) {
                unchecked {
                    len++;
                    _bits >>= 1;
                }
            }
        }
        console.log("len : ", len);
        
        require(256 - fromBitPosition >= len, "Invalid input: insufficient space to insert bits");

        // Create a mask with all the bits set to 1
        uint256 mask = ~uint256(0);
        uint256 from = fromBitPosition;
        uint256 to = fromBitPosition +1 - len;
        unchecked {
            // Shift the mask to the right by 'from' positions
            mask >>= 255 -  from;
            
            // Shift the mask to the left by 'to' positions
            mask <<= to;
            
            // Invert the mask to set 0s in the specified range
            mask = ~mask;
        }
        console.log("mask : ", toBinaryString(mask));

        return (value & mask) | (bits << from);
    }
}
