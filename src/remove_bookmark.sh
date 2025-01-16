#!/bin/bash

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh
source $SCRIPT_DIR/functions.sh

assert_bookmarks_exist
show_bookmarks "Remove Bookmarks"

# Validate input and handle bookmark removal.
read -rsn1 input
if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -lt "${#bookmarks[@]}" ]; then
	# Get the selected bookmark to remove.
	selected_index=$((10#$input))
	selected_dir="${bookmarks[$selected_index]}"

	# Remove the selected bookmark from the file.
	awk -v dir="$selected_dir" '$0 != dir' "$BOOKMARKS_FILE" >"${BOOKMARKS_FILE}.tmp" && mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"

	# Clear the show_bookmarks output.
	clear_output

	# Display the removed bookmark message.
	echo -e "${RED}${BOLD}Removed bookmark:${RESET} $selected_dir"

	# Delete the bookmarks file if it is empty.
	if [ ! -s "$BOOKMARKS_FILE" ]; then
		rm -f "$BOOKMARKS_FILE"
	fi
else
	clear_output
fi
