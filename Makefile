.DEFAULT_GOAL := help
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
ANSIBLE_PLAYBOOK_FILE=playbook.yml

.PHONY: install
install: ansible-roles ## Run playbook.
	# Install. (optional arguments: make install -- <args>)
	@sudo -v
	@echo "* Instaling..."
	@ansible-playbook $(ANSIBLE_PLAYBOOK_FILE) -e 'ansible_python_interpreter=/usr/bin/python3' $(call args,)

.PHONY: ansible-roles
ansible-roles: ## Download ansible roles dependencies.
	@echo "* Downloading requirements..."
	@ansible-galaxy install --role-file roles/requirements.yml --roles-path roles/ --force 

.PHONY: requirements
requirements: ## Install requirements: python3, pip3, ansible.
	@sudo apt install -y python3 python3-pip
	@sudo pip3 install ansible

clean: ## Remove ansible-role dependencies.
	rm -rf roles/ansible-role-visual-studio-code-extensions

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
