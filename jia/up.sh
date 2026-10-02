#!/usr/bin/env bash
# Start (or stop/list) the jia servers under `xkit run` supervision.
#
#   up.sh [start|stop|list]      default: start
#
# Jobs: nats-open nats-secure sdb-open sdb-secure. A name that's already
# running is reported and skipped.
set -uo pipefail

export PATH="$HOME/.local/bin:$PATH"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
names=(nats-open nats-secure sdb-open sdb-secure)

case "${1:-start}" in
start)
	for n in "${names[@]}"; do
		svc="${n%%-*}" inst="${n#*-}"
		xkit run start -n "$n" -- "$here/$svc/run.sh" "$inst" ||
			echo "up.sh: $n not started (already running?)" >&2
	done
	;;
stop) xkit run stop "${names[@]}" ;;
list) xkit run list ;;
*) echo "usage: up.sh [start|stop|list]" >&2; exit 2 ;;
esac
