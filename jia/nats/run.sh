#!/usr/bin/env bash
# Run one nats instance in the foreground: run.sh open|secure
# Config is read from this script's own directory (the XDG config dir is
# a symlink to it), so the confs and the run command stay in one place.
set -euo pipefail

inst="${1:?usage: run.sh open|secure}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

export NATS_STORE="${XDG_STATE_HOME:-$HOME/.local/state}/x/nats/$inst"
mkdir -p "$NATS_STORE"
exec nats-server -c "$here/nats.$inst.conf"
