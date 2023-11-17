#!/usr/bin/env bash

set -euo pipefail

[ $# -eq 1 ] || (echo "Usage: $0 DURATION" >&2; false)

PATTERN='^([0-9]+h)?([0-9]+m)?([0-9]+s)?$'
echo "$1" | grep -Eq "$PATTERN" ||
	(printf "ERROR: Invalid duration '%s' provided, expected format: %s\n" "$1" "$PATTERN" >&2; false)

DURATION="$1"
SECONDS_SUM=0

convertToSeconds() {
	SECONDS="$(echo "$DURATION" | grep -Eq "^[0-9]+$1" && expr "$(echo "$DURATION" | grep -Eo '^[0-9]+')" '*' $2 || echo 0)"
	SECONDS_SUM="$(expr $SECONDS_SUM + $SECONDS || true)"
	DURATION="$(echo "$DURATION" | sed -E "s/^[0-9]+$1//")"
}

convertToSeconds h 3600
convertToSeconds m 60
convertToSeconds s 1

echo $SECONDS_SUM
