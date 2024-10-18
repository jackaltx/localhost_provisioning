Role Name
=========

See [https://docs.podman.io/en/latest/](to read podman details)

> Podman is a daemonless, open source, Linux native tool designed to make it easy to find, run, build, share and deploy applications using Open Containers Initiative (OCI) Containers and Container Images.

Currently, this is used it setup a nice rootless "runtime". My goal is to see if I can run systemd rootless.  This should me a lighter weight footprint for daemon containers.  My first test with influxdb have been all over the place.    

Requirements
------------

Handled by package install.

Role Variables
--------------

By default this role installs. There are the state variable is 'present' or 'absent'.  See the playbook for how to use.

```
  podman_state: present
```


Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

 ```
- name: Podman Removal
  hosts: localhost
  connection: local

  vars:
    podman_state: absent

  roles:
    - podman

 ```

License
-------

MIT

Author Information
------------------

Jack Lavender, et al.