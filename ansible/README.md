# Running LittleSis in production

This document contains instructions for setting up servers to run LittleSis .

## History

Until 2019 LittleSis ran on Amazon Web Services until it was moved to Digital Ocean. Although the document contains some Digital Ocean specific instructions, the ansible playbooks themselves do not contain any hosting-provider specific features. It wouldn't be too hard to tweak these instructions to run on other hosting providers.

## Architecture

LittleSis runs on 4 servers with the Debian operating system.

*app*  Runs the LittleSis rails app.

*database* is a mariadb database server. Both the rails app and the wordpress use this database.

*replicant* is a replication of the database, primarily used as a backup.

*wordpress* runs our two wordpress sites.

## Developer computer setup
### Requirements and SSH key creation

You'll need ansible installed and an SSH key.

* To install ansible [see this guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

* Create an ssh key to that will be used for LittleSis's deployment ```  ssh-keygen -t ed25519 ``` located at ` ~/.ssh/id_littlesis `

You are welcome to use an ssh key located elsewhere, but the default ansible variables assumes that location. It is important to keep this file safe and backed-up because it is your password to the server.

There is a Makefile in this folder with helpful shortcuts.

### Ansible vault

Ansible vault is used to store variable secrets -- passwords, api keys, etc. Only two files, inventory.yml and vars.yml, are stored using ansible-vault.

Edit these files with ` make inventory-edit ` and ` make vars-edit `.

## Setup new production servers
### Create 4 debian buster servers

Currently LittleSis.org uses 2-4CPUs and 4-8GB RAM servers for the app, database, and replicant servers. The wordpress server can be smaller. For simplicity's sake, the replicant server is kept as the same size of the main database server, which could probably be smaller given that it's main function to operate as a backup and it mostly sits idle.

Example inventory:

``` yaml
littlesis:
  children:
    app:
      hosts:
        x.x.x.x:
    database:
      hosts:
        x.x.x.x:
    wordpress:
      hosts:
        x.x.x.x:
    replicant:
      hosts:
        x.x.px.x:
  vars:
    ansible_python_interpreter: /usr/bin/python3
    ansible_ssh_common_args: '-o IdentitiesOnly=yes'
    ansible_user: root
    ansible_private_key_file: ~/.ssh/id_littlesis
```

**After the initial run, the host variable `ansible_user` should be changed from _root_ to _maintainer_.**

You can update the ansible inventory via ` make inventory-edit `

### Update the vars

Run ` make vars-edit `. You'll need to change the `internal_ip` variables to correspond to the private networking IP from digital ocean. If setting up the app for development, you'll likely also want to change the server_name and TLS certs.

### Run the playbook

` ansible-playbook littlesis.yml ` or ` make run `


### Load production database and setup replication

See [Database setup](../guide/database_setup.md) for more instructions on transfering the production database and setting up replication.

## Ansible tasks and tips

Depending how you configured ansible, you'll likely have to add these two flags when running `ansible-playbook`

``` sh
ansible-playbook --ask-become-pass --ask-vault-pass
```

### Configuration Update

It's common to have to update our webserver configuration.

**Update nginx configuration:**


``` sh
ansible-playbook littlesis.yml --limit=app --tags=nginx-config
```

**Update rails configuration**


``` sh
ansible-playbook littlesis.yml --limit=app --tags=rails-config
```


**Add new maintainer ssh key**

Add the new ssh public key to the list stored in variable `maintainer_authorized_keys` :

``` sh
make vars-edit
```

Then run:

``` sh
ansible-playbook littlesis.yml --tags=user
```
