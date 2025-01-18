#!/bin/bash

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"
source "$SCRIPT_DIR/functions.sh"

# Function to handle Ctrl+C (SIGINT)
function handle_kill() {
	clear_output
	tput cnorm
	exit 1
}

# Trap SIGINT and call the handler
trap 'handle_kill' SIGINT

# Check if bookmarks exist
if ! assert_bookmarks_exist; then
	return 1
fi

show_bookmarks "Remove Bookmarks"

bookmarks=()
while IFS= read -r bookmark; do
	bookmarks+=("$bookmark")
done <"$BOOKMARKS_FILE"

if [[ -z $selected_dir ]]; then
    unset selected_dir
    exit

elif [[ "$selected_bookmark_index" -ge 0 ]] && [[ "$selected_bookmark_index" -lt "${#bookmarks[@]}" ]]; then
	# Remove the selected bookmark from the file.
	awk -v dir="$selected_dir" '$0 != dir' "$BOOKMARKS_FILE" >"${BOOKMARKS_FILE}.tmp" && mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"

	# Display the removed bookmark message.
	echo -e "${RED}${BOLD}Removed bookmark:${RESET} $selected_dir"

	# Delete the bookmarks file if it is empty.
	if [ ! -s "$BOOKMARKS_FILE" ]; then
		rm -f "$BOOKMARKS_FILE"
	fi
else
	exit
fi
