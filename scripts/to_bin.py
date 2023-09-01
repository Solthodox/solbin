import sys
from eth_abi import encode
# Check the number of arguments passed
if len(sys.argv) < 1:
    print("Usage: python script.py <arg1>")
else:
    # Access command-line arguments
    decimal_number = sys.argv[1]
    bin_number = bin(int(decimal_number))[2:]
    encoded_result = encode(["string"], [bin_number])
    hex_string = ''.join([f'{byte:02x}' for byte in encoded_result])
    solidity_bytes = '0x' + hex_string
    print(solidity_bytes)