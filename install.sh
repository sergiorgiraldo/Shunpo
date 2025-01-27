#!/bin/bash

DEFAULT_INSTALL_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/shunpo
read -p "Enter the installation directory [default: $DEFAULT_INSTALL_DIR]: " user_input
INSTALL_DIR=${user_input:-"$DEFAULT_INSTALL_DIR"}
BASHRC="$HOME/.bashrc"
# file containing command definitions:
SHUNPO_CMD="$INSTALL_DIR/shunpo_cmd"

setup() {
    mkdir -p $INSTALL_DIR
    if [ -f $SHUNPO_CMD ]; then
        rm $SHUNPO_CMD
    fi
    touch $SHUNPO_CMD
}

add_commands() {
    INSTALL_DIR="$(realpath "$INSTALL_DIR")"

    functions=(
        "sj() { source \"$INSTALL_DIR/jump_to_parent.sh\"; }"
        "sd() { source \"$INSTALL_DIR/jump_to_child.sh\"; }"
        "sb() { \"$INSTALL_DIR/add_bookmark.sh\" \"\$@\"; }"
        "sr() { \"$INSTALL_DIR/remove_bookmark.sh\" \"\$@\"; }"
        "sg() { source \"$INSTALL_DIR/go_to_bookmark.sh\"; }"
        "sl() { \"$INSTALL_DIR/list_bookmarks.sh\"; }"
        "sc() { \"$INSTALL_DIR/clear_bookmarks.sh\"; }"
    )

    for func_definition in "${functions[@]}"; do
        echo "$func_definition" >>"$SHUNPO_CMD"
        echo "Created Command: ${func_definition%%()*}"
    done
}

install() {
    cp src/* $INSTALL_DIR

    # add sourcing for .shunporc
    source_rc_line="source $SHUNPO_CMD"
    temp_file=$(mktemp)
    sed '/^source.*\.shunporc/d' "$BASHRC" >"$temp_file"
    mv "$temp_file" "$BASHRC"
    echo "$source_rc_line" >>"$BASHRC"
    echo "Added to BASHRC: $source_rc_line"

    # record SHUNPO_DIR for uninstallation.
    install_dir_line="export SHUNPO_DIR=$INSTALL_DIR" >>"$BASHRC$"
    temp_file=$(mktemp)
    grep -v '^export SHUNPO_DIR=' "$BASHRC" >"$temp_file"
    mv "$temp_file" "$BASHRC"
    echo "$install_dir_line" >>"$BASHRC"
    echo "Added to BASHRC: $install_dir_line"

    add_commands
}

# Install.
echo "Installing."
setup
install

echo "Done."
echo "(Remember to run source ~/.bashrc.)"
