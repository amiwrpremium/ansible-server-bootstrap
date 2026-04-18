.PHONY: install bootstrap run check syntax ping dry-run lint create-user base security docker tools monitoring changelog audit

install:
	git config core.hooksPath .githooks
	ansible-galaxy collection install -r requirements.yml

bootstrap:
	ansible-playbook playbook.yml --ask-pass -e ansible_port=22 -e ansible_ssh_common_args='-o StrictHostKeyChecking=no'

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
