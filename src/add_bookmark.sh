#!/bin/bash

# Colors and formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh

# File to store bookmarks
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"
MAX_BOOKMARKS=10

# Ensure the bookmarks file exists and is not empty
if [ ! -f "$BOOKMARKS_FILE" ]; then
    touch "$BOOKMARKS_FILE"
fi

# Check the number of existing bookmarks
current_bookmarks=$(wc -l < "$BOOKMARKS_FILE")

# If the bookmarks list is full, print a message and do not add the new bookmark
if [ "$current_bookmarks" -ge "$MAX_BOOKMARKS" ]; then
    echo -e "${CYAN}${BOLD}Bookmarks list is full!${RESET} Maximum of $MAX_BOOKMARKS bookmarks allowed."
    exit 1
fi

# Save the current directory to the bookmarks file
current_dir=$(pwd)
if ! grep -Fxq "$current_dir" "$BOOKMARKS_FILE"; then
    echo "$current_dir" >> "$BOOKMARKS_FILE"
    echo -e "${GREEN}${BOLD}Bookmark added:${RESET} $current_dir"
else
    echo -e "${ORANGE}${BOLD}Bookmark exists:${RESET} $current_dir"
fi
