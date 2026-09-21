#!/bin/bash
# shellcheck disable=SC2034

readonly EXPECTED_HOSTNAME="macbookpro-m3max-gnarly"
readonly NICE_HOSTNAME="${HOSTNAME/%.local/}"
