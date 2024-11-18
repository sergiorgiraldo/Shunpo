#!/bin/bash

# Colors and formatting
CYAN='\033[36m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
RESET='\033[0m'

# File to store bookmarks
# BOOKMARKS_FILE="$HOME/.bookmarks"
BOOKMARKS_FILE="/Users/raphael/Desktop/Shunpo/sh/bookmarks"


# Ensure the bookmarks file exists
if [ ! -f "$BOOKMARKS_FILE" ]; then
    touch "$BOOKMARKS_FILE"
fi

# Save the current directory to the bookmarks file if it's not already present
current_dir=$(pwd)
if ! grep -Fxq "$current_dir" "$BOOKMARKS_FILE"; then
    echo "$current_dir" >> "$BOOKMARKS_FILE"
    echo -e "${CYAN}${BOLD}Bookmark added:${RESET} $current_dir"
else
    echo -e "${ORANGE}${BOLD}Bookmark already exists:${RESET} $current_dir"
fi
