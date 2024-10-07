#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if xmlstarlet is installed
if ! command -v xmlstarlet &> /dev/null; then
    echo -e "${RED}Error: xmlstarlet is not installed.${NC}"
    echo "Please install xmlstarlet using your package manager."
    exit 1
fi

# Check if parameters are provided
if [ "$#" -lt 1 ]; then
    echo -e "${RED}Error: Missing test file.${NC}"
    echo "Usage: $0 <test_file.jmx> [thread_count]"
    exit 1
fi

# Variables
TEST_FILE=$1
THREAD_COUNT=${2:-1}  # Default to 1 if not provided

# Check if the test file exists
if [ ! -f "$TEST_FILE" ]; then
    echo -e "${RED}Error: Test file '$TEST_FILE' does not exist.${NC}"
    exit 1
fi

# Check if the thread count is a valid number
if ! [[ "$THREAD_COUNT" =~ ^[0-9]+$ ]] || [ "$THREAD_COUNT" -eq 0 ]; then
    echo -e "${RED}Error: Thread count must be a positive integer greater than 0.${NC}"
    exit 1
fi

# Save the original thread count value to revert later
ORIGINAL_THREAD_COUNT=$(xmlstarlet sel -t -v "//ThreadGroup/*[@name='ThreadGroup.num_threads']" "${TEST_FILE}")

# Update thread count in the .jmx file
echo "Updating thread count in $1 to $2"
echo -e "${YELLOW}Updating thread count in ${TEST_FILE} to ${THREAD_COUNT}${NC}"
xmlstarlet ed -u "//ThreadGroup/*[@name='ThreadGroup.num_threads']" -v "${THREAD_COUNT}" "${TEST_FILE}" > "${TEST_FILE}.tmp" && mv "${TEST_FILE}.tmp" "${TEST_FILE}"

# If the script is called with no second argument, it is not supposed to run anything, just update
if [ "$THREAD_COUNT" != "1" ]; then
    echo -e "${GREEN}Thread count updated to ${THREAD_COUNT}${NC}"
else
    echo -e "${GREEN}Reverted thread count to original value of ${ORIGINAL_THREAD_COUNT}${NC}"
fi

echo -e "${GREEN}Operation completed successfully.${NC}"
