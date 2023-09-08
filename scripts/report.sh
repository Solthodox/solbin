#!/bin/bash
if[-n "$1"] then 
    echo "Running forge test --match-test "$1" --gas-report..."
    forge test --match-test "$1" --gas-report | tee .gas-report.txt 
else
    echo "Running forge test --gas-report..."
    forge test --gas-report | tee .gas-report.txt 
fi