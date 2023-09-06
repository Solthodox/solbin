// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

library SolBin {

    function toBinaryString(uint256 value) internal pure returns (string memory str) {
        /// @solidity memory-safe-assembly
        assembly {
        // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
        // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
        // We will need 1 word for the trailing zeros padding, 1 word for the length,
        // and 8 words for a maximum of 256 digits.
        str := add(mload(0x40), 0x120) // al stack
        // Update the free memory pointer to allocate.
        mstore(0x40, add(str, 0x20)) // 0x120 en slot 0x40
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
        mstore8(str, add(48, mod(temp,2)))
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
}

