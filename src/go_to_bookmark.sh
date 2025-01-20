#!/bin/bash

# This script should be sourced and not executed.

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/colors.sh
source "$SCRIPT_DIR"/functions.sh

function handle_kill() {
	clear_output
	if declare -f cleanup >/dev/null; then
		cleanup
	fi
	return 1
}

trap 'handle_kill; return 1' SIGINT

if ! assert_bookmarks_exist; then
	return 1
fi

interact_bookmarks "Go To Bookmark"
if [[ -z $selected_dir ]]; then
	if declare -f cleanup >/dev/null; then
		cleanup
	fi
	return 1

elif [[ -d $selected_dir ]]; then
	if cd "$selected_dir"; then
		echo -e "${GREEN}${BOLD}Changed to:${RESET} $selected_dir"
	else
		echo -e "${RED}${BOLD}Failed to find directory:${RESET} $selected_dir"
	fi

else
	echo -e "${RED}${BOLD}Directory no longer exists:${RESET} $selected_dir"
fi

cleanup
