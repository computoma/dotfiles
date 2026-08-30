#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly VERBOSE="${VERBOSE:-0}"

source "$ROOT_DIR/etc/scripts/utils.sh"

logi "Configuring boot preferences and power management settings ..."
# run sudo nvram AutoBoot=%00 -> Disables automatic boot when opening the lid.
# run sudo nvram AutoBoot=%03 -> Restore original behavior.
run sudo nvram AutoBoot=%00

# Settings when running on battery
run sudo pmset -b displaysleep 3 sleep 5 gpuswitch 0 lidwake 1 powernap 0 \
	proximitywake 0 ring 0 womp 0 acwake 0 lessbright 1 lowpowermode 1 \
	autopoweroff 0 hibernatemode 0 standby 0

# Settings when running on power
run sudo pmset -c displaysleep 10 sleep 10 gpuswitch 2 lidwake 1 powernap 1 \
	proximitywake 0 ring 0 womp 1 acwake 0 lessbright 0 lowpowermode 0 \
	autopoweroff 0 hibernatemode 0 standby 0

exit 0
