#!/bin/bash

# Colors and formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh

# File to store bookmarks
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

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
	echo -e "${CYAN}Shunpo <Go To Bookmark>${RESET}"
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

# Display bookmarks and populate the array
show_bookmarks
lines=$? # Get the number of lines printed

# Read a single character input
read -rsn1 input

# Clear all printed lines
tput cuu "$lines" # Move the cursor up by the number of lines printed
tput ed           # Clear everything from the cursor to the end of the screen

# Validate input and handle navigation
if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -lt "${#bookmarks[@]}" ]; then
	selected_dir="${bookmarks[$input]}"
	if [ -d "$selected_dir" ]; then
		cd "$selected_dir" || exit
		echo -e "${GREEN}${BOLD}Changed to:${RESET} $selected_dir"
	else
		echo -e "${RED}${BOLD}Directory no longer exists:${RESET} $selected_dir"
	fi
fi
