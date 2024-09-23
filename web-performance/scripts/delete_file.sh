#!/bin/bash

# Function to delete a file
delete_file() {
  local file_to_delete="$1"

  if [ -f "$file_to_delete" ]; then
    rm "$file_to_delete"
    echo -e "\033[32m✅ File deleted successfully: \033[34m$file_to_delete\033[0m" # Green text with blue filename
  else
    echo -e "\033[31m❌ Error: $file_to_delete does not exist.\033[0m" # Red error message
    return 1
  fi
}

# Call the function with the provided argument
delete_file "$1"