#!/bin/bash

# Source the jmx_executor.sh script
source ./web-performance/scripts/jmx_executor.sh

testList=("T5.jmx|" "new_assignment1.jmx|web-performance/jmeter/tests/performance/" "testfile2|/path/to/folder2/" "qedco.jmx|web-performance/jmeter/tests/performance/" "qed42.jmx|" "udv.jmx|" "Tem1.jmx|")
testList1=("Tem1.jmx|")
# Set the thread count
THREAD_COUNT="14"
export THREAD_COUNT
echo "THREAD_COUNT input : $THREAD_COUNT"
source ./web-performance/scripts/jmx_executor.sh
get_test_files_for_execution "${testList1[@]}"

# act workflow_dispatch -e '{"threadnumber": 10, "testfilesList": "testfile1|/path/to/folder1/ testfile2|/path/to/folder2/ "Literature.jmx|web-performance/jmeter/tests/performance/" "Orders.jmx|", "baseurl": "http://example.com", "timeDuration": "1h"}'
