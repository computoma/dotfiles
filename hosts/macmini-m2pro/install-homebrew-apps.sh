#!/usr/bin/env /bin/bash
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
brew install "${HOMEBREW_DEFAULT_FORMULAE[@]}"
brew install --ignore-dependencies liblinear lua nmap
brew unlink openssl@3

logi "Installing Homebrew's casks ..."
brew install --casks "${HOMEBREW_DEFAULT_CASKS[@]}"
