#!/bin/bash
# Default Bookmarks Path.
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

# Function to display bookmarks with pagination.
function interact_bookmarks() {
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

	last_page=$(((total_bookmarks + max_per_page - 1) / max_per_page))

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

		if [ $last_page -gt 1 ]; then
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

function jump_to_parent_dir() {
	local current_dir=$(pwd)
	local max_levels=128
	local parent_dirs=()
	local total_parents
	local current_page=0
	local max_per_page=10
	local last_page
	local start_index
	local end_index

	tput civis

	# Collect all parent directories.
	while [ "$current_dir" != "/" ] && [ "${#parent_dirs[@]}" -lt "$max_levels" ]; do
		parent_dirs+=("$current_dir")
		current_dir=$(dirname "$current_dir")
	done
	parent_dirs+=("/") # Include root.

	total_parents=${#parent_dirs[@]}
	last_page=$(((total_parents + max_per_page - 1) / max_per_page))

	while true; do
		# Calculate start and end indices for pagination.
		start_index=$((current_page * max_per_page))
		end_index=$((start_index + max_per_page))
		if [ "$end_index" -gt "$total_parents" ]; then
			end_index=$total_parents
		fi

		# Pad the bottom of the terminal to avoid erroneous printing.
		if [ "$max_per_page" -lt "$total_parents" ]; then
			padding_lines=$max_per_page
		else
			padding_lines=$total_parents
		fi
		padding_lines=$((padding_lines + 2))
		add_space $padding_lines

		tput sc
		echo -e "${CYAN}Shunpo <Jump to Parent>${RESET}"

		# Display the current page of parent directories.
		for ((i = start_index; i < end_index; i++)); do
			echo -e "[${BOLD}${ORANGE}$((i - start_index))${RESET}] ${parent_dirs[i]}"
		done

		if [ $last_page -gt 1 ]; then
			echo -e "${CYAN}[$((current_page + 1)) / $last_page]${RESET}"
		fi

		# Read and process user input.
		read -rsn1 input
		if [[ "$input" == "n" ]]; then
			if [ $((current_page + 1)) -lt "$last_page" ]; then
				current_page=$((current_page + 1))
			fi
			clear_output

		elif [[ "$input" == "p" ]]; then
			if [ $((current_page - 1)) -ge 0 ]; then
				current_page=$((current_page - 1))
			fi
			clear_output

		elif [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -gt 0 ] && [ "$input" -le "$max_per_page" ]; then
			selected_index=$((start_index + input))
			if [[ "$selected_index" -lt "$total_parents" ]]; then
				clear_output
				tput cnorm
				cd "${parent_dirs[$selected_index]}" || exit
				echo -e "${GREEN}${BOLD}Changed to:${RESET} ${parent_dirs[$selected_index]}"
				return
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

# Function to open several lines of space before writing when near the end of the terminal.
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

function cleanup() {
	# Clean up to avoid namespace pollution.
	unset BOOKMARKS_FILE
	unset selected_dir
	unset selected_bookmark_index
	unset interact_bookmarks
	unset add_space
	unset clear_output
	unset assert_bookmarks_exist
	unset jump_to_parent_dir
	unset handle_kill
	tput cnorm
	stty echo
	trap - SIGINT
	unset cleanup
}
