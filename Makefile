# Optional machine-specific overrides (gitignored). Use it to set env vars like
# ANSIBLE_TRANSPORT / ANSIBLE_FORKS for local workarounds without touching the repo.
-include Makefile.local

# User the provider gives you on a fresh box (root on most VPS; some clouds give a
# sudo user like `ubuntu`/`ec2-user`). For a non-root initial user, also pass
# BECOME='--ask-become-pass'  e.g.  make bootstrap BOOTSTRAP_USER=ubuntu BECOME='--ask-become-pass'
BOOTSTRAP_USER ?= root
BECOME ?=

.PHONY: install bootstrap run check syntax ping dry-run lint create-user base security docker tools monitoring changelog audit healthcheck rollback

install:
	git config core.hooksPath .githooks
	ansible-galaxy collection install -r requirements.yml

bootstrap:
	ansible-playbook playbook.yml --ask-pass $(BECOME) -e ansible_user=$(BOOTSTRAP_USER) -e ansible_port=22

run:
	ansible-playbook playbook.yml

dry-run:
	ansible-playbook playbook.yml --check --diff

syntax:
	ansible-playbook playbook.yml --syntax-check

lint:
	ansible-lint playbook.yml create-user.yml

check:
	$(MAKE) syntax
	$(MAKE) lint
	$(MAKE) dry-run

ping:
	ansible all -m ping

create-user:
	ansible-playbook create-user.yml

base:
	ansible-playbook playbook.yml --tags base

security:
	ansible-playbook playbook.yml --tags security

docker:
	ansible-playbook playbook.yml --tags docker

tools:
	ansible-playbook playbook.yml --tags tools

monitoring:
	ansible-playbook playbook.yml --tags monitoring

changelog:
	git-cliff --output CHANGELOG.md

audit:
	ansible all -b -a "lynis audit system --quick --no-colors"

healthcheck:
	ansible-playbook healthcheck.yml

rollback:
	ansible-playbook rollback.yml
