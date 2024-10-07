#!/bin/bash
echo -e "\033[0;32mReciiving Inputs :\033[0m"
# Define color codes and emojis
INFO="ℹ️"
CHECK_MARK="✅"
CROSS_MARK="❌"
WARNING="⚠️"
FILE="📄"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"  # No Color

# Check if a thread count is provided and is a valid number
if [[ -n "$THREAD_COUNT" && "$THREAD_COUNT" =~ ^[0-9]+$ && "$THREAD_COUNT" -gt 0 ]]; then
    echo -e "${INFO} ${YELLOW} Thread count input given - $THREAD_COUNT"
    echo -e "${INFO} ${GREEN}Thread count set to ${THREAD_COUNT}${NC}"
else
    echo -e "${INFO} ${YELLOW}No valid thread count provided. Using default thread count of 1.${NC}"
    THREAD_COUNT=1
fi

# Function to get and verify test files and paths
get_test_files_for_execution() {
    echo -e "\033[0;32mProcessing files\033[0m"
    echo -e "${INFO} ${BLUE}Starting validation of test files and paths...${NC}"
    local testList=("$@")
    local validTestList=()
    local defaultPath="web-performance/jmeter/tests/performance"  # Update this to reflect the correct default path if necessary

    for entry in "${testList[@]}"; do
        echo -e "${INFO} ${BLUE}Processing entry: ${entry}${NC}"

        # Extract testfile and folderpath safely
        local testfile="${entry%%|*}"
        local folderpath="${entry#*|}"

        # Remove any leading or trailing whitespace
        testfile=$(echo "$testfile" | sed 's/^[ \t]*//;s/[ \t]*$//')
        folderpath=$(echo "$folderpath" | sed 's/^[ \t]*//;s/[ \t]*$//')

        # Log the extracted file and path
        echo -e "${INFO} ${BLUE}Extracted file: ${testfile}${NC}"
        echo -e "${INFO} ${BLUE}Extracted folder path: ${folderpath}${NC}"

        # Check if folder path is empty and use the default path if necessary
        if [ -z "$folderpath" ]; then
            echo -e "${INFO} ${YELLOW}Folder path is empty. Using default path: ${defaultPath}${NC}"
            folderpath="${defaultPath}"
        fi

        # Construct the full file path
        local fullPath="${folderpath}/${testfile}"

        # Check if the file exists
        if [ -f "${fullPath}" ]; then
            echo -e "${CHECK_MARK} ${GREEN}Valid file found: ${FILE} ${testfile} in ${folderpath}${NC}"
            validTestList+=("${testfile}|${folderpath}")
        else
            echo -e "${WARNING} ${RED}File not found: ${fullPath}. Please ensure the correct file name and extension are provided (e.g., .jmx or .yaml).${NC}"
        fi
    done

    echo -e "${INFO} ${BLUE}Validation complete.${NC}"

    # Call the execute_tests function with the valid test files
    if [ ${#validTestList[@]} -gt 0 ]; then
        echo -e "${INFO} ${GREEN}Preparing the list of valid test files for execution...${NC}"
        execute_tests "${validTestList[@]}"
    else
        echo -e "${WARNING} ${RED}No valid test files found. Exiting.${NC}"
        exit 1
    fi
}

# Function to execute the tests using the valid test file list
execute_tests() {
    local validTestList=("$@")

    for entry in "${validTestList[@]}"; do
        local testfile="${entry%%|*}"
        local folderpath="${entry#*|}"
        local fullPath="${folderpath}/${testfile}"
        local temp_output="temp_output.log"

        echo -e "${INFO} ${BLUE}Executing ${FILE} ${testfile} from ${folderpath}${NC}"

        # Copy the file using copy_file.sh and store the result in temptestfile
        echo -e "${INFO} ${GREEN}Copying the file for test ${FILE} ${testfile}${NC}"
        chmod +x ./web-performance/scripts/copy_file.sh

        # Extract the file path only, assuming copy_file.sh outputs both success message and path
        temptestfile=$(./web-performance/scripts/copy_file.sh "$fullPath" | tail -n 1)  # Capture only the last line which should be the path
        
        sleep 60
        echo -e "${INFO} ${GREEN}Temp file for test: ${temptestfile}${NC}"

        # Check if the copy was successful
        if [ ! -f "$temptestfile" ]; then
            echo -e "${CROSS_MARK} ${RED}Failed to copy file: ${fullPath}. Aborting.${NC}"
            exit 1
        fi        
       
        # Update thread count in the copied file (temptestfile)
        echo -e "${INFO} ${GREEN}Updating thread count for ${FILE} ${temptestfile}${NC}"
        chmod +x ./web-performance/scripts/threads_count_update.sh
        ./web-performance/scripts/threads_count_update.sh "${temptestfile}" "${THREAD_COUNT}"

        sleep 20
        # Run the bzt command on the copied file (temptestfile) and capture its output
        echo -e "${INFO} ${GREEN}Running bzt on ${FILE} ${temptestfile}${NC}"
        bzt "${temptestfile}" -report 2>&1 | tee "$temp_output"

        # Process the temporary log file to extract URLs
        chmod +x ./web-performance/scripts/extract_urls.sh 
        ./web-performance/scripts/extract_urls.sh "$testfile" < "$temp_output"

        # Clean up the temporary log file
        rm "$temp_output"

        # Adding a sleep to ensure logs appear
        sleep 30

        # Revert thread count after test in the copied file (temptestfile)
        echo -e "${INFO} ${GREEN}Reverting thread count for ${FILE} ${temptestfile}${NC}"
        chmod +x ./web-performance/scripts/threads_count_update.sh
        ./web-performance/scripts/threads_count_update.sh "${temptestfile}" 1  # Revert to default or original thread count if needed

        # Call delete_copy.sh to delete the copied file (temptestfile)
        echo -e "${INFO} ${GREEN}Deleting the copied file ${temptestfile}${NC}"
        chmod +x ./web-performance/scripts/delete_file.sh
        ./web-performance/scripts/delete_file.sh "${temptestfile}"

        # Check if the file deletion was successful
        if [ $? -ne 0 ]; then
            echo -e "${CROSS_MARK} ${RED}Failed to delete the copied file: ${temptestfile}.${NC}"
        else
            echo -e "${CHECK_MARK} ${GREEN}Copied file deleted successfully: ${temptestfile}${NC}"
        fi

    done
}
