#!/bin/bash

# Colors and formatting
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh
source $SCRIPT_DIR/functions.sh

assert_bookmarks_exist
show_bookmarks "List Bookmarks"
# read -rsn1 input
clear_output
