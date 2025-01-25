#!/bin/bash

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR"/colors.sh
source "$SCRIPT_DIR"/functions.sh

# Remove the bookmarks file if it exists.
if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
    echo -e "${ORANGE}${BOLD}No Bookmarks Found.${RESET}"
    exit 1

else
    rm "$BOOKMARKS_FILE"
    echo -e "${RED}${BOLD}Cleared Bookmarks.${RESET}"
fi
