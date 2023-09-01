// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import "forge-std/Test.sol";
import "../../src/test/Implementation.sol";

contract SolbinTestFFI is Test {
    Implementation public solbin;

    function setUp() public {
        solbin = new Implementation();
    }

    function testUint256ToBinaryStringFFI(uint256 n) public {
        string[] memory cmds = new string[](3);
        cmds[0] = "python3";
        cmds[1] = "./scripts/to_bin.py";
        cmds[2] = numberToString(n);
        bytes memory result = vm.ffi(cmds);
        string memory loadedBinary = abi.decode(result, (string));
        assertEq(keccak256(abi.encodePacked(loadedBinary)), keccak256(abi.encodePacked(solbin.toBinaryString(n))));
    }

    function numberToString(uint256 num) private pure returns (string memory) {
        if (num == 0) {
            return "0";
        }

        uint256 tempNum = num;
        uint256 digits;

        while (tempNum > 0) {
            digits++;
            tempNum /= 10;
        }

        bytes memory buffer = new bytes(digits);
        tempNum = num;

        for (uint256 i = digits; i > 0; i--) {
            buffer[i - 1] = bytes1(uint8(48 + tempNum % 10));
            tempNum /= 10;
        }

        return string(buffer);
    }
}
