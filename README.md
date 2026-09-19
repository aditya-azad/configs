# Configs

My config files. Use if you feel risky

## Setup

### Usage

1. Clone this repository
2. Run the playbook:

```bash
# from the ansible directory
ansible-galaxy collection install -r requirements.yml

# all hosts
ansible-playbook playbooks/site.yml

# one host
ansible-playbook playbooks/site.yml -l legion7i
ansible-playbook playbooks/site.yml -l eagle

# a single program (every task file is tagged with its program name via the
# loop label; for tag-based selection add tags to individual task files)
ansible-playbook playbooks/site.yml -l legion7i --tags neovim
```

