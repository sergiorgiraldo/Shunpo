#!/bin/bash

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh
source $SCRIPT_DIR/functions.sh

assert_bookmarks_exist
show_bookmarks "Go To Bookmark"

# Validate input and navigate to directory.
read -rsn1 input
clear_output
if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -lt "${#bookmarks[@]}" ]; then
	selected_dir="${bookmarks[$input]}"
	if [ -d "$selected_dir" ]; then
		cd "$selected_dir" || exit
		echo -e "${GREEN}${BOLD}Changed to:${RESET} $selected_dir"
	else
		echo -e "${RED}${BOLD}Directory no longer exists:${RESET} $selected_dir"
	fi
fi
