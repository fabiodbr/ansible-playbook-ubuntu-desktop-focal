.DEFAULT_GOAL := help
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
SHELL := /bin/bash
MAIN_PLAYBOOK_FILE := playbook.yml
REQUIRED_BINS := ansible ansible-galaxy python3 pip3 # required binaries to run this makefile
LOCAL_DEV_ROLES := $(sort $(dir $(wildcard .././ansible-role*/))) # local development roles used in this playbook

.PHONY: install
install: download-dependencies run ## Install playbook.

.PHONY: download-dependencies
download-dependencies: check-requirements
	@echo "Downloading roles..."
	@ansible-galaxy install --role-file roles/requirements.yml --roles-path roles/ --force

.PHONY: run
run: check-requirements
	@sudo -v
	ansible-playbook $(MAIN_PLAYBOOK_FILE) -e 'ansible_python_interpreter=/usr/bin/python3'

.PHONY: check-requirements
check-requirements:
	$(foreach bin,$(REQUIRED_BINS),\
		$(if $(shell command -v $(bin) 2> /dev/null),$(info Found '$(bin)'),$(error Please run: make requirements `$(bin)`)))

.PHONY: requirements
requirements: ## Install system requirements.
	@sudo apt install -y python3 python3-pip
	@sudo pip3 install ansible

.PHONY: dev
dev: download-dependencies
	# Delete downloaded roles in development
	$(foreach local_role, $(LOCAL_DEV_ROLES), rm -rf ./roles/$(shell basename $(local_role));)
	# Copy local development roles
	$(foreach dev_role, $(LOCAL_DEV_ROLES), rsync -avR --quiet --no-implied-dirs $(dev_role) ./roles/ --exclude .git;)
	# Lint check
	$(MAKE) lint
	# Run playbook
	$(MAKE) run

.PHONY: clean
clean:
	# Delete all roles
	rm -rf roles/*/

.PHONY: lint
lint:
	@ansible-lint . || (echo "Lint failed!" && exit 1)

.PHONY: hi
hi:
	@echo $(call args,)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
