#!/bin/bash

# Default Bookmarks Path.
BOOKMARKS_FILE="$HOME/.shunpo_bookmarks"

# Function to display bookmarks.
## Function to display bookmarks with pagination.
function show_bookmarks() {
	local bookmarks=()
	local counter=0
	local total_bookmarks
	local current_page=0
	local max_per_page=10
	local start_index
	local end_index

	# Read bookmarks into an array.
	while IFS= read -r bookmark; do
		bookmarks+=("$bookmark")
	done <"$BOOKMARKS_FILE"

	total_bookmarks=${#bookmarks[@]}
	if [ "$total_bookmarks" -eq 0 ]; then
		echo -e "${CYAN}No bookmarks to display.${RESET}"
		return
	fi

	total_pages=$((total_bookmarks / max_per_page))

	# Pagination loop.
	while true; do

		# Calculate the start and end indices for the current page.
		start_index=$((current_page * max_per_page))
		end_index=$((start_index + max_per_page))
		if [ "$end_index" -gt "$total_bookmarks" ]; then
			end_index=$total_bookmarks
		fi

		# Save cursor position.
		tput sc

		# Print header.
		echo -e "${CYAN}Shunpo <$1>${RESET}"

		# Display bookmarks for the current page.
		for ((i = start_index; i < end_index; i++)); do
			echo -e "[${BOLD}${ORANGE}$((i - start_index))${RESET}] ${bookmarks[i]}"
		done
		echo -e "${CYAN}[$((current_page + 1)) / $total_pages]${RESET}"

		# Read input to cycle through pages.
		read -rsn1 input
		if [[ "$input" == "n" ]]; then
			if [ $((current_page + 1)) -le $((total_pages - 1)) ]; then
				current_page=$((current_page + 1))
			fi

		elif [[ "$input" == "p" ]]; then
			if [ $((current_page - 1)) -ge 0 ]; then
				current_page=$((current_page - 1))
			fi

        # TODO: modify this if statement to always return the selected bookmark,
        # then handle the deletion or change_dir operation in the relevant script.
        # Use this chunk to always handle the selection task.
		elif [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 0 ]\
            && [ "$input" -lt $max_per_page ]; then
				selected_dir="${bookmarks[$input]}"
				clear_output
				if [ -d "$selected_dir" ]; then
					cd "$selected_dir" || exit
					echo -e "${GREEN}${BOLD}Changed to:${RESET} $selected_dir"
				else
					echo -e "${RED}${BOLD}Directory no longer exists:${RESET} $selected_dir"
				fi
			fi
		else
			clear_output
			exit
		fi
		clear_output
	done
}

# Function to outputs after saved cursor position.
function clear_output() {
	tput rc # Restore saved cursor position.
	tput ed # Clear everything below the cursor.
}

function assert_bookmarks_exist() {
	# Ensure the bookmarks file exists and is not empty.
	if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
		echo -e "${CYAN}${BOLD}No Bookmarks found.${RESET}"
		exit 1
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
