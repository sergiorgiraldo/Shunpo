#!/bin/bash

# Target .bashrc file
BASHRC="$HOME/.bashrc"

# Define aliases as a simple list (name and command pairs)
aliases=(
    "sj:source $(realpath sh/jump.sh)"
    "sb:$(realpath sh/add_bookmark.sh)"
    "sr:$(realpath sh/remove_bookmark.sh)"
    "sg:source $(realpath sh/go_to_bookmark.sh)"
    "sl:$(realpath sh/list_bookmarks.sh)"
    "sc:$(realpath sh/clear_bookmarks.sh)"
)

# Function to append alias if not already present
add_aliases() {
    for alias_pair in "${aliases[@]}"; do
        alias_name="${alias_pair%%:*}"        # Extract alias name
        alias_command="${alias_pair#*:}"     # Extract alias command
        alias_line="alias $alias_name='$alias_command'"

        # Check if the alias already exists in bashrc
        if ! grep -qxF "$alias_line" "$BASHRC"; then
            echo "$alias_line" >> "$BASHRC"
            echo "Added: $alias_line"
        else
            echo "Alias $alias_name already exists in $BASHRC. Skipping."
        fi
    done
}

# Add aliases
add_aliases

echo "Done."

# TODO: add a clean option.
# TODO: make alias overwrite the default.
# TODO: if there is an alias with the same name ask if overwrite is OK.
