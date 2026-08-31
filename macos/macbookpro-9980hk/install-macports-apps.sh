#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly COMMON_DIR="$(cd "$SCRIPT_DIR/../common" && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly VERBOSE="${VERBOSE:-0}"

source "$SCRIPT_DIR/env.sh"
source "$ROOT_DIR/etc/scripts/utils.sh"
source "$COMMON_DIR/env.sh"

# NOTE: Executing the `portcommand without the `run` harness because it has a
# rich TUI.

logi "Updating MacPorts tree ..."
sudo port selfupdate

logi "Installing MacPorts ports ..."
for port_name in "${MACPORTS_DEFAULT_PORTS[@]}"; do
	logi "Installing $port_name ..."
	sudo port -N install "$port_name"
done
