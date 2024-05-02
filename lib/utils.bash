#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for launchpad.
GH_REPO="https://github.com/Mirantis/launchpad"
TOOL_NAME="launchpad"
# TOOL_TEST="launchpad version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

get_dir_version() {
	version="${1}"

	case "${version}" in
	0.* | 1.[01234].* | 1.5.[012])
		echo "${version}"
		;;
	*)
		echo "v${version}"
		;;
	esac
}

get_arch() {
	version="${1}"

	ua="$(uname -m)"

	case "${ua}" in
	x86_64)
		case "${version}" in
		0.* | 1.[01234].* | 1.5.[012345])
			arch="x64"
			;;
		*)
			arch="amd64"
			;;
		esac
		;;
	arm64)
		arch="arm64"
		;;
	*)
		fail "Arch ${arch} unsupported"
		;;
	esac

	echo "${arch}"
}

get_platform() {
	version="${1}"

	up="$(uname -s)"

	case "${up}" in
	Linux)
		platform="linux"
		;;
	Darwin)
		platform="darwin"
		;;
	Windows)
		case "${version}" in
		0.* | 1.[01234].* | 1.5.[012345])
			platform="win"
			;;
		*)
			platform="windows"
			;;
		esac
		;;
	FreeBSD)
		platform="freebsd"
		;;
	*)
		fail "Platform ${platform} unsupported"
		;;
	esac

	echo "${platform}"
}

get_download_url() {
	version="${1}"

	dir_version="$(get_dir_version "${version}")"
	arch="$(get_arch "${version}")"
	platform="$(get_platform "${version}")"

	case "${version}" in
	0.* | 1.[01234].* | 1.5.[012345])
		echo "https://github.com/Mirantis/launchpad/releases/download/${dir_version}/launchpad-${platform}-${arch}"
		;;
	*)
		echo "https://github.com/Mirantis/launchpad/releases/download/${dir_version}/launchpad_${platform}_${arch}_${version}"
		;;
	esac
}
