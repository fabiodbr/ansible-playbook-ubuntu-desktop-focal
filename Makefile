.DEFAULT_GOAL := help
SHELL := /bin/bash
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
REQUIRED_BINS = ansible ansible-galaxy python3 pip3

ANSIBLE_PLAYBOOK_FILE = playbook.yml

.PHONY: install
install: dependencies ## Run the playbook.
	# To input ansible-playbook arguments run: make install -- <args>
	@sudo -v
	@ansible-playbook $(ANSIBLE_PLAYBOOK_FILE) -e 'ansible_python_interpreter=/usr/bin/python3' $(call args,)

.PHONY: dependencies
dependencies: ## Download ansible roles dependencies.
	$(foreach bin,$(REQUIRED_BINS),\
		$(if $(shell command -v $(bin) 2> /dev/null),$(info Found '$(bin)'),$(error Please install `$(bin)`)))
	@echo "* Downloading ansible roles dependencies..."
	@ansible-galaxy install --role-file roles/requirements.yml --roles-path roles/ --force

.PHONY: requirements
requirements: ## Install requirements: python3, pip3, ansible.
	@sudo apt install -y python3 python3-pip
	@sudo pip3 install ansible

.PHONY: clean
clean: ## Remove ansible-role dependencies.
	rm -rf roles/*/

.PHONY: test
test: dependencies
	@ansible-lint . || (echo "Test failed!" && exit 1)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
