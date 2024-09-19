#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Emojis
FOLDER_EMOJI="📁"
FILE_EMOJI="📄"
GREEN_CIRCLE="🟢"
RED_CIRCLE="🔴"
CHECK_MARK="✅"
CROSS_MARK="❌"

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

# Function to check if a folder exists
verify_folder_exists() {
  local folder_path="$1"
  
  if [ -d "$folder_path" ]; then
    print_success "Folder found: ${FOLDER_EMOJI} $folder_path"
    return 0
  else
    print_error "Folder not found: ${FOLDER_EMOJI} $folder_path"
    return 1
  fi
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

# Main function to verify paths
verify_paths() {
  local file_name="$1"
  local folder_path="$2"
  local parent_folder_path="$3"

  echo -e "${BLUE}${FOLDER_EMOJI} Verifying Paths --- FolderPath: ${FOLDER_EMOJI} $folder_path"
  echo -e "${BLUE}${FOLDER_EMOJI} Verifying Paths --- ParentFolderPath: ${FOLDER_EMOJI} $parent_folder_path"
  echo -e "${YELLOW}${FILE_EMOJI} Verifying File --- file_name: ${FILE_EMOJI} $file_name"

  if [ -z "$file_name" ]; then
    print_error "'file_name' is mandatory and must be provided."
    exit 1
  fi

  local file_found=false

  # Check in the provided folder path if given
  if [ -n "$folder_path" ]; then
    verify_folder_exists "$folder_path"
    if [ $? -eq 0 ]; then
      if verify_file_exists "$folder_path/${file_name}"; then
        file_found=true
      fi
    fi
  fi

  # Check in the parent folder path if folder_path is not given
  if [ -z "$folder_path" ] && [ -n "$parent_folder_path" ]; then
    verify_folder_exists "$parent_folder_path"
    if [ $? -eq 0 ]; then
      if verify_file_exists "jmeter/tests/performance/$parent_folder_path/${file_name}"; then
        file_found=true
      fi
    fi
  fi

  # Default path
  if [ "$file_found" = false ]; then
    if verify_file_exists "jmeter/tests/performance/${file_name}"; then
      file_found=true
    fi
  fi

  # If none of the paths were valid, exit with error
  if [ "$file_found" = true ]; then
    print_success "File successfully verified."
  else
    print_error "File not found in any of the specified paths."
    exit 1
  fi
}

# Parse inputs
FILE_NAME="$1"
FOLDER_PATH="$2"
PARENT_FOLDER_PATH="$3"

# Verify paths
verify_paths "$FILE_NAME"
