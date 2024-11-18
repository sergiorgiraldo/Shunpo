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
	selected_index=$input
	selected_dir="${bookmarks[$selected_index]}"

	# Remove the selected bookmark from the file
	grep -Fxv "$selected_dir" "$BOOKMARKS_FILE" >"${BOOKMARKS_FILE}.tmp" && mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"
	echo -e "${CYAN}${BOLD}Removed bookmark:${RESET} $selected_dir"
fi
