#!/usr/bin/env bash
# NOTE:
# Use /usr/bin/env to find shell interpreter for better portability.
# Reference: https://en.wikipedia.org/wiki/Shebang_%28Unix%29#Portability

# NOTE:
# Exit immediately if any commands (even in pipeline)
# exits with a non-zero status.
set -e
set -o pipefail

# This function configures a CMake project by setting up the necessary directories
# and running the CMake command with the appropriate arguments.
#
# Arguments:
#   $1 - The source directory of the project.
#   $2 - The directory where the build will take place.
#   $@ - Additional arguments to pass to the cmake command.
function configure_cmake_project() {
	# NOTE:
	# Do not use cmake -S and -B options for better compatibility.
	local project_source_dir
	project_source_dir="$1"
	# Make project_source_dir an absolute path.
	if [ -n "${project_source_dir%%/*}" ]; then
		project_source_dir="$PWD/$project_source_dir"
	fi
	shift

	local project_binary_dir
	project_binary_dir="$1"
	# Make project_binary_dir an absolute path.
	if [ -n "${project_binary_dir%%/*}" ]; then
		project_binary_dir="$PWD/$project_binary_dir"
	fi
	shift

	mkdir -p "$project_binary_dir"
	# NOTE:
	# Do not use pushd and popd here for POSIX sh compliance.
	local old_pwd
	old_pwd="$PWD"
	cd "$project_binary_dir"
	cmake "$project_source_dir" "$@"
	cd "$old_pwd"
}

# This function builds a CMake project.
# Arguments:
#   $1 - The source directory of the project.
#   $2 - The directory where the build will take place.
#   $@ - Additional arguments to pass to the cmake command.
function build_cmake_project() {
	configure_cmake_project "$@"

	shift
	local project_binary_dir
	project_binary_dir="$1"
	# Make project_binary_dir an absolute path.
	if [ -n "${project_binary_dir%%/*}" ]; then
		project_binary_dir="$PWD/$project_binary_dir"
	fi
	shift

	# NOTE:
	# Do not use pushd and popd here for POSIX sh compliance.
	local old_pwd
	old_pwd="$PWD"
	cd "$project_binary_dir"
	cmake --build .
	cd "$old_pwd"
}
