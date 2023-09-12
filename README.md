# SolBin - Solidity Binary Utility Library

![License](https://img.shields.io/badge/license-MIT-blue)
[![Solidity Version](https://img.shields.io/badge/solidity-%5E0.8.4-brightgreen)](https://soliditylang.org/)

SolBin is a Solidity library that provides various utility functions for working with binary numbers. It includes functions for converting decimal numbers to binary strings, counting bits, calculating Hamming distances, and more.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Functions](#functions)
- [Examples](#examples)
- [License](#license)

## Installation

You can install SolBin in your Solidity project via Foundry:

```shell
forge install solthodox/solbin
```

## Usage

SolBin offers a set of utility functions for binary manipulation. Here's an overview of how to use it:

### Converting Decimal to Binary

```solidity
// Convert a decimal number to a binary string
uint256 value = 42;
string memory binaryString = value.toBinaryString();
```

### Counting Set and Unset Bits

```solidity
// Count the set and unset bits in a binary string
(uint256 setBits, uint256 unsetBits) = ("101001").countBits();
```

### Calculating Hamming Distance

```solidity
// Calculate the Hamming distance between two decimal numbers
uint256 distance = SolBin.getHammingDistance(46, 139);
```

### And more...

SolBin provides additional utility functions for various binary operations.

## Functions

- `toBinaryString(uint256 value)`: Converts a decimal number to a binary string.
- `toBinaryStringFillAllBits(uint256 value, bool fillWithOnes)`: Converts a decimal number to a binary string with leading zeros to a total length of 256 characters.
- `countBits(string memory bin)`: Counts the number of set (1) and unset (0) bits in a binary string.
- `getHammingDistance(string memory bin1, string memory bin2)`: Calculates the Hamming distance between two equal-length binary strings.
- `from(string memory bin)`: Creates a `uint256` from its binary representation.
- `set(string memory bin)`: Modifies a bit of a decimal number.
- `get(string memory bin)`: Reads a bit of a decimal number.
- `insert(uint256 value, uint8 bitPosition, bool set)`: Manipulates uint256 numbers bit by bit.

## Examples

Solbin's main purpose is to be used in testing environments where binary representations play an importante role(e.g. bitmaps).

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract BitMapContract{
    /** bitmap:
            bit 0 => condition1
            bit 1 => condition1
            bit 2 => condition1
            bit 3 => condition1
            bit 4 => condition1
            bit 5 to 160 => some address
    */
    function foo(uint256 bitmap) {
        //-
    }
}

```

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "forge-std/Test.sol";
import "src/SolBin.sol";
import "src/BitMapContract.sol";

contract BitMapContractTest is Test{
    using SolBin for uint256;
    using SolBin for string;

    BitMapContract public a;

    function setUp(){
        a = new BitMapContract();
    }

    function testFoo() {
        uint256 bitmap=0;
        // manipulate each byte easily
        bitmap = bitmap
            .set(0,true)
            .set(1,false)
            .set(2,true)
            .set(3,false)
            .set(4,true)
            .insert(5,uint160(0x0A3ae5b19b14920fa6a7AC9d0D5Fb6aEfaaDcc84))

        // check out the result in console
        console.log("bitmap bin : ", bitmap.toBinaryString());

        a.foo(bitmap);

        //...


    }
}

```

## License

SolBin is released under the [MIT License](LICENSE).
