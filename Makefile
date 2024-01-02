#!/usr/bin/env make

#
#
# Depends on:
#     ansible/*
#
# Generate:
#     x
#
full: clear clean dump dependencies dump-runtimes lint build ok

dev: clear dump dependencies dump-runtimes lint build ok

ABS_ROOT=$(shell pwd)

PUBLISH=tmp/publish
ENCRYPTION_MOCK=.config/ansible-encryption-mock

SHELL=/bin/bash -o pipefail -o errexit
export PATH := $(ABS_ROOT)/bin:$(ABS_ROOT)/.python/bin:$(PATH)
export PYTHONPATH := $(ABS_ROOT)/.python

.PHONY: clear
.PHONY: clean
.PHONY: build
.PHONY: dump
.PHONY: dependencies
.PHONY: dump-runtimes
.PHONY: lint
.PHONY: test
.PHONY: release
.PHONY: ok

clear:
	clear

clean:
	rm -f "$(PUBLISH)/dev-config.json"
	rm -fr built
	rm -fr tmp
	rm -fr .python
	docker ps | ( grep test-ansible || true ) | awk '{print $$1}' | xargs --no-run-if-empty -- docker kill
	docker image list --filter 'reference=test-ansible/*' --format '{{.Repository}}:{{.Tag}}' | xargs --no-run-if-empty -- docker image rm -f
	docker volume list --quiet | ( grep 'test-ansible' || true ) | xargs --no-run-if-empty -- docker rm -f

dump:
	@echo "ABS_ROOT:          $(ABS_ROOT)"
	@echo "ENCRYPTION_MOCK:   $(ENCRYPTION_MOCK)"
	@echo "PUBLISH:           $(PUBLISH)"
	@echo ""
	@echo "PATH:              $(PATH)"
	@echo "PYTHONPATH:        $(PYTHONPATH)"

dependencies: .python/.built \
	built/encryption-key \
	built/ssh-key

.python/.built: requirements.txt
# pytest: lint
	pip install --upgrade --target "$(ABS_ROOT)"/.python -r requirements.txt
	touch "$@"

built/encryption-key:
	mkdir -p "$(dir $@)"
	if [ ! -r "$@" ]; then \
		if [ -r ~/restricted/ansible-encryption-key ]; then \
			ln -fs ~/restricted/ansible-encryption-key "built/encryption-key"; \
		else \
			echo "12345-encryption-key-6789" > built/encryption-key; \
		fi \
	fi

built/ssh-key:
	mkdir -p "$(dir $@)"
	if [ ! -r "$@" ]; then \
		if [ -r $(HOME)/.ssh/id_rsa ]; then \
			ln -fs $(HOME)/.ssh/id_rsa "$@"; \
		fi \
	fi

dump-runtimes: dependencies
	@type ansible | grep "$(ABS_ROOT)/"
	@ansible --version

	@type ansible-lint | grep "$(ABS_ROOT)/"
	@ansible-lint --version

	@type ansible-playbook | grep "$(ABS_ROOT)/"
	@ansible-playbook --version

lint: dependencies
	ansible-lint
	@echo "$@ ok"

build: dependencies \
	tmp/.built \
	tmp/dev-config.json

tmp/.built: .python/.built
	mkdir -p "$(dir $@)"
	touch "$@"

tmp/dev-config.json: tmp/.built
	mkdir -p "$(dir $@)"
	ansible-playbook \
		--vault-password-file $(ABS_ROOT)/$(ENCRYPTION_MOCK) \
		build-artifacts.yml
	touch "$@"

test: tmp/tests/.built \
		tmp/00-parameters.yml

	run-parts --exit-on-error --verbose --regex "^[0-9][0-9]-.*" ./tests/

tmp/tests/.built: \
		.devcontainer/setup.sh

	mkdir -p "$(dir $@)"
	cd .devcontainer && DOCKER_BUILDKIT=1 docker build --tag "test-ansible/ansible:local" --file ../tests/Dockerfile .
	touch "$@"

tmp/00-parameters.yml: inventory/00-parameters.yml \
		bin/ansible-no-secrets

	mkdir -p "$(dir $@)"
	bin/ansible-no-secrets "inventory/50-hosts.yml" "$@"
	touch "$@"

release: $(PUBLISH)/dev-config.json

	/usr/bin/jh-github-publish-pages "$(PUBLISH)" "push"

$(PUBLISH)/dev-config.json: tmp/dev-config.json
	mkdir -p "$(dir $@)"
	cp -f tmp/dev-config.json "$@"
	touch "$@"

ok:
	@echo "Ok: done"
