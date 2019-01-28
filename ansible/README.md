## LittleSis Ansible Playbooks

While we use Docker for development, in production we use ansible manage our servers.

The playbooks use a yaml file, *littlesis.yml*, to store all the secret variables, which ~can be~ should be encrypted with ansible vault.


### site.yml

This is our main playbook that hosts the rails app. Currently, uses Ubuntu 16.

### development.yml

This setups a development server -- useful to work on LittleSis in the cloud

### wordpress.yml

A server running our wordpress sites. Currently uses Ubuntu 18.


## Using Extra Vars

Some tasks won't be run by default unless variables are changed from false to true. Example:

``` shell
ansible-playbook wordpress.yml --tags=install -e 'install_wordpress=true'
```
