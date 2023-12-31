// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../../src/test/Implementation.sol";

contract SolBinTest is Test {
    Implementation public solbin;

    function setUp() public {
        solbin = new Implementation();
    }

    function testToBinaryStringUnit() public {
        uint256 n = 0;
        assertEq(solbin.toBinaryString(n), "0");
        n = 2;
        assertEq(solbin.toBinaryString(n), "10");
        n = 128;
        assertEq(solbin.toBinaryString(n), "10000000");
        n = 178237891274893129;
        assertEq(solbin.toBinaryString(n), "1001111001001110100110101011110010111101000110011101001001");

        n = 2 ** 200;
        assertEq(
            solbin.toBinaryString(n),
            "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        );
    }

    function testCountBits() public {
        uint256 n = 2;
        (uint256 set, uint256 unset) = solbin.countBits(n);
        assertEq(set, 1);
        assertEq(unset, 255);
        n = 7839278349278923;
        (set, unset) = solbin.countBits(n);
        assertEq(set, 31);
        assertEq(unset, 225);
        n = 2 ** 230 - 15;
        (set, unset) = solbin.countBits(n);
        assertEq(set, 227);
        assertEq(unset, 29);
    }

    function testToBinaryStringFillAllBits() public {
        uint256 n = 2;
        assertEq(
            solbin.toBinaryStringFillAllBits(n, false),
            "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010"
        );
        n = 128;
        assertEq(
            solbin.toBinaryStringFillAllBits(n, false),
            "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000"
        );
        n = 178237891274893129;
        assertEq(
            solbin.toBinaryStringFillAllBits(n, false),
            "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001111001001110100110101011110010111101000110011101001001"
        );
        n = 2 ** 200;
        assertEq(
            solbin.toBinaryStringFillAllBits(n, false),
            "0000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
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

    function testSetBit() public {
        uint256 n = 124;
        assertEq(solbin.setBit(n, 1, true), n + 2 ** 1);
        assertEq(solbin.setBit(n, 1, false), n);
        assertEq(solbin.setBit(n, 3, false), n - 2 ** 3);
        assertEq(solbin.setBit(n, 3, true), n);
        n = 1232478238944;
        assertEq(solbin.setBit(n, 7, false), n - 2 ** 7);
        assertEq(solbin.setBit(n, 15, true), n + 2 ** 15);
        assertEq(solbin.setBit(n, 3, false), n);
        assertEq(solbin.setBit(n, 6, true), n);
        n = 2 ** 127;
        assertEq(solbin.setBit(n, 127, false), 0);
    }

    function testGetBit() public {
        uint256 n = 124;
        assertFalse(solbin.getBit(n, 1));
        assertTrue(solbin.getBit(n, 4));
        n = 1232478238944;
        assertTrue(solbin.getBit(n, 7));
        assertFalse(solbin.getBit(n, 15));
        n = 2 ** 127;
        assertTrue(solbin.getBit(n, 127));
    }

    function testInsert() public {
        uint256 n = 1290;
        assertEq(solbin.insert(n, 4, 0), n);
        assertEq(solbin.insert(n, 5, 23), 1770);
        assertEq(solbin.insert(n, 6, 2), 1418);
        n = 18923012;
        assertEq(solbin.insert(n, 1, 0), n);
        assertEq(solbin.insert(n, 8, 7), 18923268);
        assertEq(solbin.insert(n, 0, 1), 18923013);
        assertEq(solbin.insert(n, 24, 1), n);
        assertEq(solbin.insert(n, 24, 0), 2145796);
        assertEq(solbin.insert(n, 25, 2173812321), 72941037724679684);       
    }
}

