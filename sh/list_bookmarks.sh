#!/bin/bash

# Colors and formatting
CYAN='\033[36m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
RESET='\033[0m'

# File to store bookmarks
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

# Ensure the bookmarks file exists and is not empty
if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
    echo -e "${CYAN}${BOLD}No Bookmarks found.${RESET}"
    exit 1
fi

# Function to display bookmarks
function show_bookmarks() {
    local counter=0
    local lines=0
    bookmarks=() # Declare a global array to hold bookmarks

    # Print the header
    echo -e "${CYAN}Shunpo <Bookmarks List>${RESET}"
    lines=$((lines + 1))

    # Read bookmarks from the file and display them
    while IFS= read -r bookmark && [ $counter -lt 10 ]; do
        bookmarks+=("$bookmark") # Add bookmark to the array
        echo -e "[${BOLD}${ORANGE}$counter${RESET}] $bookmark"
        lines=$((lines + 1))
        counter=$((counter + 1))
    done <"$BOOKMARKS_FILE"

    # Return the number of lines printed
    return $lines
}

show_bookmarks
lines=$? # Get the number of lines printed

# Read a single character input
read -rsn1 input

# Clear all printed lines
tput cuu "$lines" # Move the cursor up by the number of lines printed
tput ed           # Clear everything from the cursor to the end of the screen
