#!/bin/bash
if [[ $(pwd) == "/foo" ]]; then
   echo "PASSED"
   exit 0
else
   echo "FAILED"
   echo "WORKDIR="$(pwd)
   exit 1
fi
