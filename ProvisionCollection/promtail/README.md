Role Name
=========

See [to read telegraf details](https://www.influxdata.com/time-series-platform/telegraf/)

>Telegraf collects and sends time series data from databases, systems, and IoT sensors. It has no external dependencies, is easy to install, and requires minimal hardware resources.

This is influxdb's collector.  I prefer it to Prometheus for most applications. Prometheus is a pull-based system as it collects data by pulling metrics from targets. Telegraf is an agent that supports both pull and push mechanisms.  I think prometheus is very versatile and straight forward.  But I prefer the features of Influxdb.

This installs a systemd daemon. It can be cleaned up, but that is not very well tested or kept up.

Requirements
------------

Handled by package install.

Role Variables
--------------

By default this role installs. There are the state variable is 'present' or 'absent'.  See the playbook for how to use.

There are two varables used to communicate with the server.  Look at the inventory.yml for my configuration.

```
promtail_loki_url:  http://127.0.0.1:3100
promtail_state: present
```


Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

 ```
- name: Podman Installation
  hosts: localhost
  connection: local

  vars:
    promtail_state: absent

  roles:
    - promtail
 ```

License
-------

MIT

Author Information
------------------

Jack Lavender, et al.