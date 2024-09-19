#!/bin/bash

# Load the properties from the configuration file
CONFIG_FILE="web-performance/jmeter/config/test_execution.properties"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Read properties
test_files=$(grep 'test_files' "$CONFIG_FILE" | cut -d'=' -f2)
num_threads=$(grep 'num_threads' "$CONFIG_FILE" | cut -d'=' -f2)

# Convert comma-separated list of test files to array
IFS=',' read -r -a test_file_array <<< "$test_files"

# Loop through each test file and execute it with the specified number of threads
for test_file in "${test_file_array[@]}"; do
    if [[ -f "$test_file" ]]; then
        echo "Running test: $test_file with $num_threads threads"
        jmeter -n -t "$test_file" -Jthreads="$num_threads" -l "reports/latest/$(basename "$test_file" .jmx)_result.jtl" || {
            echo "Test $test_file failed"
        }
    else
        echo "Test file not found: $test_file"
    fi
done

echo "All tests executed."
