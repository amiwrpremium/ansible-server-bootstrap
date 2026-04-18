# Contributing

Thanks for considering contributing to ansible-server-bootstrap.

## Code of Conduct

This project adheres to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct. By participating — opening issues, submitting PRs, commenting, or otherwise interacting with the project — you agree to uphold it. Read the full text in [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/<your-username>/ansible-server-bootstrap.git
   cd ansible-server-bootstrap
   ```
3. Create a branch:
   ```bash
   git checkout -b my-feature
   ```
4. Install dependencies:
   ```bash
   make install
   ```
5. Install [ansible-lint](https://docs.ansible.com/projects/lint/installing/):
   ```bash
   # macOS
   brew install ansible-lint

   # pip (any platform)
   pip3 install ansible-lint
   ```

## Making Changes

- Keep changes focused and minimal. One feature or fix per PR.
- Follow existing code patterns and Ansible best practices.
- Use fully qualified collection names (e.g., `ansible.builtin.apt`, not `apt`).
- Add variables to `group_vars/all.yml` and `group_vars/example.all.yml` if your change introduces new configuration.
- Test your changes with `make dry-run` against a real Ubuntu 24.04+ server if possible.

## Before Submitting

Run the linter and syntax check:

```bash
make check
```

This runs `ansible-lint`, syntax check, and a dry-run. Fix any errors before submitting.

## Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). A git hook enforces this automatically when you run `make install`.

Format: `<type>[optional scope]: <description>`

| Type       | Description                          |
| ---------- | ------------------------------------ |
| `feat`     | New feature                          |
| `fix`      | Bug fix                              |
| `docs`     | Documentation only                   |
| `style`    | Formatting, no logic change          |
| `refactor` | Code change, no feature or fix       |
| `perf`     | Performance improvement              |
| `test`     | Adding or fixing tests               |
| `build`    | Build system or dependencies         |
| `ci`       | CI configuration                     |
| `chore`    | Maintenance tasks                    |
| `revert`   | Reverting a previous commit          |

Examples:

```
feat: add swap file configuration
fix(security): correct sysctl ip_forward value
docs: update README with troubleshooting section
feat!: drop Ubuntu 22.04 support
```

## Pull Requests

- Target the `master` branch.
- Write a clear description of what your change does and why.
- Use conventional commit messages.
- If your PR adds a new feature, update the README accordingly.

## Reporting Issues

- Use the issue templates provided.
- Include your Ansible version (`ansible --version`) and target OS version.
- For playbook failures, include the full error output.

## Code Style

- Use `ansible.builtin.*` and `community.general.*` fully qualified module names.
- Use `'0644'` style for file modes (quoted, with leading zero).
- Use `true`/`false` for booleans, not `yes`/`no`.
- Use 2-space indentation in YAML.
- Add `changed_when` to `command`/`shell` tasks where appropriate.
