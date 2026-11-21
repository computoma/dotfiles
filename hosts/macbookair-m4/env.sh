#!/bin/bash
# shellcheck disable=SC2034

readonly EXPECTED_HOSTNAME="bear"
readonly NICE_HOSTNAME="${HOSTNAME/%.local/}"
