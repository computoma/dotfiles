#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155
# shellcheck disable=SC2207

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly COMMON_DIR="$(cd "$SCRIPT_DIR/../common" && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
# The presence of BASH_ENV will make further non-interactive/non-login Bash
# sessions explicitly source $HOME/.bash_profile, which is fundamental for
# many scripts to work as intended.
export BASH_ENV="$HOME/.bash_profile"
export VERBOSE=0
source "$SCRIPT_DIR/env.sh"
source "$ROOT_DIR/etc/scripts/utils.sh"

validate_host

logi "Parsing input arguments. ..."
while [[ $# -gt 0 ]]; do case $1 in
	-v) VERBOSE=1; shift;;
	*) shift;;
esac; done

logi "Validating Apple Command Line Tools are available ..."
readonly APPLE_CLI_TOOLS_PATH="$(run xcode-select --print-path 2>/dev/null || true)"
[[ ! -d "$APPLE_CLI_TOOLS_PATH" ]] &&
	loge "XCode CLI Tools are not available. Install them first." &&
	exit 1

logi "Setting up directories, dotfiles and application settings ..."
/bin/bash "$SCRIPT_DIR"/configure.sh

logi "Installing Apple Rosetta ..." # Likely not necessary on macOS 27
run /usr/sbin/softwareupdate --install-rosetta --agree-to-license

# Installing Homebrew and Homebrew's apps.
/bin/bash "$COMMON_DIR"/install-homebrew.sh
/bin/bash "$SCRIPT_DIR"/install-homebrew-apps.sh

# Run configure.sh once more since a portion of the script need tools that are
# only available after Homebrew is installed.
logi "Setting up directories, dotfiles and application settings, once more ..."
/bin/bash "$SCRIPT_DIR"/configure.sh

logi "Setting up /etc/private/hosts ..."
/bin/bash "$ROOT_DIR"/etc/scripts/install-hosts.sh \
	--with-sb-hosts-variant unified

logi "Installing Pip packages ..."
/bin/bash "$COMMON_DIR"/install-pip-packages.sh
logi "Installing Mise packages ..."
/bin/bash "$COMMON_DIR"/install-mise.sh
logi "Installing vcpkg ..."
/bin/bash "$ROOT_DIR"/etc/scripts/install-vcpkg.sh

logi "Installing iSMC ..."
/bin/bash "$ROOT_DIR"/etc/macos/scripts/install-ismc.sh

logi "Installing macvdmtool ..."
/bin/bash "$ROOT_DIR"/etc/macos/scripts/install-macvdmtool.sh

logi "Installing VSCode's extensions ..."
/bin/bash "$ROOT_DIR"/etc/scripts/install-vscode-extensions.sh \
	--extensions-list "$COMMON_DIR"/etc/vscode.extensions.txt

logi "Taking care of the remaining environment settings ..."
/bin/bash "$COMMON_DIR"/setup-env.sh
/bin/bash "$COMMON_DIR"/setup-env-bootprefs.sh

logi "I'm finished!"
