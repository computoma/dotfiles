#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155

set -Eeuo pipefail

readonly CPU_ARCH="$(uname -m)"
readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly VERBOSE="${VERBOSE:-0}"

source "$ROOT_DIR/etc/scripts/utils.sh"

logi "Setting defaults for the Desktop and keyboard ..."
run defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
run defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
run defaults write com.apple.dock autohide-delay -int 0
run defaults write com.apple.dock autohide-time-modifier -float 0.30
run defaults write com.apple.dock showAppExposeGestureEnabled -bool true
run defaults write com.apple.loginwindow TALLogoutSavesState -bool false
run defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
run defaults write -g ApplePressAndHoldEnabled -bool false
run defaults write -g InitialKeyRepeat -int 10
run defaults write -g KeyRepeat -int 1
run defaults write -g NSWindowShouldDragOnGesture -bool true
run killall Dock

logi "Setting defaults for Fork ..."
run defaults write com.DanPristupov.Fork SUEnableAutomaticChecks 0
run defaults write com.DanPristupov.Fork applicationUpdateChannel 1
run defaults write com.DanPristupov.Fork defaultSourceFolder "$CODE"
run defaults write com.DanPristupov.Fork fetchAllTags 0
run defaults write com.DanPristupov.Fork fetchRemotesAutomatically 0
run defaults write com.DanPristupov.Fork updateSubmodulesOnCheckout 0

if ! grep -q "$MAIN_PREFIX/bin/bash" /etc/shells; then
	logi "Update the list of available shells ..."
	run echo "$MAIN_PREFIX/bin/bash" | run sudo tee -a /etc/shells
	run echo "$MAIN_PREFIX/bin/fish" | run sudo tee -a /etc/shells
fi

if grep -q "$MAIN_PREFIX/bin/bash" /etc/shells &&
	[[ $(dscl . -read "/Users/$USER" UserShell | cut -d' ' -f2-) != "$MAIN_PREFIX/bin/bash" ]] ; then
	logi "Setting the default user shell to $MAIN_PREFIX/bin/bash ..."
	run chsh -s "$MAIN_PREFIX/bin/bash" "$(whoami)"
fi

if [[ -f /etc/paths.d/homebrew ]]; then
	# Don't want /etc/paths.d/homebrew making any changes to $PATH.
	# Homebrew's envvars will be explicitly set in .bash_profile and config.fish
	logi "Removing /etc/paths.d/homebrew ..."
	run sudo rm /etc/paths.d/homebrew
fi

logi "Building bat's cache ..."
run bat cache --build

logi "Ignoring Focusrite Scarlett Solo automount ..."
run echo "UUID=DC798778-543D-396B-A11F-2EC42F3500F9 none msdos ro,noauto" |
	run sudo tee -a /etc/fstab

exit 0
