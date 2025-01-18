#!/bin/bash

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh
source $SCRIPT_DIR/functions.sh

if ! assert_bookmarks_exist; then
	return 1
fi
show_bookmarks "Go To Bookmark"
if [[ -z $selected_dir ]]; then
	unset selected_dir
	return

elif [[ -d $selected_dir ]]; then
	if cd "$selected_dir"; then
		echo -e "${GREEN}${BOLD}Changed to:${RESET} $selected_dir"
	else
		echo -e "${RED}${BOLD}Failed to find directory:${RESET} $selected_dir"
	fi

else
	echo -e "${RED}${BOLD}Directory no longer exists:${RESET} $selected_dir"
fi

unset selected_dir
