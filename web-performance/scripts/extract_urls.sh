#!/bin/bash

# Define color codes
INFO="ℹ️"
CHECK_MARK="✅"
WARNING="⚠️"
FILE="📄"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"  # No Color

# Define the output directory
OUTPUT_DIR="web-performance/reports/taurusReports"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Function to add a unique URL to the output file
add_log_entry() {
    local log_entry="$1"
    local output_file="$2"

    # Check if the log_entry already exists in the output file
    if grep -Fxq "$log_entry" "$output_file"; then
        echo -e "${INFO} ${YELLOW}URL already exists in $output_file: $log_entry${NC}"
    else
        # Add the log_entry to the output file
        echo "$log_entry" >> "$output_file"
        echo -e "${INFO} ${GREEN}URL added to $output_file: $log_entry${NC}"
    fi
}

# Function to extract URLs and add to the output file
extract_urls() {
    local jmx_file="$1"

    # Create the output file name based on the test file name and timestamp
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local output_file="${OUTPUT_DIR}/${jmx_file}_${timestamp}.txt"

    # Create or clear the output file
    > "$output_file"

    # Read from standard input and extract lines containing the specific URL pattern
    while IFS= read -r line; do
        # Extract the URL from the line
        local url
        url=$(echo "$line" | grep -o 'https://a.blazemeter.com/app/?public-token=[^ ]*#reports/r-ext-[^ ]*')

        if [ -n "$url" ]; then
            # Create the log entry string
            local log_entry="${jmx_file}: ${url}"

            # Add log entry to the output file
            add_log_entry "$log_entry" "$output_file"
        fi
    done
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo -e "${RED}Error: Invalid number of arguments. Usage: $0 <jmx_file>${NC}"
    exit 1
fi

# Process input arguments
extract_urls "$1"
