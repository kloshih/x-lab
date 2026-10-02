# x-lab

Config for the local lab network. Each host gets a directory.

## jia

Lab server, reached over the tailnet at `100.80.150.96`. Runs two NATS
and two SurrealDB servers, each bound to the tailnet address only (jia is
also on the LAN):

| job         | port | auth                                  |
| ----------- | ---- | ------------------------------------- |
| nats-open   | 4222 | none (monitor 8222)                   |
| nats-secure | 4223 | nkeys (monitor 8223)                  |
| sdb-open    | 8000 | none (`--unauthenticated`)            |
| sdb-secure  | 8001 | root + generated password             |

Layout: `jia/nats` and `jia/sdb` are what `~/.config/x/{nats,sdb}` link
to, so the confs here are the live config. State lives under
`~/.local/state/x/{nats,sdb}`. Binaries (`nats-server`, `surreal`, `nk`,
`nats`) resolve from `~/.local/bin`.

Secrets are git-ignored: `jia/nats/nkeys/*.nk` (seeds) and
`jia/sdb/secret.env` (root password).

Setup on jia, from this checkout:

    jia/link.sh            # symlink the XDG config dirs
    jia/nats/nkeys.sh      # mint seeds + nkeys.conf (needs `nk`)
    jia/up.sh              # start all four under `xkit run`
    jia/up.sh stop|list
