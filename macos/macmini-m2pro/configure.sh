#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155
# shellcheck disable=SC2207

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
readonly ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
export VERBOSE=${VERBOSE:-0}
source "$SCRIPT_DIR/env.sh"
source "$ROOT_DIR/etc/scripts/utils.sh"

validate_host

logi "Parsing input arguments. ..."
while [[ $# -gt 0 ]]; do case $1 in
	-v) VERBOSE=1; shift;;
	*) shift;;
esac; done

/bin/bash "$SCRIPT_DIR"/configure-bash.sh
/bin/bash "$SCRIPT_DIR"/configure-dirs.sh
/bin/bash "$SCRIPT_DIR"/configure-dotfiles.sh
/bin/bash "$SCRIPT_DIR"/configure-settings.sh

logi "I'm finished!"
