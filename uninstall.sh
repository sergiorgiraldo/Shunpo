#!/bin/bash

BASHRC="$HOME/.bashrc"
source $BASHRC

uninstall() {
    echo "Uninstalling..."
    SHUNPO_CMD="$SHUNPO_DIR/shunpo_cmd"
    if [ -f "$SHUNPO_CMD" ]; then
        rm "$SHUNPO_CMD"
        echo "Removed $SHUNPO_CMD"
    fi

    SHUNPO_BOOKMARKS_FILE="$SHUNPO_DIR/.shunpo_bookmarks"
    if [ -f $SHUNPO_BOOKMARKS_FILE ]; then
        rm $SHUNPO_BOOKMARKS_FILE
        echo "Removed $SHUNPO_BOOKMARKS_FILE"
    fi

    if [ -z "$SHUNPO_DIR" ]; then
        echo "No Installation Found."
        exit 1
    else
        cd $SHUNPO_DIR
        rm jump_to_parent.sh
        rm jump_to_child.sh
        rm add_bookmark.sh
        rm remove_bookmark.sh
        rm go_to_bookmark.sh
        rm list_bookmarks.sh
        rm clear_bookmarks.sh
        rm functions.sh
        rm colors.sh
        cd ..
        rmdir $SHUNPO_DIR
        echo "Removed $SHUNPO_DIR"
        unset SHUNPO_DIR
    fi

    temp_file=$(mktemp)
    sed '/^source.*\shunpo_cmd/d' "$BASHRC" >"$temp_file"
    mv "$temp_file" "$BASHRC"

    temp_file=$(mktemp)
    grep -v '^export SHUNPO_DIR=' "$BASHRC" >"$temp_file"
    mv "$temp_file" "$BASHRC"
}

uninstall
echo "Done."
