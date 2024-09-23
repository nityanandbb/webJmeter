#!/bin/bash

# Function to copy a file and rename it
copy_file() {
  local source_file="$1"
  local folder_path="$(dirname "$source_file")" # Get the folder path
  local base_name="$(basename "$source_file" .jmx)" # Get the base name without extension
  local dest_file="${folder_path}/${base_name}_temp.jmx" # Create new file name

  if [ -f "$source_file" ]; then
    cp "$source_file" "$dest_file"
    echo -e "\033[32m✅ File copied successfully: \033[34m$dest_file\033[0m" # Green text with blue filename
    echo "$dest_file" # Return the new file name
  else
    echo -e "\033[31m❌ Error: $source_file does not exist.\033[0m" # Red error message
    return 1
  fi
}

# Call the function and pass the file path argument
copy_file "$1"
