#!/bin/bash

# Default Bookmarks Path.
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

# Function to display bookmarks.
function show_bookmarks() {
	local counter=0
	bookmarks=()

	# Save cursor position.
	tput sc

	# Print header.
	echo -e "${CYAN}Shunpo <$1>${RESET}"

	# Read bookmarks from the file and display them.
	while IFS= read -r bookmark; do
		bookmarks+=("$bookmark")
		echo -e "[${BOLD}${ORANGE}$counter${RESET}] $bookmark"
		counter=$((counter + 1))
	done <"$BOOKMARKS_FILE"
}

# Function to outputs after saved cursor position.
function clear_output() {
	tput rc # Restore saved cursor position.
	tput ed # Clear everything below the cursor.
}

function assert_bookmarks_exist() {
	# Ensure the bookmarks file exists and is not empty.
	if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
		echo -e "${CYAN}${BOLD}No Bookmarks found.${RESET}"
		exit 1
	fi
}

function show_parent_dirs() {
	local current_dir=$(pwd)
	local counter=1    # Start indexing at 1.
	local max_levels=9 # Limit to 9 levels. 0 is the current directory.

	# Save cursor position.
	tput sc

	# Print the header in cyan with "Shunpo <Jump>"
	echo -e "${CYAN}Shunpo <Jump>${RESET}"

	# Print the current directory on the line below the header
	echo -e "Current Directory: ${BOLD}${CYAN}$current_dir${RESET}"

	# Print the list of directories.
	while [ "$counter" -le "$max_levels" ]; do
		current_dir=$(dirname "$current_dir") # Move to the parent directory.
		echo -e "[${BOLD}${ORANGE}$counter${RESET}] $current_dir"
		lines=$((lines + 1))
		counter=$((counter + 1))

		# Stop if the root directory is reached.
		if [ "$current_dir" == "/" ]; then
			break
		fi
	done
}
