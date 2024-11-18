#!/bin/bash

# Colors and formatting
CYAN='\033[36m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
RESET='\033[0m'

# File to store bookmarks
BOOKMARKS_FILE="bookmarks"

# Ensure the bookmarks file exists and is not empty
if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
    echo -e "${CYAN}${BOLD}No bookmarks found.${RESET}"
    exit 1
fi

# Function to display bookmarks and populate an array
function show_bookmarks() {
    local counter=1
    local lines=0
    bookmarks=()  # Declare a global array to hold bookmarks

    # Print the header
    echo -e "${CYAN}Shunpo <Bookmarks>${RESET}"
    lines=$((lines + 1))

    # Read bookmarks from the file and display them
    while IFS= read -r bookmark; do
        bookmarks+=("$bookmark")  # Add bookmark to the array
        echo -e "[${BOLD}${ORANGE}$counter${RESET}] $bookmark"
        lines=$((lines + 1))
        counter=$((counter + 1))
    done < "$BOOKMARKS_FILE"

    # Return the number of lines printed
    return $lines
}

# Display bookmarks and populate the array
show_bookmarks
lines=$?  # Get the number of lines printed

# Read a single character input
read -rsn1 input

# Clear all printed lines
tput cuu "$lines"   # Move the cursor up by the number of lines printed
tput ed             # Clear everything from the cursor to the end of the screen

# Validate input and handle navigation
if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -gt 0 ] && [ "$input" -le "${#bookmarks[@]}" ]; then
    selected_dir="${bookmarks[$((input - 1))]}"
    if [ -d "$selected_dir" ]; then
        cd "$selected_dir" || exit
        echo -e "${CYAN}${BOLD}Changed to:${RESET} $selected_dir"
    else
        echo -e "${CYAN}${BOLD}Directory no longer exists:${RESET} $selected_dir"
    fi
else
    echo -e "${CYAN}${BOLD}Invalid input.${RESET}"
fi
