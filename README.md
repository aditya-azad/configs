# Configs

My config files. Use if you feel risky

## Setup

Provisioning is done with the bash layer in `bash/`. Each host selects a list of `programs`; each entry maps to a `bash/tasks/<name>.sh` that installs and configures one program idempotently.

### Usage

```bash
# from the repo root
bash bash/setup.sh legion7i   # or: eagle
```

Run as the **managed user** (NOT root). Root operations (`apt-get`, `/etc`, `/usr/local`, services) use `sudo` inline; everything else runs as the user.

### Layout

| path                    | role                                              |
|-------------------------|---------------------------------------------------|
| `bash/setup.sh`         | entry point: loads host, runs pre-tasks + programs|
| `bash/lib/common.sh`    | shared env vars (sourced by setup + every task)   |
| `bash/hosts/<host>.env` | per-host user, programs list, host-specific vars |
| `bash/tasks/<name>.sh`  | installs + configures one program                 |
| `bash/packages/`        | personal scripts (theme-switch, qvm, ...) copied by tasks |

### Pre-tasks

`ssh_key` -> `git` -> `rust` are always run first, after creating `$CODE_DIR` and `$SOFTWARE_DIR`. Then each `programs` entry runs in order.

### Per-host config

Edit `bash/hosts/<host>.env`:
- `USERNAME`, `GIT_FULL_NAME`, `GIT_EMAIL`
- `programs=( ... )` — ordered list; each name needs a `bash/tasks/<name>.sh`
- `ROS_DOMAIN_ID`, `NVIDIA_DRIVER_VERSION`, `PX4_PATH`, `BIZON_USER`, ...

### Idempotency

bashrc is managed with one block per task, marked `# BEGIN/END configs <name>`. Each task removes its own block with `sed` then appends a fresh one with `cat >>`. Single managed lines use `grep` + `sed` replace-or-append. All other operations are plain `sudo apt-get`, `mkdir`, `ln`, `git`, `systemctl`, ... guarded by `[[ -x ... ]]` / `[[ -f ... ]]` checks.

### Notes

- `setup.sh` aborts on the first failing program (`set -e`).
- If a program in `programs` has no matching task file, a warning is printed and it is skipped.
