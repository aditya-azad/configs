# Configs

My config files. Use if you feel risky

## Setup

### Run as root

The playbook must be run as root (`sudo ansible-playbook ...`). The play
uses `become: true` and `become_ask_pass = False` (see `ansible.cfg`); when
run as root, `become: true` is a no-op for root-level tasks, and user-scoped
tasks drop to the managed user via `become_user: {{ username }}`.

Why root instead of interactive sudo: on `ansible_connection=local`
(legion7i), sudo writes its password prompt to the TTY, which Ansible's
local (pipe-based) connection never sees — causing
"Timed out waiting for become success or become password prompt". Running
the controller as root removes the need for any sudo escalation during the
run. `become_ask_pass = False` also makes a non-`sudo` invocation fail fast
(`sudo: a password is required`) instead of hanging.

No sudoers / NOPASSWD changes are required on any host.

### Usage

1. Clone this repository
2. Run the playbook:

```bash
# from the ansible directory
ansible-galaxy collection install -r requirements.yml

# all hosts
sudo ansible-playbook playbooks/site.yml

# one host
sudo ansible-playbook playbooks/site.yml -l legion7i
sudo ansible-playbook playbooks/site.yml -l eagle

# a single program (every task file is tagged with its program name via the
# loop label; for tag-based selection add tags to individual task files)
sudo ansible-playbook playbooks/site.yml -l legion7i --tags neovim
```

