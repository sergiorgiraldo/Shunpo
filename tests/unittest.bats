#!/usr/bin/env bats

load common.sh
load assert.sh

setup() {
	echo "Setting Up Test."
	setup_env
	printf '\n' | ./install.sh
	working_dir=$(pwd)
	source ${SHUNPO_TEST_DIR}/home/.bashrc
	source ${SHUNPO_TEST_DIR}/home/.shunporc
	cd ${SHUNPO_TEST_DIR}
}

teardown() {
	echo "Shutting Down Test."
	cd "$working_dir"
	./uninstall.sh
}

@test "Test Install." {
	[ -e "/private/tmp/shunpo_test/home/.shunporc" ] && assert_success
	[ "$(echo $SHUNPO_DIR)" = "/private/tmp/shunpo_test/home/.shunpo" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/functions.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/colors.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/add_bookmark.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/go_to_bookmark.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/remove_bookmark.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/list_bookmarks.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/clear_bookmarks.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/jump_to_parent.sh" ] && assert_success
	[ -e "/private/tmp/shunpo_test/home/.shunpo/jump_to_child.sh" ] && assert_success
	run declare -F sb && assert_success
	run declare -F sg && assert_success
	run declare -F sr && assert_success
	run declare -F sl && assert_success
	run declare -F sc && assert_success
	run declare -F sj && assert_success
	run declare -F sd && assert_success
}

# @test "Test Add Bookmark." {
# 	# Set up directory structure.
# 	make_directories 1
#
# 	# Check if bookmarks are created.
# 	num_bookmarks=$(wc -l ${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks)
# 	[[ $num_bookmarks -eq 4 ]]
#
# 	# Check if bookmark entry is correct.
# 	[[ $(sed -n 3p ${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks) == "/private/tmp/shunpo_test/1/2" ]]
# }

# @test "Test Remove Bookmark." {
# 	# Set up directory structure.
# 	make_directories 1
#
# 	bookmark3=$(sed -n 4p ${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks)
#
# 	# Remove bookmarks and check counts.
# 	run sr 1 && [ "$?" -eq 0 ]
# 	num_bookmarks=$(wc -l <"${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks")
#     (( num_bookmarks == 3 ))
#     echo "BOOKMARKS BEFORE $num_bookmarks"
#
# 	# run sr 1 && [ "$?" -eq 0 ]
#     echo "2" | run sr
# 	num_bookmarks=$(wc -l <"${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks")
#     (( num_bookmarks == 2 ))
#     # echo "BOOKMARKS $num_bookmarks"
#     # return 1
#
# 	# Check shifting.
# 	# bookmark1=$(sed -n 2p ${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks)
# 	# [[ "$bookmark3" == "$bookmark1" ]]
# }

# @test "Test Clear Bookmarks." {
# 	# Set up directory structure.
# 	make_directories 1
#
# 	bookmark3=$(sed -n 4p ${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks)
#
# 	# Remove bookmarks and check counts.
# 	run sr 1 && [ "$?" -eq 0 ]
# 	num_bookmarks=$(wc -l <"${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks")
# 	[[ "$num_bookmarks" -eq 3 ]]
#
# 	run sr 1 && [ "$?" -eq 0 ]
# 	num_bookmarks=$(wc -l <"${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks")
# 	[[ "$num_bookmarks" -eq 2 ]]
#
# 	# Check shifting.
# 	bookmark1=$(sed -n 2p ${SHUNPO_TEST_DIR}/home/.shunpo_bookmarks)
# 	[[ "$bookmark3" == "$bookmark1" ]]
# }
