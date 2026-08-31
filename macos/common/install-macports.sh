#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
# shellcheck disable=SC2155

# README
# This script installs/uninstalls MacPorts.
#
# The following switches are available:
# -v: Print major commands being executed.
# -vv: Print major commands being executed and their output.
# --uninstall: Uninstall MacPorts plus all the ports and auxiliary files.
# --version: Select a specific version of MacPorts to be installed.
# 	If no version is explicitly set or it's set to "latest", this script will
# 	query and use the latest one. All available version can be found here:
#   https://distfiles.macports.org/MacPorts/RELEASE_URL

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
readonly MACPORTS_DOWNLOAD_DIR="$TMPDIR/macports"
VERBOSE="${VERBOSE:-0}"
uninstall=0
version=""

source "$ROOT_DIR/etc/scripts/utils.sh"

cleanup () {
	run rm -rf "$MACPORTS_DOWNLOAD_DIR"
}

parse_input_args () {
	while [[ $# -gt 0 ]]; do case $1 in
		--uninstall) uninstall=1; shift;;
		--version) version="$2"; shift; shift;;
		-v) VERBOSE=1; shift;;
		*) shift;;
	esac; done
}

check_preconds () {
	logi "Checking pre-conditions ..."

	if ! which -s curl; then
		loge "\`curl\` is required to download the MacPorts installer."
		exit 1
	fi
}

uninstall_macports () {
	logi "Uninstalling MacPorts ..."

	logi "Uninstalling all ports ..."
	run sudo port -fp uninstall installed

	logi "Removing users and groups ..."
	run sudo dscl . -delete /Users/macports
	run sudo dscl . -delete /Groups/macports

	logi "Removing all filesystem artifacts ..."
	run sudo rm -rf /opt/local /Applications/DarwinPorts /Applications/MacPorts \
		/Library/LaunchDaemons/org.macports.* /Library/Receipts/DarwinPorts*.pkg \
		/Library/Receipts/MacPorts*.pkg /Library/StartupItems/DarwinPortsStartup \
		/Library/Tcl/darwinports1.0 /Library/Tcl/macports1.0 ~/.macports
}

install_macports () {
	readonly MACOS_VERSION=$(run sw_vers -productVersion | run cut -d. -f1)
	readonly MACOS_NAME=$(
		case "$MACOS_VERSION" in
			26) run echo "Tahoe" ;;
			15) run echo "Sequoia" ;;
			14) run echo "Sonoma" ;;
			13) run echo "Ventura" ;;
			12) run echo "Monterey" ;;
			11) run echo "BigSur" ;;
			10.15) run echo "Catalina" ;;
			10.14) run echo "Mojave" ;;
			10.13) run echo "HighSierra" ;;
			10.12) run echo "Sierra" ;;
			*)  run echo "Unknown" ;;
		esac
	)

	if [[ -z $version || $version == "latest" ]]; then
		logi "Querying MacPorts's latest version ..."
		version=$(
			run curl --fail --location --show-error --silent \
				--connect-timeout 13 --retry 5 --retry-delay 2 \
				"https://distfiles.macports.org/MacPorts/RELEASE_URL" |
			run sed 's|.*/v||'
		)
		logi "The latest available version is $version"
	fi

	logi "Downloading MacPorts for macOS ${MACOS_NAME} to $MACPORTS_DOWNLOAD_DIR/macports-${version}.pkg ..."
	run mkdir -p "$MACPORTS_DOWNLOAD_DIR"
	run curl --fail --location --show-error --silent \
		--connect-timeout 13  --retry 5 --retry-delay 2 \
		--output "$MACPORTS_DOWNLOAD_DIR/macports-${version}.pkg" \
		"https://github.com/macports/macports-base/releases/download/v${version}/MacPorts-${version}-${MACOS_VERSION}-${MACOS_NAME}.pkg"

	logi "Installing MacPorts version $version ..."
	run sudo installer -pkg "$MACPORTS_DOWNLOAD_DIR/macports-${version}.pkg" -target /
}

trap 'cleanup' EXIT
parse_input_args "$@"
check_preconds
if [[ $uninstall == 1 ]]; then
	uninstall_macports
else
	install_macports
fi
