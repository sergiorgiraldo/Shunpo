#!/bin/bash

read -p "Enter the installation directory [default: $HOME/.shunpo]: " user_input
INSTALL_DIR=${user_input:-"$HOME/.shunpo"}
BASHRC="$HOME/.bashrc"
SHUNPORC="$HOME/.shunporc"

setup() {
	mkdir -p $INSTALL_DIR
	if [ -f $SHUNPORC ]; then
		rm $SHUNPORC
	fi
	touch $SHUNPORC
}

add_aliases() {
	aliases=(
		"sj:source $(realpath $INSTALL_DIR/jump_to_parent.sh)"
		"sd:source $(realpath $INSTALL_DIR/jump_to_child.sh)"
		"sb:$(realpath $INSTALL_DIR/add_bookmark.sh)"
		"sr:$(realpath $INSTALL_DIR/remove_bookmark.sh)"
		"sg:source $(realpath $INSTALL_DIR/go_to_bookmark.sh)"
		"sl:$(realpath $INSTALL_DIR/list_bookmarks.sh)"
		"sc:$(realpath $INSTALL_DIR/clear_bookmarks.sh)"
	)
	for alias_pair in "${aliases[@]}"; do
		alias_name="${alias_pair%%:*}"
		alias_command="${alias_pair#*:}"
		alias_line="alias $alias_name='$alias_command'"

		echo "$alias_line" >>"$SHUNPORC"
		echo "Added: $alias_line"
	done
}

install() {
	cp src/* $INSTALL_DIR

	# add sourcing for .shunporc
	source_rc_line="source $SHUNPORC"
	temp_file=$(mktemp)
	sed '/^source.*\.shunporc/d' "$BASHRC" >"$temp_file"
	mv "$temp_file" "$BASHRC"
	echo "$source_rc_line" >>"$BASHRC"
	echo "Added: $source_rc_line"

	# record SHUNPO_DIR for uninstallation.
	install_dir_line="export SHUNPO_DIR=$INSTALL_DIR" >>"$BASHRC$"
	temp_file=$(mktemp)
	grep -v '^export SHUNPO_DIR=' "$BASHRC" >"$temp_file"
	mv "$temp_file" "$BASHRC"
	echo "$install_dir_line" >>"$BASHRC"
	echo "Added: $install_dir_line"

	add_aliases
}

# Install.
echo "Installing."
setup
install

echo "Done."
echo "(Remember to run source ~/.bashrc.)"
