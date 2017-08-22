#!/bin/bash
if [[ $(pwd) == "/foo" ]]; then 
   echo "PASSED"
   exit 0
else
   echo "FAILED: pwd="
   $(pwd)
   exit 1
fi
