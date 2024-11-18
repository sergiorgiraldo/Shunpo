#!/bin/bash

# Colors and formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh

# File to store bookmarks
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"


# Ensure the bookmarks file exists and is not empty
if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
    echo -e "${GREEN}${BOLD}No Bookmarks Found.${RESET}"
    exit 1

else
    rm $BOOKMARKS_FILE
	echo -e "${GREEN}${BOLD}Cleared Bookmarks.${RESET}"
fi
