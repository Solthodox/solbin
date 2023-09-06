// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../../src/test/Implementation.sol";
// 34244 | 7907   | 144618 | 6
contract SolBinTest is Test {
    Implementation public solbin;

    function setUp() public {
        solbin = new Implementation();
    }

    function testNullToBinaryStringUnit() public {
        uint256 n = 0;
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryString(n))), keccak256(abi.encodePacked("0")));
    }

    function testUint256ToBinaryStringUnit() public {
        uint256 n = 2;
        solbin.toBinaryString(n);
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryString(n))), keccak256(abi.encodePacked("10")));
        n = 128;
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryString(n))), keccak256(abi.encodePacked("10000000")));
        n = 178237891274893129;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryString(n))),
            keccak256(abi.encodePacked("1001111001001110100110101011110010111101000110011101001001"))
        );
        n = 2 ** 200;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryString(n))),
            keccak256(
                abi.encodePacked(
                    "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                )
            )
        );
    }

    
}
