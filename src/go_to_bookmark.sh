#!/usr/bin/env bash

# This script should be sourced and not executed.

# Colors and formatting.
SHUNPO_SCRIPT_DIR="/Users/GK47LX/.bin/shunpo"
source "$SHUNPO_SCRIPT_DIR"/colors.sh
source "$SHUNPO_SCRIPT_DIR"/functions.sh

function shunpo_handle_kill() {
    shunpo_clear_output
    shunpo_cleanup
    exit 1
}

trap 'shunpo_handle_kill' SIGINT

if ! shunpo_assert_bookmarks_exist; then
    exit 1
fi

shunpo_interact_bookmarks "Go To Bookmark" "$1"

# Handle case where bookmark is not set.
if [ $? -eq 2 ]; then
    if declare -f shunpo_cleanup >/dev/null; then
        shunpo_cleanup
    fi
    echo -e "${SHUNPO_BOLD}${SHUNPO_ORANGE}Bookmark is Empty.${SHUNPO_RESET}"
    return 1
fi

if [[ -z $shunpo_selected_dir ]]; then
    if declare -f shunpo_cleanup >/dev/null; then
        shunpo_cleanup
    fi
    return 1

elif [[ -d $shunpo_selected_dir ]]; then
    if cd "$shunpo_selected_dir"; then
        echo -e "${SHUNPO_GREEN}${SHUNPO_BOLD}Changed to:${SHUNPO_RESET} $shunpo_selected_dir"
    else
        echo -e "${SHUNPO_RED}${SHUNPO_BOLD}Directory does not exist:${SHUNPO_RESET} $shunpo_selected_dir"
    fi

else
    echo -e "${SHUNPO_RED}${SHUNPO_BOLD}Directory does not exist:${SHUNPO_RESET} $shunpo_selected_dir"
fi

shunpo_cleanup
