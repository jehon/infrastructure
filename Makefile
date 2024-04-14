#!/usr/bin/env make

.PHONY: pull-request
pull-request: clear clean version dump lint build test ok

# https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_7.html
# https://stackoverflow.com/a/26936855/1954789
# https://stackoverflow.com/a/39420097/1954789
# SHELL := /bin/bash
SHELL=/bin/bash -o pipefail -o errexit

# Locale per default
LANG=C.UTF-8

# .ONESHELL:
.SECONDEXPANSION:

ROOT = $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
TMP = tmp
ROOT_TMP = $(ROOT)/$(TMP)
GITHUB_STEP_SUMMARY ?= "$(ROOT_TMP)/GITHUB_STEP_SUMMARY.log"
PUBLISH = $(TMP)/publish

VERSION_FILE = $(PUBLISH)/version.txt

export PATH := $(ROOT)/bin:$(ROOT)/packages/jehon/usr/bin:$(PATH)

define mkdir
	@mkdir -p "$(dir $(1))"
endef

define touch
	$(call mkdir,$(1))
	@touch "$(1)"
endef

define copy
	$(call mkdir,$(1))
	@cp -fv "$(2)" "$(1)"
endef

# Identation is important:
define version
$(shell cat "$(VERSION_FILE)" || echo "1")
endef

DUMP_ALIGN=40
define dump_info
@if [ -n "$(2)" ]; then \
	printf "* %-$(DUMP_ALIGN)s %s\n" '$(1): ' '$(2)'; \
else \
	printf "* %-$(DUMP_ALIGN)s %s\n" '$(1): ' '$($(1))'; \
fi
endef

define dump_version
@printf "* %-$(DUMP_ALIGN)s %s\n" '$(shell type $(1)): ' '$(shell $(1) --version | head -n $(if $2,$2,1) | tail -n 1)'
endef

define dump_title
@printf "**************************** $(1) **************************\n"
endef

define dump_space
@printf "*\n"
endef

VERSION_LAST_GIT=$(shell git log -1 --format="%at" | xargs -I{} date --utc -d @{} "+%Y.%m.%d.%H.%M.%S" )
VERSION_CURRENT_TIME_TAG=$(shell date --utc "+%Y%m%d%H%M%S")
ifeq "$(shell git status --porcelain)" ""
	VERSION_RUN=$(VERSION_LAST_GIT)
else
	VERSION_RUN=$(VERSION_LAST_GIT).$(VERSION_CURRENT_TIME_TAG)
endif

# VERSION_LAST_EMAIL=$(git log -1 --pretty=format:'%ae')
VERSION_LAST_EMAIL=$($(GITHUB_REPOSITORY_OWNER)@users.noreply.github.com)
STARTUP_TIME:="$(shell date --utc "+%Y-%m-%d %H:%M:%S")"

#
#
# Generic targets
#
#
.PHONY: dump
dump:
	$(call dump_space)
	$(call dump_title,GLOBAL)
	$(call dump_info,PWD,$(shell pwd))
	$(call dump_info,ROOT)
	$(call dump_info,ROOT_TMP)
	$(call dump_info,REPO)
	$(call dump_info,VERSION)
	$(call dump_space)
	$(call dump_info,VERSION_LAST_GIT)
	$(call dump_info,VERSION_LAST_EMAIL)
	$(call dump_info,VERSION_CURRENT_TIME_TAG)
	$(call dump_info,VERSION_RUN)
	$(call dump_space)
	$(call dump_info,GITHUB_REPOSITORY_OWNER)
	$(call dump_info,GITHUB_ACTOR)
	$(call dump_info,GITHUB_STEP_SUMMARY)
	$(call dump_space)
	lsb_release -a || true

.PHONY: dump-runtimes
dump-runtimes:
	@true

.PHONY: clean
clean:
	rm -fr "$(TMP)"

.PHONY: build
build:
	@true

.PHONY: test
test:
	@true

.PHONY: lint
lint:
	@true

.PHONY: release
release:
	jh-html-generate-index "$(PUBLISH)"

	echo "Version: $(call version)" >> $(GITHUB_STEP_SUMMARY)

#
#
# Helpers
#
#
.PHONY: clear
clear:
	clear

.PHONY: ok
ok:
	@echo "Ok: done"

# target 'start' could not exists, since it is the name of a file

#
#
# Externals makefiles
#
#

include Makefile.python
include Makefile.node
include Makefile.scripts
include Makefile.packages

# Latest file must be in top folder
# for ROOT to be ok
include Makefile.infrastructure
include Makefile.devstack

#
#
# Global
#
#
global: global-clean global-build global-test

clean: global-clean
build: global-build
lint: global-lint
test: global-test

.PHONY: global-clean
global-clean:
	rm -f "$(VERSION_FILE)"

.PHONY: global-build
global-build: $(VERSION_FILE)

.PHONY: new-version
new-version:
	rm -f "$(VERSION_FILE)"
	make version

.PHONY: version
version: $(VERSION_FILE)
$(VERSION_FILE): \
		Makefile*

	@echo "#################################################"
	@echo "# Version: $(VERSION_RUN)"
	@echo "#################################################"
	$(call mkdir,$@)
	echo "$(VERSION_RUN)" > "$(VERSION_FILE)"

.PHONY: global-lint
global-lint: global-lint-prettier

.PHONY: global-lint-prettier
global-lint-prettier: $(NODE_DEPENDENCY_MARK)
	node_modules/.bin/prettier --list-different .

.PHONY: global-lint-prettier
global-lint-prettier-fix: $(NODE_DEPENDENCY_MARK)
	node_modules/.bin/prettier --write .

.PHONY: global-test
global-test:
	@true

clean-force: clean
# Thanks to https://stackoverflow.com/a/46273201/1954789
	git clean -dfX

