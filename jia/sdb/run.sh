#!/usr/bin/env bash
# Run one sdb instance in the foreground: run.sh open|secure
# Reads <inst>.env beside this script (the XDG config dir is a symlink to
# it). The secure instance's root password is generated into the
# git-ignored secret.env on first start.
set -euo pipefail

inst="${1:?usage: run.sh open|secure}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
export PATH="$HOME/.local/bin:$PATH"
state="${XDG_STATE_HOME:-$HOME/.local/state}/x/sdb/$inst"

umask 077
if [ "$inst" = secure ] && [ ! -s "$here/secret.env" ]; then
	echo "SURREAL_PASS=$(head -c 24 /dev/urandom | base64 | tr -d '/+=\n')" \
		>"$here/secret.env"
fi

mkdir -p "$state"
set -a
. "$here/$inst.env"
[ "$inst" != secure ] || . "$here/secret.env"
SURREAL_PATH="surrealkv://$state"
set +a
exec surreal start
