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

I need to distribute sensitive settings in a "free" way, as we all know:  *it costs to keep secrets secret*.
In that endeavor I am using a couple of tricks to keep unencrypted secrets out of this repository.

First trick:   ansible will take an executable file for the password.  So I created  a program in the file .vault-pass

```
#!/usr/bin/env python3
import os
print(os.environ['PROVISION_VAULT_PASSWORD'])
```

This returns environment variable *PROVISION_VAULT_PASSWORD*. for now I am setting it in my.bashrc file.
Which is ok for now. 

The second trick is to use the ansible.cfg file to set the default password file. Like so:

```
# If set, configures the path to the Vault password file as an alternative to
# specifying --vault-password-file on the command line.
#vault_password_file = /path/to/vault_password_file
vault_password_file = ./.vault-pass
```

So only the following line needs to be in my .bashrc file"

> export PROVISION_VAULT_PASSWORD= yourProjectassword

I use the inventory file to set the variables I need

```
    promtail_loki_url: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66323533376364663634653733316364326137616130663039616330343830393836626466333930
          3134336564316639623363313735633930356537356331360a313138623665353266646266363564
          35663965323433636263343031373934376235613161333661656637316438653034653861383864
          3531306331616264310a396566613761326165633763653934363434633163303863316135303839
          39383132373865396266343766336439616539623532373363346535393661636638
```

To make that string

```
$ ansible-vault encrypt_string "http://xxx.yyy.zzz:3100" --name 'promtail_loki_url'

Encryption successful
promtail_loki_url: !vault |
          $ANSIBLE_VAULT;1.1;AES256      
          66323533376364663634653733316364326137616130663039616330343830393836626466333930
          3134336564316639623363313735633930356537356331360a313138623665353266646266363564
          35663965323433636263343031373934376235613161333661656637316438653034653861383864
          3531306331616264310a396566613761326165633763653934363434633163303863316135303839
          39383132373865396266343766336439616539623532373363346535393661636638
```

#  Future

The roles in "Provision Collection" will be reusable in later projects. 

## In work list

Environment installations:

- Podman and Container setup
- MiniKube
- nfs
- Support scripts (./bin)
- Grafana
- Openstack or Ghost
- failban
- ossec
- ...