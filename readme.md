# Overview

This is for local Debian 12 linus machine provisioning.  

# Usage

I am provisioning VM and metal Debian 12 machines for my lab.  
The first one is alway the trickiest to setup.  This is a small collection of ansible scripts 
designed to bring up a usable platorm.  First I install ansible and git, then I check this out as a sudo user.
Tnen I use the first playbook to bring the platform into the fold.  From the base of the directory.

``` 
sudo ansible-playbook first.yml
```

From there I add what I need.  In the end, I remove the directory.   It's not as elegant as using a provisioing service, but it fits my often changing needs.

# Concept notes

##  Ansible inventory

I have chosen a yml structure so I effectively use variables for specific configurations.  For example,  first I need to create an influxd server to generate the access tokens for the telegraf clients.  A handy command to know is:

```
ansible-inventory -i inventory --list
{
    "_meta": {
        "hostvars": {
            "localhost": {
                "influx_level": "error",
                "telegraf_influx_token": "br549==",
                "telegraf_influx_url": "monitor.mydomain.com"
            }
        }
    },
    "all": {
        "children": [
            "ungrouped",
            "mylab"
        ]
    },
    "mylab": {
        "hosts": [
            "localhost"
        ]
    }
}
```

The only host being worked on is localhost, which is a assigned to a "mylab" group.  Ansible [variable precidence](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) is a bit complicated and confounds me.  


##  Ansible secrets

This area is the next work direction.  I need to distribute sensitive settings in a "free" way, as we all know:  it costs to keep secrets secret.


#  Future

The roles in "Provision Collection" will be reusable in later projects. 
