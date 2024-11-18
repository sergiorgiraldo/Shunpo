#!/bin/bash

# Colors and formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh

# File to store bookmarks
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

# Ensure the bookmarks file exists and is not empty
if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
    echo -e "${CYAN}${BOLD}No Bookmarks Found.${RESET}"
    exit 1
fi

# Function to display bookmarks
function show_bookmarks() {
    local counter=0
    local lines=0
    bookmarks=() # Declare a global array to hold bookmarks

    # Print the header
    echo -e "${CYAN}Shunpo <Remove Bookmark>${RESET}"
    lines=$((lines + 1))

    # Read bookmarks from the file and display them
    while IFS= read -r bookmark; do
        bookmarks+=("$bookmark") # Add bookmark to the array
        echo -e "[${BOLD}${ORANGE}$counter${RESET}] $bookmark"
        lines=$((lines + 1))
        counter=$((counter + 1))
    done <"$BOOKMARKS_FILE"

    # Return the number of lines printed
    return $lines
}

# Display bookmarks and populate the array
show_bookmarks
lines=$? # Get the number of lines printed

# Read a single character input
read -rsn1 input

# Clear all printed lines
tput cuu "$lines" # Move the cursor up by the number of lines printed
tput ed           # Clear everything from the cursor to the end of the screen

# Validate input and handle bookmark removal
if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -lt "${#bookmarks[@]}" ]; then
    # Get the selected bookmark to remove
    selected_index=$((10#$input)) # Ensure the input is treated as a number
    selected_dir="${bookmarks[$selected_index]}"

    # Remove the selected bookmark from the file
    awk -v dir="$selected_dir" '$0 != dir' "$BOOKMARKS_FILE" >"${BOOKMARKS_FILE}.tmp" && mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"
    echo -e "${RED}${BOLD}Removed bookmark:${RESET} $selected_dir"

    # Ensure that the file is now empty and delete it if so
    if [ ! -s "$BOOKMARKS_FILE" ]; then
        rm -f "$BOOKMARKS_FILE"
        # echo -e "${CYAN}${BOLD}All bookmarks removed. Bookmarks file deleted.${RESET}"
    fi
# else
#     echo -e "${CYAN}${BOLD}Invalid input.${RESET}"
fi
