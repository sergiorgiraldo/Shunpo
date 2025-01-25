#!/bin/bash

# Colors and formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/colors.sh
source "$SCRIPT_DIR"/functions.sh

function handle_kill() {
    clear_output
    cleanup
    exit 1
}

trap 'handle_kill' SIGINT

if ! assert_bookmarks_exist; then
    exit 1
fi

interact_bookmarks "List Bookmarks"
cleanup
