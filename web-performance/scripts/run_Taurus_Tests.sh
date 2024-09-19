#!/bin/bash
echo -e "\033[0;32mTaking control on Commandline:\033[0m"

# Load environment variables
source $GITHUB_ENV

# Convert test files list into an array
IFS=' ' read -r -a testList <<< "$TESTFILES_LIST"
echo -e "\033[0;32m$TESTFILES_LIST\033[0m"
# Set the thread count
THREAD_COUNT="$THREADS_NUMBER"
export THREAD_COUNT
echo "THREAD_COUNT: $THREAD_COUNT"
echo -e "\033[0;32mAssigned threads:\033[0m"
#sleep 5;
echo -e "\033[0;32mJmeter Jmx executions executions:\033[0m"
# Source the jmx_executor.sh script
chmod +x ./web-performance/scripts/jmx_executor.sh
source ./web-performance/scripts/jmx_executor.sh
echo -e "\033[0;32mTaking Access for Jmx executions executions:\033[0m"
echo -e "\033[0;32mGiving Inputs of Test Files:\033[0m"
# Call the function to process test files
get_test_files_for_execution "${testList[@]}"
