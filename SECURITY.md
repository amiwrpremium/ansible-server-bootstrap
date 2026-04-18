# Security Policy

## Reporting a Vulnerability

**Please do not open a public issue for security reports.**

Use GitHub's private vulnerability reporting from this repository's [Security tab](https://github.com/amiwrpremium/ansible-server-bootstrap/security/advisories/new).

Include in your report:

- Affected version or commit SHA
- Reproduction steps
- Impact assessment

This is a solo-maintained project, so there is no formal SLA. I'll acknowledge and triage on a best-effort basis.

## Supported Versions

Only the `master` branch and the latest tagged release receive fixes. Older tags are snapshots and will not be patched — upgrade to the latest release or track `master`.

## Scope

**In scope:**

- Playbook defaults that weaken the hardening posture (weak SSH ciphers, permissive firewall rules, missing kernel protections, insecure service configuration).
- Secrets or credentials accidentally committed to the repository.
- Supply-chain risks in pinned GitHub Actions, Ansible collections, or third-party apt repositories this playbook adds (Docker CE, GitHub CLI).
- Template injection, command injection, or unsafe variable handling in role code.

**Out of scope:**

- CVEs in upstream packages installed by the playbook (Ubuntu, Docker, fail2ban, node_exporter, etc.). Please report those to the respective projects.
- Operator misconfiguration — for example, committing your own `group_vars/all.yml` containing secrets. That path is gitignored for a reason.
- Configuration drift on servers that were provisioned with this playbook but later modified manually.

## Disclosure

Coordinated disclosure is preferred. After a fix is merged and a release is cut, I'll publish a GitHub Security Advisory crediting the reporter — unless you'd rather remain anonymous, in which case just say so in the initial report.
