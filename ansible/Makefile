ANSIBLE_INVENTORY = ./inventory.yml
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
	@ansible-playbook app.yml --limit=app --tags=scripts

database:
	@ansible-playbook database.yml --limit=database

replicant:
	@ansible-playbook replicant.yml --limit=replicant

wordpress:
	@ansible-playbook wordpress.yml --limit=wordpress

ansible-galaxy-roles:
	ansible-galaxy install geerlingguy.nodejs dev-sec.ssh-hardening dev-sec.os-hardening geerlingguy.docker geerlingguy.composer

ping:
	@ansible all -m ping

.PHONY: inventory inventory-edit vars-edit run app database replicant wordpress
.PHONY: ansible-galaxy-roles ping
