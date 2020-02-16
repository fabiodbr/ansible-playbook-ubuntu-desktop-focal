.PHONY: help
.DEFAULT_GOAL := help
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

install: ansible-requirements ## Executa o playbook completo. Para especificar argumentos utilize Ex: make install -- --tags <TAG>
	@sudo -k
	@echo Instaling...
	@ansible-playbook main.yml -e 'ansible_python_interpreter=/usr/bin/python3' $(call args,)
	
ansible-requirements: ## Download ansible roles dependencies
	@echo Downloading requirements...
	ansible-galaxy install --role-file roles/requirements.yml --roles-path roles/ --force 

setup: ## Instala python3 e ansible
	@sudo apt install -y python3-pip
	@sudo pip3 install ansible

clean: ## Remove download das dependencias do ansible-galaxy
	rm -rf roles/ansible-role-visual-studio-code-extensions

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
