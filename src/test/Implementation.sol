// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "../SolBin.sol";

contract Implementation {
    using SolBin for uint256;

    function toBinaryString(uint256 number) external pure returns (string memory) {
        return number.toBinaryString();
    }
}
