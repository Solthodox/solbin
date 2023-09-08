// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../../src/test/Implementation.sol";

contract SolBinTest is Test {
    Implementation public solbin;

    function setUp() public {
        solbin = new Implementation();
    }

    function testNullToBinaryStringUnit() public {
        uint256 n = 0;
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryString(n))), keccak256(abi.encodePacked("0")));
    }

    function testToBinaryStringUnit() public {
        uint256 n = 2;
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryString(n))), keccak256(abi.encodePacked("10")));
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryStringPrefixed(n))), keccak256(abi.encodePacked("0b10")));
        n = 128;
        assertEq(keccak256(abi.encodePacked(solbin.toBinaryString(n))), keccak256(abi.encodePacked("10000000")));
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringPrefixed(n))), keccak256(abi.encodePacked("0b10000000"))
        );
        n = 178237891274893129;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryString(n))),
            keccak256(abi.encodePacked("1001111001001110100110101011110010111101000110011101001001"))
        );

        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringPrefixed(n))),
            keccak256(abi.encodePacked("0b1001111001001110100110101011110010111101000110011101001001"))
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

        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringPrefixed(n))),
            keccak256(
                abi.encodePacked(
                    "0b100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                )
            )
        );
    }

    function testCountBits() public {
        uint256 n = 2;
        (uint256 set, uint256 unset) = solbin.countBits(solbin.toBinaryString(n));
        assertEq(set, 1);
        assertEq(unset, 1);
        n = 7839278349278923;
        (set, unset) = solbin.countBits(solbin.toBinaryString(n));
        assertEq(set, 31);
        assertEq(unset, 22);
        n = 2 ** 230 - 15;
        (set, unset) = solbin.countBits(solbin.toBinaryString(n));
        assertEq(set, 227);
        assertEq(unset, 3);
    }

    function testToBinaryStringFillAllBits() public {
        uint256 n = 2;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringFillAllBits(n))),
            keccak256(
                abi.encodePacked(
                    "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010"
                )
            )
        );
        n = 128;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringFillAllBits(n))),
            keccak256(
                abi.encodePacked(
                    "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000"
                )
            )
        );
        n = 178237891274893129;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringFillAllBits(n))),
            keccak256(
                abi.encodePacked(
                    "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001111001001110100110101011110010111101000110011101001001"
                )
            )
        );
        n = 2 ** 200;
        assertEq(
            keccak256(abi.encodePacked(solbin.toBinaryStringFillAllBits(n))),
            keccak256(
                abi.encodePacked(
                    "0000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                )
            )
        );
    }

    function testFrom() public {
        assertEq(solbin.from("10"), 2);
        assertEq(solbin.from("10011010000"), 1232);
        assertEq(solbin.from("101111000011100010011000011100010110100100001001001011110011001"), 6781378945343592345);
        assertEq(
            solbin.from(
                "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            ),
            2 ** 137
        );
    }

    function testInsert() public {
        uint256 n = 124;
        assertEq(solbin.insert(n, 1, true), n + 2**1);
        assertEq(solbin.insert(n, 1, false), n);
        assertEq(solbin.insert(n, 3, false), n - 2**3);
        assertEq(solbin.insert(n, 3, true), n);
        n = 1232478238944;
        assertEq(solbin.insert(n, 7, false), n - 2**7);
        assertEq(solbin.insert(n, 15, true), n + 2**15);
        assertEq(solbin.insert(n, 3, false), n);
        assertEq(solbin.insert(n, 6, true), n);
        n = 2**127;
        assertEq(solbin.insert(n, 127, false), 0);
    }
}
