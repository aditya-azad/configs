# bash/ — pure-bash provisioning layer

Drop-in replacement for the `ansible/` playbooks. Same structure: one host
selects a list of `programs`, each `programs` entry maps to a
`tasks/<name>.sh` that installs + configures one program idempotently.

## Run

```
bash bash/setup.sh legion7i   # or: eagle
```

Run as the **managed user** (NOT root). The sudo password is prompted once
at startup and kept alive in the background, so long user-side builds
don't trigger re-prompts. Root operations (`apt-get`, `/etc`, `/usr/local`,
services) use `sudo` inline; everything else runs directly as the user.

## Layout (ansible -> bash)

| ansible                              | bash                          |
|--------------------------------------|-------------------------------|
| `ansible/playbooks/site.yml`         | `bash/setup.sh`               |
| `ansible/inventory.ini`              | `setup.sh <host>` argument    |
| `ansible/group_vars/all.yml`         | `bash/lib/common.sh` (vars)   |
| ansible modules (apt, systemd, copy...) | inlined as `sudo ...` in each task |
| `blockinfile`/`lineinfile` markers     | `bash/lib/common.sh` (idempotency)|
| `ansible/host_vars/<host>.yml`       | `bash/hosts/<host>.env`       |
| `ansible/tasks/<name>.yml`           | `bash/tasks/<name>.sh`        |
| `ansible/files/packages/`            | unchanged (personal software) |

## Pre-tasks (always run, in order)

`ssh_key` -> `git` -> `rust` (mirrors `site.yml` pre_tasks), after creating
`$CODE_DIR` and `$SOFTWARE_DIR`. Then each `programs` entry runs in order.

## Per-host config

Edit `hosts/<host>.env`:
- `USERNAME`, `GIT_FULL_NAME`, `GIT_EMAIL`
- `programs=( ... )` — ordered list; each name needs a `tasks/<name>.sh`
- `ROS_DOMAIN_ID`, `NVIDIA_DRIVER_VERSION`, `PX4_PATH`, `BIZON_USER`, ...

## Idempotency

`lib/common.sh` holds only environment variables plus the two AGENTS.md-
mandated idempotency primitives: `blockinfile` (managed
`# BEGIN/END ANSIBLE <marker>` blocks) and `lineinfile` (regexp replace-or-
append). All other operations are written as plain `sudo apt-get`, `mkdir`,
`ln`, `git`, `systemctl`, ... directly in each task, guarded by `[[ -x ... ]]`
/ `[[ -f ... ]]` checks.

## Notes

- `lib/common.sh` is intentionally tiny: env vars + `init_host` +
  `blockinfile` + `lineinfile`. The harness (sudo keepalive, logging,
  root-check) lives in `setup.sh`.
- `eagle` lists `python_lsp`, which has no task file (the ansible
  `tasks/python_lsp.yml` never existed either). `setup.sh` warns and skips it.
- Personal scripts still live at `ansible/files/packages/` and are copied
  from there by `tasks/local_scripts.sh` via `$PACKAGES_DIR`.
- `setup.sh` aborts on the first failing program (errexit), like ansible.
