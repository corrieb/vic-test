#!/bin/bash
output=$(export) 
matches=$(printf "$output" | grep 'myCat="fluffy"\|myCat2="fluffy"\|myDog="Rex The Dog"\|myDog2="Rex The Dog"\|myName="John Doe"\|myName2="John Doe"' | wc -l)
if [[ $matches == 6 ]]; then 
   echo "PASSED"
   exit 0
else
   echo "FAILED: Output: "
   printf "$output"
   exit 1
fi
