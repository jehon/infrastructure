#!/usr/bin/env make

#
#
# Depends on: 
#     ansible/*
#
# Generate:
#     x
#
full: clear clean dependencies dump lint build ok

dev: clear dump lint build ok

ABS_ROOT=$(shell pwd)

TMP=tmp
PUBLISH=$(TMP)/publish
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

ok:
	@echo "Ok: done"

clean:
	rm -f "$(PUBLISH)/dev-config.json"
	rm -fr built
	rm -fr tmp
	rm -fr tests/built
	rm -fr .python
	docker ps | ( grep test-ansible || true ) | awk '{print $$1}' | xargs --no-run-if-empty -- docker kill
	docker image list --filter 'reference=test-ansible/*' --format '{{.Repository}}:{{.Tag}}' | xargs --no-run-if-empty -- docker image rm -f
	docker volume list --quiet | ( grep 'test-ansible' || true ) | xargs --no-run-if-empty -- docker rm -f 

dump:
	@echo "ABS_ROOT:          $(ABS_ROOT)"
	@echo "TMP:               $(TMP)"
	@echo "ENCRYPTION_MOCK:   $(ENCRYPTION_MOCK)"
	@echo "PUBLISH:           $(PUBLISH)"
	@echo ""
	@echo "PATH:              $(PATH)"
	@echo "PYTHONPATH:        $(PYTHONPATH)"

dump-runtimes: dependencies
	@type ansible | grep "$(ABS_ROOT)/"
	@ansible --version

	@type ansible-lint | grep "$(ABS_ROOT)/"
	@ansible-lint --version

	@type ansible-playbook | grep "$(ABS_ROOT)/"
	@ansible-playbook --version

dependencies: .python/.built \
	built/encryption-key \
	built/ssh-key

.python/.built:
# pytest: lint
	pip install --upgrade --target "$(ABS_ROOT)"/.python -r requirements.txt
	touch "$@"

built/encryption-key:
	mkdir -p "$(dir $@)"
	if [ ! -r "$@" ]; then \
		if [ -r /etc/jehon/restricted/encryption-key ]; then \
			ln -fs /etc/jehon/restricted/encryption-key "built/encryption-key"; \
		else \
			echo "12345" > built/encryption-key; \
		fi \
	fi

built/ssh-key:
	mkdir -p "$(dir $@)"
	if [ ! -r "$@" ]; then \
		if [ -r /etc/jehon/restricted/ssh-key ]; then \
			ln -fs /etc/jehon/restricted/ssh-key built/ssh-key; \
		else \
			if [ -r $(HOME)/.ssh/id_rsa ]; then \
				ln -fs $(HOME)/.ssh/id_rsa built/ssh-key; \
			fi \
		fi \
	fi


lint: dependencies
	ansible-lint
	@echo "$@ ok"

build: dependencies \
	$(TMP)/.built \
	$(TMP)/dev-config.json

$(TMP)/.built: .python/.built
	mkdir -p "$(dir $@)"
	touch "$@"

$(TMP)/dev-config.json: $(TMP)/.built
	mkdir -p "$(dir $@)"
	ansible-playbook --vault-password-file $(ABS_ROOT)/$(ENCRYPTION_MOCK) build-artifacts.yml
	touch "$@"

test: tests/built/.docker
	run-parts --exit-on-error --verbose --regex "^[0-9][0-9]-.*" ./tests/

tests/built/.docker: \
		tests/built/setup.sh

	mkdir -p "$(dir $@)"
	cd tests && DOCKER_BUILDKIT=1 docker build --tag "test-ansible/ansible:local" .
	touch "$@"

tests/built/setup.sh: .devcontainer/setup.sh
	mkdir -p "$(dir $@)"
	cp -f "$<" "$@"
	touch "$@"

$(TMP)/00-parameters.yml: inventory/00-parameters.yml \
		bin/ansible-no-secrets

	mkdir -p "$(dir $@)"
	bin/ansible-no-secrets "inventory/00-parameters.yml" "$@"
	touch "$@"

release: $(PUBLISH)/dev-config.json
	/usr/bin/jh-github-publish-pages "$(PUBLISH)" "push"

$(PUBLISH)/dev-config.json: $(TMP)/dev-config.json
	mkdir -p "$(dir $@)"
	cp -f $(TMP)/dev-config.json "$@"
	touch "$@"
