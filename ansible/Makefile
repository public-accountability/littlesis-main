export ANSIBLE_VAULT_PASSWORD_FILE = /tmp/littlesis_vault_pass
# export ANSIBLE_ASK_VAULT_PASS = TRUE
export ANSIBLE_INVENTORY = ./inventory.yml

VARS_FILE = ./vars.yml

inventory:
	@ansible-inventory --graph

inventory-edit:
	@ansible-vault edit $(ANSIBLE_INVENTORY)

vars-edit:
	@ansible-vault edit $(VARS_FILE)

run:
	@ansible-playbook littlesis.yml

app:
	@ansible-playbook littlesis.yml --tags=app

database:
	@ansible-playbook littlesis.yml --tags=database

ping:
	@ansible all -m ping

.PHONY: inventory inventory-edit vars-edit
.PHONY: run app database ping
