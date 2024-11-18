#!/bin/bash

# Colors and formatting
CYAN='\033[36m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
RESET='\033[0m'

# File to store bookmarks
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"


# Ensure the bookmarks file exists and is not empty
if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
    echo -e "${CYAN}${BOLD}No Bookmarks Found.${RESET}"
    exit 1

else
    rm $BOOKMARKS_FILE
	echo -e "${CYAN}${BOLD}Cleared Bookmarks.${RESET}"
fi
