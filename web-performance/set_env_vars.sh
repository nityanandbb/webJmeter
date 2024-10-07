#!/bin/bash

# Check if the input script file is provided
if [ -z "$1" ]; then
    echo "⚠️ Warning: No input script file provided."
    echo "Usage: source ./set_env_vars.sh path/to/variables.sh path/to/testfile.jmx"
    return 1
fi

# Check if the test file is provided
if [ -z "$2" ]; then
    echo "⚠️ Warning: No test file provided."
    echo "Usage: source ./set_env_vars.sh path/to/variables.sh path/to/testfile.jmx"
    return 1
fi

# Source the provided input script to load variables
source "$1"

# Log the exported variables
echo -e "🔥 Exported variable: threadCount = $threadCount"
echo -e "🔥 Exported variable: Baseurl = $Baseurl"

# Assign the test file path from the second argument
TEST_FILE="$2"

# Function to update the specified .jmx file
update_jmx_file() {
    local file="$1"
    
    if [[ -f "$file" ]]; then
        echo -e "🔥 Updating file: $file"
        
        # Check for the presence of variables in the .jmx file
        local threadCountPresent=$(grep -q '\${__P(threadCount,1)}' "$file" && echo "true" || echo "false")
        local baseUrlPresent=$(grep -q '\${__P(Baseurl,https://default.com)}' "$file" && echo "true" || echo "false")
        
        # Log the presence of threadCount
        if [[ "$threadCountPresent" == "true" ]]; then
            echo -e "✅ Variable \${__P(threadCount,1)} is present."
        else
            echo -e "⚠️ Warning: As per your input, this .jmx file should have the variable:"
            echo -e "   - \${__P(threadCount,1)} is missing"
        fi

        # Log the presence of Baseurl
        if [[ "$baseUrlPresent" == "true" ]]; then
            echo -e "✅ Variable \${__P(Baseurl,https://default.com)} is present."
        else
            echo -e "⚠️ Warning: As per your input, this .jmx file should have the variable:"
            echo -e "   - \${__P(Baseurl,https://default.com)} is missing"
        fi
    else
        echo -e "❌ Error: The specified JMX file does not exist: $file"
    fi
}

# Update the specified JMX file
update_jmx_file "$TEST_FILE"

# Log all exported variables
echo -e "🔥 All exported variables:"
env | grep -E 'threadCount|Baseurl'
