#!/bin/bash

# Colors and formatting.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/colors.sh
source $SCRIPT_DIR/functions.sh

show_parent_dirs

# Validate the input is a number.
read -rsn1 input
if [[ "$input" =~ ^[0-9]+$ ]]; then
	# Get target directory.
	current_dir=$(pwd)
	for ((i = 0; i < input; i++)); do
		current_dir=$(dirname "$current_dir")
	done

	clear_output
	# Change to the target directory.
	cd "$current_dir" || exit
	echo -e "${GREEN}${BOLD}Changed to:${RESET} $current_dir"
fi
