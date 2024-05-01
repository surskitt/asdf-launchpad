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

# launchpad releases randomly changed their urls from 1.5.6 onwards
check_old_version() {
	version="${1}"

	major="$(echo "${version}" | cut -d '.' -f 1)"
	minor="$(echo "${version}" | cut -d '.' -f 2)"
	patch="$(echo "${version}" | cut -d '.' -f 3)"

	if [[ "${major}" -lt 1 ]]; then
		return 0
	fi

	if [[ "${minor}" -lt 5 ]]; then
		return 0
	fi

	if [[ "${patch}" -lt 6 ]]; then
		return 0
	fi

	return 1
}

get_arch() {
	arch="$(uname -m)"

	case "${arch}" in
	x86_64)
		arch="amd64"
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

get_arch_old() {
	arch="$(uname -m)"

	case "${arch}" in
	x86_64)
		arch="x64"
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
	platform="$(uname -s)"

	case "${platform}" in
	Darwin | FreeBSD | Linux | Windows) ;;
	*) fail "Platform ${platform} unsupported" ;;
	esac

	echo "${platform}" | tr '[:upper:]' '[:lower:]'
}

get_platform_old() {
	platform="$(get_platform)"

	if [[ "${platform}" == "windows" ]]; then
		platform="win"
	fi

	echo "${platform}"
}

get_download_url() {
	version="${1}"

	if check_old_version "${version}"; then
		platform="$(get_platform_old)"
		arch="$(get_arch_old)"

		url="https://github.com/Mirantis/launchpad/releases/download/v${version}/launchpad-${platform}-${arch}"
	else
		platform="$(get_platform)"
		arch="$(get_arch)"

		url="https://get.mirantis.com/launchpad/v${version}/launchpad_${platform}_${arch}_${version}"
	fi

	if [[ "${url}" = *win* ]]; then
		url="${url}.exe"
	fi

	echo "${url}"
}
