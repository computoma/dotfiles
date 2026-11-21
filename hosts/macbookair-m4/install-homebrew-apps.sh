#!/bin/bash
# shellcheck disable=SC2155

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly COMMON_DIR="$(cd "$SCRIPT_DIR/../common" && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly VERBOSE="${VERBOSE:-0}"
export HOMEBREW_NO_ASK=1

source "$SCRIPT_DIR/env.sh"
source "$ROOT_DIR/etc/scripts/utils.sh"
source "$COMMON_DIR/env.sh"

# NOTE: Executing the `brewª command without the `run` harness because it has a
# rich TUI.

logi "Installing Homebrew's formulae ..."
brew install 7zip aria2 bash bash-completion@2 bat bzip2 coreutils eza fd fish \
	fzf gettext git-delta gsed jq lf macmon miniserve neovim pbzip2 pigz \
	pinentry ripgrep tree xz zstd

brew unlink openssl@4

logi "Installing Homebrew's casks ..."
brew install --casks alt-tab betterdisplay chatgpt coconutbattery \
	font-jetbrains-mono-nerd-font geekbench google-chrome iina keyboardcleantool \
	mac-mouse-fix microsoft-excel microsoft-powerpoint microsoft-word obs \
	spotify zed
