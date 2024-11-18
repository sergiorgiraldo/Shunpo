#!/bin/bash

# Colors and formatting
CYAN='\033[36m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
RESET='\033[0m'

# Function to print the directory list
function show_dirs() {
    local current_dir=$(pwd)
    local counter=1  # Start indexing at 1
    local lines=0
    local max_levels=9  # Limit to 10 levels

    # Print the header in cyan with "Shunpo <Jump>"
    echo -e "${CYAN}Shunpo <Jump>${RESET}"
    lines=$((lines + 1))

    # Print the current directory on the line below the header
    echo -e "Current Directory: ${BOLD}${CYAN}$current_dir${RESET}"
    lines=$((lines + 1))

    # Print the list of directories with numbers in orange and bold
    while [ "$counter" -le "$max_levels" ]; do
        current_dir=$(dirname "$current_dir")  # Move to the parent directory
        echo -e "[${BOLD}${ORANGE}$counter${RESET}] $current_dir"
        lines=$((lines + 1))
        counter=$((counter + 1))

        # Stop if the root directory is reached
        if [ "$current_dir" == "/" ]; then
            break
        fi
    done

    # Return the number of lines printed
    return $lines
}

# Display directories and get the number of lines printed
show_dirs
lines=$?

# Read a single character input
read -rsn1 input

# Clear all printed lines at once
tput cuu "$lines"   # Move the cursor up by the number of lines printed
tput ed             # Clear everything from the cursor to the end of the screen

# Validate the input is a number
if [[ "$input" =~ ^[0-9]+$ ]]; then
    # Get the current directory
    current_dir=$(pwd)
    for ((i=0; i<input; i++)); do
        current_dir=$(dirname "$current_dir")
    done
    # Change to the selected directory
    cd "$current_dir" || exit
fi
