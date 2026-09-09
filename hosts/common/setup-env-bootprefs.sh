#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly VERBOSE="${VERBOSE:-0}"

source "$ROOT_DIR/etc/scripts/utils.sh"

logi "Setting boot preferences ..."
# run sudo nvram BootPreference=%00 -> Disables auto-boot when opening the lid or/and when connecting to power.
# run sudo nvram BootPreference=%01 -> Disables auto-boot when opening the lid, only.
# run sudo nvram BootPreference=%02 -> Disables auto-boot when connecting to power, only.
# run sudo nvram -d BootPreference -> Restore factory behavior.
run sudo nvram BootPreference=%01

exit 0
