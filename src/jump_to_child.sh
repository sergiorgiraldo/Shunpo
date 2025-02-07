#!/usr/bin/env bash

# This script should be sourced and not executed.

SHUNPO_SCRIPT_DIR="/Users/GK47LX/.bin/shunpo"
source "$SHUNPO_SCRIPT_DIR"/colors.sh
source "$SHUNPO_SCRIPT_DIR"/functions.sh

function shunpo_handle_kill() {
    shunpo_clear_output
    if declare -f shunpo_cleanup >/dev/null; then
        shunpo_cleanup
    fi
    return 0
}

trap 'shunpo_handle_kill; return 1' SIGINT

shunpo_jump_to_child_dir
if declare -f shunpo_cleanup >/dev/null; then
    shunpo_cleanup
fi
