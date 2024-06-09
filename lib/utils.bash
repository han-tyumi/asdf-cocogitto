#!/usr/bin/env bash

set -euo pipefail

# GitHub homepage where releases can be downloaded for cocogitto.
GH_REPO="https://github.com/cocogitto/cocogitto"
TOOL_NAME="cocogitto"
TOOL_TEST="cog --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3-
}

list_all_versions() {
	list_github_tags
}

get_target() {
	local os arch normalized_os target
	os="$(uname -s)"
	arch="$(uname -m)"

	case "$os" in
		Linux)
			normalized_os="unknown-linux"
			;;
		Darwin)
			normalized_os="apple-darwin"
			;;
		*)
			fail "Your OS, $os, is not supported by $TOOL_NAME."
			;;
	esac

	case "$arch" in
		aarch64)
			target="aarch64-$normalized_os-gnu"
			;;
		armv7l)
			target="armv7-$normalized_os-musleabihf"
			;;
		x86_64)
			if [ "$normalized_os" = "unknown-linux" ]; then
				target="x86_64-$normalized_os-musl"
			else
				target="x86_64-$normalized_os"
			fi
			;;
		arm64)
			if [ "$normalized_os" = "apple-darwin" ]; then
				target="x86_64-$normalized_os"
			fi
			;;
	esac

	if [ -z "$target" ]; then
		fail "Your architecture, $arch, is not supported by $TOOL_NAME."
	fi

	echo "$target"
}

download_release() {
	local version filename target url
	version="$1"
	filename="$2"
	target="$(get_target)"

	url="$GH_REPO/releases/download/$version/$TOOL_NAME-$version-$target.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only."
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
