#!/bin/bash

# This script should be sourced and not executed.

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

jump_to_parent_dir $1

# Handle case where bookmark is not set.
if [ $? -eq 2 ]; then
	if declare -f cleanup >/dev/null; then
		cleanup
	fi
	echo -e "${BOLD}${ORANGE}Invalid Parent Selection.${RESET}"
	return 1
fi

if declare -f cleanup >/dev/null; then
	cleanup
fi
