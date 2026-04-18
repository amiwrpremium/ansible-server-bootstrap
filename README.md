# ansible-server-bootstrap

[![Ansible Lint](https://github.com/amiwrpremium/ansible-server-bootstrap/actions/workflows/lint.yml/badge.svg)](https://github.com/amiwrpremium/ansible-server-bootstrap/actions/workflows/lint.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/b06f39bab2b6443192dc03fde0ca53cc)](https://app.codacy.com/gh/amiwrpremium/ansible-server-bootstrap/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04+-orange.svg)](https://ubuntu.com/)
[![Ansible](https://img.shields.io/badge/Ansible-2.17+-red.svg)](https://docs.ansible.com/)

Ansible playbook for provisioning and hardening a fresh Ubuntu 24.04+ VPS. One command to go from a bare server to a fully configured, secured, production-ready machine.

## TL;DR

```bash
# Install dependencies
make install

# Copy and edit config files
cp inventory/example.hosts.yml inventory/hosts.yml    # set your server IP
cp group_vars/example.all.yml group_vars/all.yml      # set your SSH public key

# First run (fresh server, port 22, password auth)
make bootstrap

# All future runs (port 2222, key auth)
make run

# Run a single role
make security

# Create a new sudo user
make create-user
```

## Disclaimer

This software is provided "as is", without warranty of any kind. Use at your own risk. The author is not responsible for any damages, data loss, security breaches, or other issues that may arise from using this software.

## What This Does

### Base (`roles/base`)

- Sets hostname, timezone, and locale (`en_US.UTF-8`)
- Full `apt dist-upgrade` with autoremove and autoclean
- Installs essential packages: `htop`, `tmux`, `vim`, `jq`, `curl`, `wget`, `unzip`, `ncdu`, `tree`, `net-tools`, `dnsutils`, `iotop`, `sysstat`, `logrotate`, and more
- Creates a 1G swap file with swappiness set to 10
- Configures journald log limits (500M total, 50M per file)
- Enables NTP time sync via `systemd-timesyncd`
- Increases file descriptor limits to 65535 (configurable, validated between 1024-1048576)
- Configures bash history: 10k entries, timestamps, deduplication, immediate append
- Disables noisy Ubuntu MOTD scripts (Ubuntu Pro ads, ESM nags, release upgrade prompts)
- Removes `snapd` completely
- Creates `/etc/apt/keyrings` directory for GPG keys

### Security (`roles/security`)

- **SSH hardening**:
  - Moves SSH to port 2222 (configurable)
  - Key-only authentication, password auth disabled
  - Modern ciphers only: `curve25519-sha256`, `chacha20-poly1305`, `aes256-gcm`
  - Disables agent forwarding, TCP forwarding, X11 forwarding, tunneling
  - Login grace time: 30 seconds, max 3 auth tries
  - Client alive interval: 300 seconds, max 2 missed keepalives
  - Adds an unauthorized access warning banner
  - Locks the root password (key-only access)
  - Restricts SSH login to members of `sudo` or `root` groups via `AllowGroups`
- **UFW firewall**:
  - Default deny incoming, allow outgoing
  - Rate-limited SSH on the configured port (complements fail2ban)
- **Fail2ban**:
  - SSH jail enabled with configurable ban time (default: 1 hour), find time (10 min), and max retries (3)
  - Uses UFW as the ban action
- **Kernel hardening** (25 sysctl parameters):
  - IP forwarding enabled (required for Docker)
  - Disables source routing, ICMP redirects, send redirects
  - Enables SYN cookies, martian logging, broadcast ICMP ignore
  - Enables reverse path filtering
  - Disables core dumps for SUID binaries
  - Full ASLR (randomize_va_space = 2)
  - Restricts dmesg and kernel pointer access
  - Protects hardlinks and symlinks
- **TCP BBR**: Enables Google's BBR congestion control algorithm with `fq` queueing discipline for better network throughput
- **Shared memory hardening**: Mounts `/dev/shm` with `noexec,nosuid,nodev`
- **Kernel module blacklist**: Disables unused filesystem modules (`cramfs`, `freevxfs`, `jffs2`, `hfs`, `hfsplus`, `udf`) and network protocols (`dccp`, `sctp`, `rds`, `tipc`)
- **Unattended upgrades**: Daily security and standard updates, auto-removes unused kernels and dependencies, configurable email notifications and auto-reboot
- **Needrestart**: Automatically restarts services after package updates
- **Reboot check**: Warns at the end of each run if a reboot is pending (e.g., after kernel updates)

### Docker (`roles/docker`)

- Removes conflicting packages (`docker.io`, `podman-docker`, etc.)
- Installs Docker CE, CLI, containerd, buildx, and compose plugin from the official Docker repository
- Configures Docker daemon:
  - JSON file log driver with rotation (10MB max, 3 files)
  - `overlay2` storage driver
  - Live restore enabled (containers survive daemon restarts)

### Tools (`roles/tools`)

- Installs and configures Git (default branch: `master`, editor: `vim`)
- Installs GitHub CLI (`gh`) from the official apt repository

### Monitoring (`roles/monitoring`)

- Installs Prometheus node_exporter v1.11.1 (configurable)
- Runs as a dedicated `node_exporter` system user
- Listens on `127.0.0.1:9100` (localhost only, not exposed to the internet)
- Enables systemd and process collectors
- Hardened systemd service: `NoNewPrivileges`, `ProtectHome`, `ProtectSystem=strict`

## Prerequisites

- A fresh Ubuntu 24.04+ VPS with root SSH access
- Ansible installed on your local machine
- An SSH key pair (ed25519 recommended)

### Install Ansible

See the [official Ansible installation guide](https://docs.ansible.com/ansible/latest/installation_guide/) for full details.

```bash
# macOS
brew install ansible

# Ubuntu/Debian
sudo apt install ansible

# pip
pip install ansible
```

## Quick Start

### Step 1: Clone the repo

```bash
git clone https://github.com/amiwrpremium/ansible-server-bootstrap.git
cd ansible-server-bootstrap
```

### Step 2: Install required Ansible collections

```bash
make install
```

This installs `ansible.posix` and `community.general` from Ansible Galaxy.

### Step 3: Copy the example config files

```bash
cp inventory/example.hosts.yml inventory/hosts.yml
cp group_vars/example.all.yml group_vars/all.yml
```

These files are gitignored so your credentials are never committed.

### Step 4: Configure your server IP

Edit `inventory/hosts.yml` and set your server's IP address:

```yaml
all:
  hosts:
    vps:
      ansible_host: "203.0.113.50"    # <-- your server IP
      ansible_user: root
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      ansible_port: 2222
```

> **Note:** The inventory uses port 2222 because that's what the server will use after the playbook runs. For the first run, `make bootstrap` automatically overrides this to port 22.

### Step 5: Configure your SSH public keys

Edit `group_vars/all.yml` and set at least one SSH public key. This is a list — add an entry per admin who should have root access:

```yaml
ssh_public_keys:
  - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... alice@example.com"
  - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... bob@example.com"
```

To get your public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

If you don't have an SSH key yet:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

### Step 6: Install sshpass (needed for first run only)

The bootstrap step uses `--ask-pass` which requires [`sshpass`](https://sourceforge.net/projects/sshpass/) to be installed on your local machine:

```bash
# macOS
brew install hudochenkov/sshpass/sshpass

# Ubuntu/Debian
sudo apt install sshpass
```

### Step 7: Bootstrap the server (first run only)

The first time you run the playbook, your server is still on the default SSH port (22) and may require a password. Use:

```bash
make bootstrap
```

This runs the playbook with `--ask-pass` on port 22. It will:

- Prompt you for the root password
- Configure everything including changing SSH to port 2222
- After this, password auth is disabled and SSH moves to port 2222

### Step 8: Subsequent runs

For all future runs (the server is now on port 2222 with key auth):

```bash
make run
```

### Step 9: Verify connectivity

```bash
ssh -p 2222 root@YOUR_SERVER_IP
```

## Creating Additional Users

The `create-user.yml` playbook creates a new sudo user with SSH key authentication and passwordless sudo.

### Interactive mode (prompts for input)

```bash
make create-user
```

You will be prompted for:

1. **Username** - the new user's login name
2. **SSH public key** - the user's public key for authentication
3. **Shell** - defaults to `/bin/bash`, can be changed to `/bin/zsh` etc.

### Non-interactive mode (pass parameters on CLI)

```bash
ansible-playbook create-user.yml \
  -e "username=deploy" \
  -e "user_ssh_public_key='ssh-ed25519 AAAA...'" \
  -e "user_shell=/bin/bash"
```

### What it does

- Creates the user with a home directory
- Adds them to the `sudo` group
- Configures passwordless sudo via `/etc/sudoers.d/`
- Adds their SSH public key to `~/.ssh/authorized_keys`

### Connect as the new user

```bash
ssh -p 2222 deploy@YOUR_SERVER_IP
```

## Managing Admin Keys

Root access is controlled by `ssh_public_keys` in `group_vars/all.yml`. Each key is a separate admin.

### Add an admin

```yaml
ssh_public_keys:
  - "ssh-ed25519 AAAA... alice@example.com"
  - "ssh-ed25519 AAAA... bob@example.com"   # <-- new admin
```

```bash
make run
```

### Revoke an admin

Remove the line, then rerun. The playbook will remove the key from `/root/.ssh/authorized_keys`:

```yaml
ssh_public_keys:
  - "ssh-ed25519 AAAA... alice@example.com"
  # bob removed
```

```bash
make run
```

This revocation only works because `ssh_authorized_keys_exclusive` defaults to `true` — the playbook treats `ssh_public_keys` as the complete authoritative list. Any key present on the server but not in the list gets removed on each run, including keys added manually via `ssh-copy-id`.

### Preserving ad-hoc keys

If you need to keep keys that aren't managed by the playbook (e.g., emergency access), set:

```yaml
ssh_authorized_keys_exclusive: false
```

In that mode, the playbook only adds keys; it never removes them. You'll have to revoke keys manually.

## Configuration Reference

All variables are in `group_vars/all.yml`. Every variable has a sensible default.

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_port` | `2222` | SSH listen port |
| `ssh_public_keys` | `["CHANGE_ME"]` | List of SSH public keys authorized for root (required, at least one) |
| `ssh_authorized_keys_exclusive` | `true` | When `true`, any keys in root's `authorized_keys` not in `ssh_public_keys` are removed on each run. Set `false` to preserve ad-hoc keys. |
| `hostname` | `server` | Server hostname |
| `timezone` | `UTC` | Server timezone |
| `system_locale` | `en_US.UTF-8` | System locale |
| `nofile_limit` | `65535` | Max open file descriptors (1024-1048576) |
| `swap_size` | `1G` | Swap file size |
| `swap_swappiness` | `10` | Swap aggressiveness (0-100, lower = less swap) |
| `ssh_max_auth_tries` | `3` | Max SSH authentication attempts |
| `ssh_allow_groups` | `["sudo", "root"]` | Groups allowed to SSH in. Empty list disables the restriction. |
| `fail2ban_bantime` | `3600` | Ban duration in seconds (1 hour) |
| `fail2ban_findtime` | `600` | Time window for counting failures (10 min) |
| `fail2ban_maxretry` | `3` | Max failures before ban |
| `node_exporter_version` | `1.11.1` | Prometheus node_exporter version |
| `node_exporter_listen_address` | `127.0.0.1:9100` | node_exporter listen address |
| `unattended_upgrades_mail` | `""` | Email for upgrade notifications (empty = disabled) |
| `unattended_upgrades_auto_reboot` | `false` | Auto-reboot after kernel updates |
| `unattended_upgrades_auto_reboot_time` | `02:00` | Auto-reboot time (if enabled) |

### Overriding variables at runtime

You can override any variable without editing files:

```bash
ansible-playbook playbook.yml -e "hostname=web-prod" -e "swap_size=2G" -e "ssh_port=2200"
```

## Available Make Commands

| Command | Description |
|---------|-------------|
| `make install` | Install required Ansible Galaxy collections |
| `make bootstrap` | First run: connects on port 22 with password auth |
| `make run` | Run the full playbook (all roles) |
| `make base` | Run only the base role |
| `make security` | Run only the security role |
| `make docker` | Run only the docker role |
| `make tools` | Run only the tools role |
| `make monitoring` | Run only the monitoring role |
| `make dry-run` | Preview changes without applying (check mode with diff) |
| `make syntax` | Check playbook syntax |
| `make lint` | Run ansible-lint on all playbooks |
| `make check` | Run syntax check, lint, and dry-run |
| `make ping` | Test connectivity to all hosts |
| `make create-user` | Create a new sudo user (interactive) |
| `make changelog` | Generate CHANGELOG.md from commit history |

### Targeting subsystems inside the security role

The security role is further tagged so you can run just one subsystem without touching the others:

| Tag | Scope |
|-----|-------|
| `ssh` | SSH daemon config, authorized key, banner, root password lock |
| `firewall` | UFW install, policies, rate-limit rule, enable |
| `fail2ban` | fail2ban install, jail config, service enable |
| `kernel` | sysctl hardening, TCP BBR, `/dev/shm`, module blacklist |
| `updates` | unattended-upgrades, needrestart |
| `reboot` | Detect and warn if a reboot is pending |

Usage:

```bash
ansible-playbook playbook.yml --tags ssh
ansible-playbook playbook.yml --tags kernel
```

`--tags security` still runs the entire security role (every task carries both the role tag and its subsystem tag). Use `ansible-playbook playbook.yml --list-tags` to see all available tags.

## Node Exporter

Node exporter listens on `127.0.0.1:9100` by default (not exposed to the internet). To access metrics:

### Via SSH tunnel

```bash
ssh -L 9100:localhost:9100 -p 2222 root@YOUR_SERVER_IP
```

Then open <http://localhost:9100/metrics> in your browser.

### From a remote Prometheus server

Add a scrape job to your Prometheus config, using an SSH tunnel or a reverse proxy to reach port 9100.

## Multiple Servers

To manage multiple servers, add more hosts to `inventory/hosts.yml`:

```yaml
all:
  hosts:
    web-1:
      ansible_host: "203.0.113.50"
      ansible_user: root
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      ansible_port: 2222
    web-2:
      ansible_host: "203.0.113.51"
      ansible_user: root
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      ansible_port: 2222
```

You can target a specific host:

```bash
ansible-playbook playbook.yml --limit web-1
```

## Project Structure

```
.
├── ansible.cfg                 # Ansible configuration
├── playbook.yml                # Main playbook (runs all roles)
├── create-user.yml             # Standalone playbook to create sudo users
├── Makefile                    # Convenience commands
├── requirements.yml            # Required Ansible Galaxy collections
├── cliff.toml                  # git-cliff changelog configuration
├── CHANGELOG.md                # Auto-generated changelog
├── CONTRIBUTING.md             # Contribution guidelines
├── LICENSE                     # MIT license
├── .ansible-lint               # Linter configuration
├── .githooks/
│   └── commit-msg              # Conventional commit validation hook
├── .github/
│   ├── workflows/
│   │   ├── lint.yml            # CI: runs ansible-lint on push/PR
│   │   └── release.yml         # CI: create release on semver tags
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml      # Bug report template
│   │   └── feature_request.yml # Feature request template
│   └── pull_request_template.md
├── inventory/
│   ├── example.hosts.yml       # Example inventory (copy to hosts.yml)
│   └── hosts.yml               # Your inventory (gitignored)
├── group_vars/
│   ├── example.all.yml         # Example variables (copy to all.yml)
│   └── all.yml                 # Your variables (gitignored)
└── roles/
    ├── base/
    │   ├── tasks/main.yml      # System setup, packages, swap, locale, history
    │   └── handlers/main.yml   # Restart journald, reload systemd
    ├── security/
    │   ├── tasks/main.yml      # SSH, UFW, fail2ban, kernel, BBR, upgrades
    │   ├── handlers/main.yml   # Restart SSH, restart fail2ban
    │   └── templates/
    │       ├── sshd_config.j2          # SSH daemon configuration
    │       ├── jail.local.j2           # Fail2ban jail configuration
    │       └── 50unattended-upgrades.j2 # Unattended upgrades configuration
    ├── docker/
    │   ├── tasks/main.yml      # Docker CE installation and configuration
    │   └── handlers/main.yml   # Restart Docker
    ├── tools/
    │   └── tasks/main.yml      # Git and GitHub CLI installation
    └── monitoring/
        ├── tasks/main.yml      # node_exporter installation
        └── handlers/main.yml   # Reload systemd, restart node_exporter
```

## Troubleshooting

### "ssh_public_keys is not configured"

You forgot to create your config file or set your SSH public key. Make sure you copied the example:

```bash
cp group_vars/example.all.yml group_vars/all.yml
```

Then edit `group_vars/all.yml` and set at least one real key:

```yaml
ssh_public_keys:
  - "ssh-ed25519 AAAA... you@example.com"
```

### "ssh_public_key (scalar) has been replaced by ssh_public_keys (list)"

The variable name and type changed. Update `group_vars/all.yml`:

```diff
-ssh_public_key: "ssh-ed25519 AAAA... you@example.com"
+ssh_public_keys:
+  - "ssh-ed25519 AAAA... you@example.com"
```

### "ansible_host is not configured"

You forgot to create your inventory file or set your server IP. Make sure you copied the example:

```bash
cp inventory/example.hosts.yml inventory/hosts.yml
```

Then edit `inventory/hosts.yml` and set your IP:

```yaml
ansible_host: "203.0.113.50"
```

### Can't connect after first run

After `make bootstrap`, SSH moves to port 2222 and password auth is disabled. Connect with:

```bash
ssh -p 2222 root@YOUR_SERVER_IP
```

If you're locked out, use your VPS provider's web console to fix `/etc/ssh/sshd_config`.

### "WARNING: A system reboot is required"

The playbook detected `/var/run/reboot-required` on the server. This usually means a kernel update was installed. Reboot the server:

```bash
ssh -p 2222 root@YOUR_SERVER_IP 'reboot'
```

### Playbook fails on a non-Ubuntu system

This playbook only supports Ubuntu 24.04 and later. It validates the OS version before running and will fail with a clear error message on unsupported systems.

### Changed `ssh_port` leaves an orphaned UFW rule

If you change `ssh_port` after the first run (e.g., from `2222` to `2200`), the playbook adds the new rate-limit rule but does not remove the old one. Delete it manually:

```bash
ssh -p <new_port> root@YOUR_SERVER_IP 'ufw delete limit <old_port>/tcp'
```

### Testing changes before applying

Always preview changes first with:

```bash
make dry-run
```

This runs the playbook in check mode with diff output, showing what would change without actually changing anything.

## CI

A GitHub Actions workflow (`.github/workflows/lint.yml`) runs `ansible-lint` on every push and pull request to `master`. To run it locally:

Install [ansible-lint](https://docs.ansible.com/projects/lint/installing/):

```bash
# macOS
brew install ansible-lint

# pip (any platform)
pip3 install ansible-lint
```

Then run:

```bash
make lint
```

## License

MIT - See [LICENSE](LICENSE) for details.
