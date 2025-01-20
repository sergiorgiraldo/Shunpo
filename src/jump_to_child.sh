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
	return 0
}

trap 'handle_kill; return 1' SIGINT

jump_to_child_dir
if declare -f cleanup >/dev/null; then
	cleanup
fi
