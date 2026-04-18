# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Features

- Add rollback playbook ([ed6d24e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/ed6d24ec0c2df92bd2dc0ee213f7a52c4944b809))
- Add healthcheck playbook for drift detection ([8cc13ef](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/8cc13ef11d28ba25104fa18e40d289a0940bc71f))
- **security:** Allow suppressing Lynis tests via lynis_skip_tests ([01dd436](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/01dd43663d190341087b031dfa876e81a6a3248d))
- **security:** Allow additional UFW ports via variable ([83e4e50](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/83e4e504885148af6d460e9454a61bf10d5b2a3d))
- **security:** Support remote syslog forwarding ([fc2e563](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/fc2e5636a57d9e6f89570abaff495d25d01f8459))
- **security:** Install Lynis for on-demand auditing ([d241c8f](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/d241c8f02a26f01bacaf6589caed19ba26b55123))
- **security:** Enable fail2ban recidive jail ([44647b8](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/44647b89b11e30cde7827dc0f282c0a10a2cfc8e))
- **security:** [**BREAKING**] Restrict SSH login to AllowGroups ([3f20bd5](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/3f20bd5cfe9e2c28e474bbdfab3e590856080cbf))
- **security:** [**BREAKING**] Accept list of admin SSH keys ([6ab8850](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/6ab8850d40f8f4ec5294e9876663a5baa65a28e1))
- **security:** Verify SSH reachable after sshd restart ([588bd75](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/588bd754f1750a283f4efca00157d2966aa5c3b3))
- **security:** Add subsystem tags for granular targeting ([05ea639](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/05ea6394201c8e652dc2f3d1bc5436a724bf6a0d))
- Harden create-user.yml input validation ([f151e2e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/f151e2e82200a89b0a389080a375773318f10e45))
- Backup critical config before mutation ([59d7b0e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/59d7b0e2632e8f5681be0b424d33566637078491))
- Retry network-touching tasks on transient failures ([6546bd5](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/6546bd5fe21e4eca365625e68ad4277deed78709))

### Bug Fixes

- **ci:** Suppress line-length on create-user.yml regex when-clause ([f4febbc](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/f4febbc0d42591452de8c6bdb9385596cdbfb6ac))
- **ci:** Unbreak yamllint on inline-dict braces and long URL ([bd4fd00](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/bd4fd00301b366966c674eb3291752d7450561a6))
- Validate shipped placeholders trip the pre_task guards ([7f4b444](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/7f4b4445edae598487a797a3a18c44c8853df16b))
- **base:** Detect chrony to avoid systemd-timesyncd conflict ([b04364a](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/b04364af3c588ef11b8a4986dc06c199fed64337))
- **security:** Stop resetting UFW on every playbook run ([e0ee351](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/e0ee3516cf1a48a76ed0d97d04b98fda5e7aaadb))

### Documentation

- Add Contributor Covenant code of conduct ([0df93b1](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/0df93b1b406487f30f35b80f82014522159b92de))
- Add README badges for CI, version, commit/changelog conventions, and Lynis ([cafae91](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/cafae91d1f760d32bf4c4a9b6ff0b2de90960d25))
- Add threat model, post-bootstrap checklist, and lockout recovery ([a771675](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/a7716756649294f963c8e12cbac19af92e7778fc))
- Document multi-role inventory pattern ([8255b57](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/8255b57a275fed0690a621601b8a26e14ba3013a))
- Bump minimum Ansible version to 2.17 ([ef2df94](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/ef2df948ac5d8d0a4aaf959962585873e022517d))
- Add CODEOWNERS ([cd16c32](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/cd16c322a61435305f9f0a2e75d3c6618672d63d))
- Add SECURITY.md ([0d4796e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/0d4796e4a5bf54a239e5c44a0030b0ca077f792d))

### CI/CD

