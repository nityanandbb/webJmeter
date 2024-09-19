# verify_file_name.sh
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Emojis
FILE_EMOJI="📄"
RED_CIRCLE="🔴"
GREEN_CIRCLE="🟢"
CROSS_MARK="❌"
CHECK_MARK="✅"

# Function to print error messages
print_error() {
  local message="$1"
  echo -e "${RED}${RED_CIRCLE} ${CROSS_MARK} Error: ${message}${RESET}"
}

# Function to print success messages
print_success() {
  local message="$1"
  echo -e "${GREEN}${GREEN_CIRCLE} ${CHECK_MARK} ${message}${RESET}"
}

# Function to check if a file exists
verify_file_exists() {
  local file_path="$1"
  
  if [ -f "$file_path" ]; then
    print_success "File found: ${FILE_EMOJI} $file_path"
    echo "$file_path" # Return the found path
    return 0
  else
    print_error "File not found: ${FILE_EMOJI} $file_path"
    return 1
  fi
}

# Parse inputs
FILE_NAME="$1"
FOLDER_PATH="$2"
PARENT_FOLDER_PATH="$3"

# Verify file in paths
if [ -z "$FILE_NAME" ]; then
  print_error "'file_name' is mandatory and must be provided."
  exit 1
fi

FILE_PATH=$(./scripts/verify_paths.sh "$FILE_NAME" "$FOLDER_PATH" "$PARENT_FOLDER_PATH")
if [ $? -ne 0 ]; then
  exit 1
fi

echo "$FILE_PATH"
