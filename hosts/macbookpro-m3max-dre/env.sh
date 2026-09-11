#!/usr/bin/env /bin/bash
# shellcheck disable=SC2034

readonly EXPECTED_HOSTNAME="macbookpro-m3max-dre"
readonly NICE_HOSTNAME="${HOSTNAME/%.local/}"
