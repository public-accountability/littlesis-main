# Running LittleSis in production

## Setting up your own computer

You'll need ansible installed and an SSH key.

* To install ansible [see this guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). 

* Create an ssh key to use just for LittleSis's deployment ```  ssh-keygen -t ed25519 ``` located at ` ~/.ssh/id_littlesis `

You are welcome to use an ssh key located elsewhere, but the default ansible variables assumes that location.

## Create 4 debian buster servers

Currently at LittleSis.org, we use 2-4CPUs and 4-8GB RAM for the app and database servers. The wordpress and recpliant servers can be smaller.


## Create an ansible inventory file in ansible/hosts.yml

Example:

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

Note that after the initial run, the host variable `ansible_user` should be changed from _root_ to _maintainer_.
