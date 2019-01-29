## LittleSis Ansible Playbooks

While we use Docker for development, in production we use ansible manage our servers.

The playbooks use a yaml file, *littlesis.yml*, to store all the secret variables, which ~can be~ should be encrypted with ansible vault.

All our servers are currently using Ubuntu 18.04.

### site.yml

This is our main playbook that hosts the rails app.

### wordpress.yml

A server running our wordpress sites.

### development.yml

This setups a development server -- useful to work on LittleSis in the cloud.


## Using Extra Vars

Some tasks won't be run by default unless variables are changed from false to true. Example:

``` shell
ansible-playbook wordpress.yml --tags=install -e 'install_wordpress=true'
```

## ansible tags useful to manage running production server

### Add or update a new helper script 

In `roles/littlesis/templates/scripts` are scripts used to monitor our server and to perform some common tasks.

After changing a script or adding an new one:

``` shell
ansible-playbook site.yml --tags=scripts
```

### Change the ruby version

In `group_vars/all` there is a variable that sets the server ruby version.

To change the ruby version all you all to do is change the variable

``` yaml
ruby_version: 'ruby-2.5.3'
```

and run:

``` shell
ansible-playbook site.yml --tags "ruby,gems,passenger"
```

### Update lilsis.yml rails configuration

After changing the variables in ` littlesis.yml ` run:


``` shell
ansible-playbook site.yml --tags=config
```
