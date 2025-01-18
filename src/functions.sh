#!/bin/bash
# Default Bookmarks Path.
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

# Function to display bookmarks with pagination.
function show_bookmarks() {
	local bookmarks=()
	local total_bookmarks
	local current_page=0
	local max_per_page=10
	local last_page
	local start_index
	local end_index
	local middle_row
	local padding_lines

	tput civis

	# Read bookmarks into an array.
	while IFS= read -r bookmark; do
		bookmarks+=("$bookmark")
	done <"$BOOKMARKS_FILE"

	# Check that bookmarks file is not empty.
	total_bookmarks=${#bookmarks[@]}
	if [ "$total_bookmarks" -eq 0 ]; then
		echo -e "${BOLD}${CYAN}No Bookmarks Found.${RESET}"
		return
	fi

	last_page=$(((total_bookmarks + max_per_page / 2) / max_per_page))

	# Pagination loop.
	while true; do
		# Calculate the start and end indices for the current page.
		start_index=$((current_page * max_per_page))
		end_index=$((start_index + max_per_page))
		if [ "$end_index" -gt "$total_bookmarks" ]; then
			end_index=$total_bookmarks
		fi

		# Pad the bottom of the terminal to avoid erroneous printing.
		if [ "$max_per_page" -lt "$total_bookmarks" ]; then
			padding_lines=$max_per_page
		else
			padding_lines=$total_bookmarks
		fi
		padding_lines=$((padding_lines + 2))
		add_space $padding_lines

		# Save cursor position.
		tput sc

		# Print header.
		echo -e "${CYAN}Shunpo <$1>${RESET}"

		# Display bookmarks for the current page.
		for ((i = start_index; i < end_index; i++)); do
			echo -e "[${BOLD}${ORANGE}$((i - start_index))${RESET}] ${bookmarks[i]}"
		done

		if [ $last_page -ge 1 ]; then
			echo -e "${CYAN}[$((current_page + 1)) / $((last_page))]${RESET}"
		fi

		# Read input to select bookmarks and cycle through pages.
		read -rsn1 input
		if [[ $input == "n" ]]; then
			if [ $((current_page + 1)) -le $((last_page - 1)) ]; then
				current_page=$((current_page + 1))
			fi
			clear_output

		elif [[ $input == "p" ]]; then
			if [ $((current_page - 1)) -ge 0 ]; then
				current_page=$((current_page - 1))
			fi
			clear_output

		elif [[ $input =~ ^[0-9]+$ ]] && [ $input -ge 0 ] && [ $input -lt $max_per_page ]; then
			# Process bookmark selection input.
			selected_bookmark_index=$((current_page * max_per_page + $input))
			if [[ $selected_bookmark_index -lt $total_bookmarks ]]; then
				selected_dir="${bookmarks[$selected_bookmark_index]}"
				clear_output
				tput cnorm
				return
			else
				clear_output
			fi
		else
			clear_output
			tput cnorm
			return
		fi
	done
	clear_output
	tput cnorm
	return
}

# Function to open several lines of space before writing when near the end of the terminal
function add_space() {
	# Get total terminal lines.
	total_lines=$(tput lines)

	# Fetch the current cursor row position using ANSI escape codes.
	cursor_line=$(IFS=';' read -sdR -p $'\033[6n' -a pos && echo "${pos[0]#*[}")

	# Calculate lines from current position to bottom.
	lines_to_bottom=$((total_lines - cursor_line))

	# If not enough lines, add extra lines.
	if [ "$lines_to_bottom" -lt $1 ]; then
		extra_lines=$(($1 - lines_to_bottom))
		for ((i = 0; i < extra_lines; i++)); do
			echo
		done
		tput cuu $1
	fi
}

function clear_output() {
	tput rc # Restore saved cursor position.
	tput ed # Clear everything below the cursor.
}

function assert_bookmarks_exist() {
	# Ensure the bookmarks file exists and is not empty.
	if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
		echo -e "${CYAN}${BOLD}No Bookmarks Found.${RESET}"
        cleanup
		return 1
	fi
}

function show_parent_dirs() {
	local current_dir=$(pwd)
	local counter=1    # Start indexing at 1.
	local max_levels=9 # Limit to 9 levels. 0 is the current directory.

	# Save cursor position.
	tput sc

	# Print the header in cyan with "Shunpo <Jump>"
	echo -e "${CYAN}Shunpo <Jump>${RESET}"

	# Print the current directory on the line below the header
	echo -e "Current Directory: ${BOLD}${CYAN}$current_dir${RESET}"

	# Print the list of directories.
	while [ "$counter" -le "$max_levels" ]; do
		current_dir=$(dirname "$current_dir") # Move to the parent directory.
		echo -e "[${BOLD}${ORANGE}$counter${RESET}] $current_dir"
		lines=$((lines + 1))
		counter=$((counter + 1))

		# Stop if the root directory is reached.
		if [ "$current_dir" == "/" ]; then
			break
		fi
	done
}

function cleanup() {
    # Clean up to avoid namespace pollution.
    unset BOOKMARKS_FILE
    unset selected_dir
    unset selected_bookmark_index
    unset show_bookmarks
    unset add_space
    unset clear_output
    unset assert_bookmarks_exist
    unset show_parent_dirs
    unset handle_kill
    tput cnorm
    stty echo
    trap - SIGINT
    unset cleanup
}
