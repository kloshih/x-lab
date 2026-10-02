#!/usr/bin/env bash
# Point the x XDG config dirs at this checkout: ~/.config/x/{nats,sdb}
# become symlinks to ./nats and ./sdb, so edits here are live config.
# Refuses to replace a real (non-symlink) directory.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/x"
mkdir -p "$cfg"

for svc in nats sdb; do
	dst="$cfg/$svc"
	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		echo "link.sh: $dst exists and is not a symlink; move it first" >&2
		exit 1
	fi
	ln -sfn "$here/$svc" "$dst"
	echo "$dst -> $here/$svc"
done
