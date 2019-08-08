export ANSIBLE_VAULT_PASSWORD_FILE = /tmp/littlesis_vault_pass
# export ANSIBLE_ASK_VAULT_PASS = TRUE
export ANSIBLE_INVENTORY = ./inventory.yml

VARS_FILE = ./vars.yml

default:
	@echo 'LittleSis ansible shortcuts'

inventory:
	@ansible-inventory --graph --vars

inventory-edit:
	@ansible-vault edit $(ANSIBLE_INVENTORY)

vars-edit:
	@ansible-vault edit $(VARS_FILE)

app:
	@ansible-playbook littlesis.yml --verbose


.PHONY: inventory inventory-edit vars-edit
.PHONY: app
