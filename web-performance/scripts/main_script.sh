#!/bin/bash

# Source the jmx_executor.sh script
# source ./web-performance/scripts/jmx_executor.sh

testList=("testfile1|/path/to/folder1/" "testfile2|/path/to/folder2/" "Literature.jmx|web-performance/jmeter/tests/performance/" "Orders.jmx|")
# Set the thread count
THREAD_COUNT="15"
export THREAD_COUNT
echo "THREAD_COUNT input : $THREAD_COUNT"
source ./web-performance/scripts/jmx_executor.sh
get_test_files_for_execution "${testList[@]}"

# act workflow_dispatch -e '{"threadnumber": 10, "testfilesList": "testfile1|/path/to/folder1/ testfile2|/path/to/folder2/ "Literature.jmx|web-performance/jmeter/tests/performance/" "Orders.jmx|", "baseurl": "http://example.com", "timeDuration": "1h"}'
