#!/bin/bash
# shellcheck disable=SC2034

# readonly EXPECTED_HOSTNAME="macbookpro-m3max-gnarly"
readonly EXPECTED_HOSTNAME="Fernando-Moreira-MacBook-Pro-16-inch-Nov-2023-"
readonly NICE_HOSTNAME="${HOSTNAME/%.local/}"
