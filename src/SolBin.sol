// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

library SolBin {
    function toBinaryString(uint256 number) internal pure returns (string memory) {
        if (number == 0) {
            return "0";
        }

        uint256 temp = number;
        uint256 length;

        while (temp != 0) {
            length++;
            temp /= 2;
        }

        bytes memory result = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            result[length - i - 1] = bytes1(uint8(48 + number % 2));
            number /= 2;
        }

        return string(result);
    }
}
