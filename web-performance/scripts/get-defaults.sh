#!/bin/bash
# get-defaults.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Emojis
FILE_EMOJI="📄"
GREEN_CIRCLE="🟢"
RED_CIRCLE="🔴"

CONFIG_FILE="web-tauras-performance-testing/web-performance/config/test-config.properties"

# Function to get value from properties file
get_property() {
  grep "^$1=" "$CONFIG_FILE" | cut -d'=' -f2
}

# Load default values from the properties file
echo -e "${YELLOW}${FILE_EMOJI} Loading defaults from configuration file: ${FILE_EMOJI} $CONFIG_FILE${BLUE}"

THREADS_NUMBER=$(get_property "threadsNumber")
ENV=$(get_property "env")
TIME=$(get_property "time")
TEST_TAG=$(get_property "testTag")
# FOLDER_PATH=$(get_property "folderPath")
# FOLDER_NAME=$(get_property "folderName")

# Provide fallback default values if properties are empty or undefined
THREADS_NUMBER=${THREADS_NUMBER:-10}
ENV=${ENV:-prod}
TIME=${TIME:-10}
TEST_TAG=${TEST_TAG:-"false"}
# FOLDER_PATH=${FOLDER_PATH:-/path/to/folder}
# FOLDER_NAME=${FOLDER_NAME:-yourTestFolderName}

# Export default values as environment variables
echo -e "${GREEN}${GREEN_CIRCLE} Default values loaded and exported as environment variables.${RESET}"
echo "THREADS_NUMBER=${THREADS_NUMBER}" >> $GITHUB_ENV
echo "ENV=${ENV}" >> $GITHUB_ENV
echo "TIME=${TIME}" >> $GITHUB_ENV
echo "TEST_TAG=${TEST_TAG}" >> $GITHUB_ENV
#echo "FOLDER_PATH=${FOLDER_PATH}" >> $GITHUB_ENV
#echo "FOLDER_NAME=${FOLDER_NAME}" >> $GITHUB_ENV
