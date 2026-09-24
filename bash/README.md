# bash/ — pure-bash provisioning layer

One host selects a list of `programs`; each `programs` entry maps to a
`tasks/<name>.sh` that installs + configures one program idempotently.

## Run

```
bash bash/setup.sh legion7i   # or: eagle
```

Run as the **managed user** (NOT root). Root operations (`apt-get`, `/etc`,
`/usr/local`, services) use `sudo` inline; everything else runs as the user.

## Layout

| path                    | role                                              |
|-------------------------|---------------------------------------------------|
| `bash/setup.sh`         | entry point: loads host, runs pre-tasks + programs|
| `bash/lib/common.sh`    | shared env vars (sourced by setup + every task)   |
| `bash/hosts/<host>.env` | per-host user, programs list, host-specific vars  |
| `bash/tasks/<name>.sh`  | installs + configures one program                 |
| `bash/packages/`        | personal scripts (theme-switch, qvm, ...) copied by tasks |

## Pre-tasks (always run, in order)

`ssh_key` -> `git` -> `rust`, after creating `$CODE_DIR` and `$SOFTWARE_DIR`.
Then each `programs` entry runs in order.

## Per-host config

Edit `hosts/<host>.env`:
- `USERNAME`, `GIT_FULL_NAME`, `GIT_EMAIL`
- `programs=( ... )` — ordered list; each name needs a `tasks/<name>.sh`
- `ROS_DOMAIN_ID`, `NVIDIA_DRIVER_VERSION`, `PX4_PATH`, `BIZON_USER`, ...

## common.sh

`lib/common.sh` holds only the environment variables shared across tasks
(repo root, package/tasks dirs, user + derived paths, arch/kernel/nproc,
ubuntu codename). It is sourced by `setup.sh` and by every task. There are
no functions.

## Idempotency

bashrc is managed with one block per task, marked
`# BEGIN/END configs <name>`. Each task removes its own block with `sed`
then appends a fresh one with `cat >>`. Single managed lines (`/etc/hosts`,
`export ROS_DOMAIN_ID=...`) use `grep` + `sed` replace-or-append. All other
operations are plain `sudo apt-get`, `mkdir`, `ln`, `git`, `systemctl`, ...
guarded by `[[ -x ... ]]` / `[[ -f ... ]]` checks.

## Notes

- `eagle` lists `python_lsp`, which has no task file. `setup.sh` prints a
  warning and skips it.
- `setup.sh` aborts on the first failing program (`set -e`).
