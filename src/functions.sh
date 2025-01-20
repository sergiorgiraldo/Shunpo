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
	local padding_lines

	tput civis

	# Read bookmarks into an array.
	while IFS= read -r bookmark; do
		bookmarks+=("$bookmark")
	done <"$BOOKMARKS_FILE"

	# Check that bookmarks file is not empty.
	total_bookmarks=${#bookmarks[@]}
	if [ "$total_bookmarks" -eq 0 ]; then
		echo -e "${BOLD}${ORANGE}No Bookmarks Found.${RESET}"
		return 0
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
		echo -e "${BOLD}${CYAN}Shunpo <$1>${RESET}"

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

		elif [[ $input =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ] && [ "$input" -lt $max_per_page ]; then
			# Process bookmark selection input.
			selected_bookmark_index=$((current_page * max_per_page + input))
			if [[ $selected_bookmark_index -lt $total_bookmarks ]]; then
				selected_dir="${bookmarks[$selected_bookmark_index]}"
				clear_output
				tput cnorm
				return 0
			else
				clear_output
			fi
		else
			clear_output
			tput cnorm
			return 0
		fi
	done
	clear_output
	tput cnorm
	return 0
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
	local padding_lines

	tput civis

	# Collect all parent directories.
	while [ "$current_dir" != "/" ] && [ "${#parent_dirs[@]}" -lt "$max_levels" ]; do
		parent_dirs+=("$current_dir")
		current_dir=$(dirname "$current_dir")
	done

	parent_dirs+=("/") # Add root.

	# Check if we are at the root.
	if [[ "${#parent_dirs[@]}" -eq 1 && "${parent_dirs[0]}" == "/" ]]; then
		echo -e "${BOLD}${ORANGE}No Parent Directories.${RESET}"
		return 1
	fi

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
		echo -e "${BOLD}${CYAN}Shunpo <Jump to Parent>${RESET}"

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
				return 0
			fi
		else
			clear_output
			tput cnorm
			return 0
		fi
	done
	clear_output
	tput cnorm
	return 0
}

function jump_to_child_dir() {
	local current_dir=$(pwd)
	local max_per_page=10
	local current_page=0
	local last_page
	local start_index
	local end_index
	local child_dirs=()
	local cache_index
	local selected_path="$current_dir" # selected path gets updated in each iteration.
	local start_dir=$(realpath "$current_dir")
	local is_start_dir=1
	local total_child_dirs
	local padding_lines

	tput civis

	# Cache previously traversed directories.
	local cache_keys=()
	local cache_values=()

	function is_cached() {
		local path="$1"
		for i in "${!cache_keys[@]}"; do
			if [[ "${cache_keys[$i]}" == "$path" ]]; then
				echo "$i"
				return 0
			fi
		done
		return 1
	}

	while true; do
		# Attempt to retrieve from cache.
		if cache_index=$(is_cached "$selected_path"); then
			# Use cached value.
			IFS='|' read -r -a child_dirs <<<"${cache_values[$cache_index]}"
		else
			# Collect directories if not cached.
			child_dirs=()
			while IFS= read -r dir; do
				child_dirs+=("$dir")
			done < <(find "$selected_path" -maxdepth 1 -mindepth 1 -type d | sort)

			# Add to cache.
			cache_keys+=("$selected_path")
			cache_values+=("$(
				IFS='|'
				echo "${child_dirs[*]}"
			)")
		fi
		total_child_dirs=${#child_dirs[@]}

		# Determine index range to diplay.
		start_index=$((current_page * max_per_page))
		end_index=$((start_index + max_per_page))
		if [ "$end_index" -gt "$total_child_dirs" ]; then
			end_index=$total_child_dirs
		fi

		last_page=$(((total_child_dirs + max_per_page - 1) / max_per_page))

		# Pad the bottom of the terminal to avoid erroneous printing.
		if [ "$max_per_page" -lt "$total_child_dirs" ]; then
			padding_lines=$max_per_page
		else
			padding_lines=$total_child_dirs
		fi
		padding_lines=$((padding_lines + 3))
		add_space $padding_lines

		tput sc
		echo -e "${BOLD}${CYAN}Shunpo <Jump to Child>${RESET}"
		if [[ $is_start_dir -eq 1 ]]; then
			echo -e "Selected Path: ${CYAN}$selected_path${RESET} ${ORANGE}(Initial)${RESET}"
		else
			echo -e "Selected Path: ${CYAN}$selected_path${RESET}"
		fi

		if [[ "$total_child_dirs" -eq 0 ]]; then
			if [[ $is_start_dir -eq 1 ]]; then
				clear_output
				echo -e "${BOLD}${ORANGE}No Child Directories.${RESET}"
				tput cnorm
				return 1
			else
				echo -e "${BOLD}${ORANGE}No Child Directories.${RESET}"
			fi
		else
			# Print child directories.
			for ((i = start_index; i < end_index; i++)); do
				echo -e "[${BOLD}${ORANGE}$((i - start_index))${RESET}] ${child_dirs[i]#$selected_path}"
			done

			if [ $last_page -gt 1 ]; then
				echo -e "${CYAN}[$((current_page + 1)) / $last_page]${RESET}"
			fi
		fi

		# Process input.
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

		elif [[ "$input" = "b" ]]; then
			if [[ $is_start_dir -eq 1 ]]; then
				clear_output
				continue
			else
				selected_path=$(realpath "$selected_path/../")
			fi

			if [[ "$selected_path" == "$start_dir" ]]; then
				is_start_dir=1
			else
				is_start_dir=0
			fi
			current_page=0
			clear_output

		elif [[ "$input" == "" ]]; then
			clear_output
			if [[ $is_start_dir -ne 1 ]]; then
				cd "$selected_path" || exit
				${CYAN}$selected_path${RESET}
				echo -e "${GREEN}${BOLD}Changed to:${RESET} $selected_path"
			fi
			break

		elif [[ "$input" =~ ^[0-9]+$ ]] && [[ "$input" -ge 0 ]] && [[ "$input" -lt $max_per_page ]]; then
			selected_index=$((start_index + input))
			if [[ "$selected_index" -lt "$total_child_dirs" ]]; then
				selected_path="${child_dirs[selected_index]}"
				is_start_dir=0
				current_page=0
			fi
			clear_output

		else
			clear_output
			tput cnorm
			break
		fi
	done
	tput cnorm
	return 0
}

# Function to open several lines of space before writing when near the end of the terminal
# to avoid visual issues.
function add_space() {
	# Get total terminal lines.
	total_lines=$(tput lines)

	# Fetch the current cursor row position using ANSI escape codes.
	cursor_line=$(IFS=';' read -rsdR -p $'\033[6n' -a pos && echo "${pos[0]#*[}")

	# Calculate lines from current position to bottom.
	lines_to_bottom=$((total_lines - cursor_line))

	# If not enough lines, add extra lines.
	if [ "$lines_to_bottom" -lt "$1" ]; then
		extra_lines=$(($1 - lines_to_bottom))
		for ((i = 0; i < extra_lines; i++)); do
			echo
		done
		tput cuu "$1"
	fi
	tput ed
}

function clear_output() {
	tput rc # Restore saved cursor position.
	tput ed # Clear everything below the cursor.
}

function assert_bookmarks_exist() {
	# Ensure the bookmarks file exists and is not empty.
	if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
		echo -e "${ORANGE}${BOLD}No Bookmarks Found.${RESET}"
		cleanup
		return 1
	fi
}

function cleanup() {
	# Clean up to avoid namespace pollution.
	unset BOOKMARKS_FILE
	unset IFS
	unset selected_dir
	unset selected_bookmark_index
	unset -f interact_bookmarks
	unset -f add_space
	unset -f clear_output
	unset -f assert_bookmarks_exist
	unset -f jump_to_parent_dir
	unset -f jump_to_child_dir
	unset -f is_cached
	unset -f handle_kill
	unset -f cleanup
	tput cnorm
	stty echo
	trap - SIGINT
}
