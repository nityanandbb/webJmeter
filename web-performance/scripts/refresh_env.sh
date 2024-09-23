#!/bin/bash

# Function to clear cache
clear_cache() {
    echo -e "\033[33m📦 Clearing cache...\033[0m"
    # Clear caches without requiring a password
    echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    echo -e "\033[32m✅ Cache cleared!\033[0m"
}

# Function to show memory usage
show_memory_usage() {
    echo -e "\033[34m📊 Current memory usage:\033[0m"
    free -h || { echo -e "\033[31m❌ Error: 'free' command not found.\033[0m"; exit 1; }
}

# Function to kill high memory processes (example)
kill_high_memory_processes() {
    echo -e "\033[31m🔍 Checking for high memory usage...\033[0m"
    
    # List processes sorted by memory usage
    ps aux --sort=-%mem | awk 'NR<=10{print $0}' || { echo -e "\033[31m❌ Error: 'ps' command failed.\033[0m"; exit 1; }
    
    # Automatically kill the top memory-consuming process if desired
    top_pid=$(ps aux --sort=-%mem | awk 'NR==2{print $2}') # Get PID of the highest memory-consuming process
    if [[ ! -z "$top_pid" ]]; then
        echo -e "\033[33m🗑️ Killing process with PID: $top_pid\033[0m"
        kill "$top_pid" && echo -e "\033[32m✅ Process $top_pid killed!\033[0m" || echo -e "\033[31m❌ Failed to kill process $top_pid.\033[0m"
    fi
}

# Main script execution
clear_cache
show_memory_usage
kill_high_memory_processes