- Regenerate CHANGELOG.md ([df7d73f](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/df7d73f18dbba1ce1fdf18cea115ce97a27f9934))
- Regenerate CHANGELOG.md ([ffb4e5e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/ffb4e5eeb45f372ccbd5a5bbc3bbad93ff33a66e))
- Regenerate CHANGELOG.md ([c59a029](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/c59a02974f464def61b85f3d54ae29b597f9d10a))
- Enforce Conventional Commits on pull requests ([e480525](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/e4805253daa898d6506f84280427a91fa7338bfe))
- Extend release workflow gates to every playbook ([661a2d1](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/661a2d104d84427908181f68b37c621afeb849cd))
- Harden lint workflow with yamllint, shellcheck, and full-playbook gates ([5bda67e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/5bda67e338c5e1ed17285df72fe51bb2ec2c0aad))
- Regenerate CHANGELOG.md ([ba0ba85](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/ba0ba854e75c38d77914e82b0f4a3041242838eb))
- Regenerate CHANGELOG.md ([36b3c20](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/36b3c20d7ce0c544198fa4a1db6b17b2c3a2f96d))
- Add .yamllint config and drop inline suppressions ([9ffdf96](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/9ffdf969ec3b8504141e3534d2897130cb564e8c))
- **deps:** Bump node_exporter to 1.11.1 ([278c07b](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/278c07b71272ad8b9262eafd9771d07267ec793d))
- Bump and SHA-pin GitHub Actions ([4c0c717](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/4c0c717f92b26c67827c9ffe786d2f899d3fbaeb))
- **deps:** Bump ansible galaxy collections ([09cef2a](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/09cef2a681ee8b1b5a562b8863e4c0261818f9ce))
- Add Dependabot for GitHub Actions ([cebca1b](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/cebca1b739cb806a1b55d9d0b4e767fc154fd4a9))
## [1.0.1](https://github.com/amiwrpremium/ansible-server-bootstrap/releases/tag/v1.0.1) - 2026-03-14

### Bug Fixes

- Resolve Codacy issues ([a5f8c89](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/a5f8c899884a06d88e3cc09c57252ef051bfc4a4))

### Documentation

- Add Codacy badge to README ([c707f84](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/c707f8449352c7aba694f696ffbe3178e5add7e1))
## [1.0.0](https://github.com/amiwrpremium/ansible-server-bootstrap/releases/tag/v1.0.0) - 2026-03-14

### Features

- Add example configuration files ([2351c55](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/2351c55a98f18d0770322084a7f258914025bd0c))
- Add main playbook and user creation playbook ([d3f26ea](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/d3f26eacada80c729834587caa61dfdb530f2071))
- **monitoring:** Add node_exporter monitoring role ([200ad63](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/200ad63da3012598333b7de14443434d70106041))
- **tools:** Add Git and GitHub CLI role ([78177c3](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/78177c335541bf2985e8f63e71d6c08c8b407d11))
- **docker:** Add Docker CE installation role ([3b12576](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/3b1257614114b94ede96a7eb4d5113e04edfdb71))
- **security:** Add security hardening role ([7f58e5a](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/7f58e5a86285f88242db3f280d2964c47c8fba86))
- **base:** Add system bootstrap role ([4f0d97e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/4f0d97e4d196f5e391b4a39e2f27f2c73a77aaac))

### Documentation

- Fix README CI section and update project structure ([6209760](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/6209760f1a93459ae8da8ba1f640ec1a96edee22))
- Add README, contributing guide, and GitHub templates ([a1cc5f4](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/a1cc5f4c42ca4da519e5f6cf944dd4f9aef4aa6d))

### CI/CD

- Fix cliff.toml template and generate initial changelog ([a49c8bd](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/a49c8bdab28e33708bf385b10713e9148e691deb))
- Add conventional commit hook and changelog config ([194b8c5](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/194b8c5838964fcee6f9ba3b2f91bf7b25054ed8))
- Add lint and release workflows ([060627e](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/060627eb0271075645957383c04d6149cf1fd6a0))
- Add Makefile with all targets ([9f770f4](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/9f770f444d93524bca8749e565cb83cbb518904f))

### Miscellaneous

- Initialize project structure ([974dced](https://github.com/amiwrpremium/ansible-server-bootstrap/commit/974dced6c97a82422bb1f3e0665e0e6cb53f2a70))
