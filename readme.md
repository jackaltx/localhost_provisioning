# Overview

This is for local Debian 12 linux machine provisioning.  

# Usage

I am provisioning VM and metal Debian 12 machines for my lab. Usually I need to spin up a new system to test and idea. 
Experiment on an existing system can end up with either instability or loss of what was done.  Setting up a baseline with
a clean system is time consumin.  To get around that I use a provisioning tool to set an environment. I used to use puppet for this task.
However the overhead of installing ruby as well as the other required packages was too heavy.  Ansible came along and it works.  
I don't think as well as puppet, but it is fairly light weight.  I have to install ansible and prepare the user for sudo, then I am off.

This is a small collection of ansible scripts designed to bring up a usable platorm.  First I install ansible. Then I either install enough to check out this repo from github or mount and nfs directory, or use a flash drive.

Tnen I use the first playbook to bring the platform into the fold.  From the base of the directory.

``` 
sudo ansible-playbook first.yml
```

From there I add what I need.  In the end, I remove the directory.   It's not elegant like using a provisioning service, but it fits my ever changing needs.

I did not do a good job of setting the "become" flag.  I run these as root (or sudo) as required. 

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
##  Podman

This is a pretty basic install.  Trouble is, it mostly works till you try to do "systemd" stuff. It does not clean up reliably.  Artifacts get left.  This area is subject to immanent change.

I am not running as root, so here are some important directories to watch.

## Volumes

Here is the where rootles storage is set

```
$ podman volume create mytestvol
mytestvol
lavender@Ryan9:~/.local$ podman volume inspect mytestvol
[
     {
          "Name": "mytestvol",
          "Driver": "local",
          "Mountpoint": "/home/lavender/.local/share/containers/storage/volumes/mytestvol/_data",
          "CreatedAt": "2024-10-17T18:55:13.429437988-05:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "NeedsChown": true
     }
]
$ tree /home/lavender/.local/share/containers/storage/volumes/
/home/lavender/.local/share/containers/storage/volumes/
└── mytestvol
    └── _data
```

## Containers

```
$ podman run hello-world
Resolved "hello-world" as an alias (/etc/containers/registries.conf.d/shortnames.conf)
Trying to pull docker.io/library/hello-world:latest...

$ podman container ls -a
CONTAINER ID  IMAGE                                 COMMAND     CREATED        STATUS                    PORTS       NAMES
d345a2aab3b0  docker.io/library/hello-world:latest  /hello      4 minutes ago  Exited (0) 4 minutes ago              priceless_ptolemy

$ podman image ls -a
REPOSITORY                     TAG         IMAGE ID      CREATED        SIZE
docker.io/library/hello-world  latest      d2c94e258dcb  17 months ago  28.5 kB

$ tree -L 4 -d ~/.local/share/containers/storage/overlay
/home/lavender/.local/share/containers/storage/overlay
├── 291fea65c5af058d561efbe7e985b2c1f80f2bc37b9d671b38c337780536f3ff
│   ├── diff
│   │   ├── dev
│   │   ├── etc
│   │   ├── proc
│   │   ├── run
│   │   └── sys
│   └── work
│       └── work  [error opening dir]
├── ac28800ec8bb38d5c35b49d45a6ac4777544941199075dff8c4eb63e093aa81e
│   ├── diff
│   ├── empty
│   ├── merged
│   └── work
└── l
    ├── 4HM7AP6PRG5GWM4C5QBQAMFNKB -> ../ac28800ec8bb38d5c35b49d45a6ac4777544941199075dff8c4eb63e093aa81e/diff
    └── 6ZIUKWDQQMMXLFK4X7YHXJYJKJ -> ../291fea65c5af058d561efbe7e985b2c1f80f2bc37b9d671b38c337780536f3ff/diff

$ podman container inspect priceless_ptolemy | grep '291f'
                    "UpperDir": "/home/lavender/.local/share/containers/storage/overlay/291fea65c5af058d561efbe7e985b2c1f80f2bc37b9d671b38c337780536f3ff/diff",
                    "WorkDir": "/home/lavender/.local/share/containers/storage/overlay/291fea65c5af058d561efbe7e985b2c1f80f2bc37b9d671b38c337780536f3ff/work"

```
## run root

```
$ tree -L 4 -d /run/user/1000/
/run/user/1000/
├── at-spi
├── containers
│   ├── networks
│   ├── overlay
│   ├── overlay-containers
│   │   └── d345a2aab3b06c5c310c2c0059f7cd5fcdacbfc6ea381c5c316d5e8e6fb27126
│   │       └── userdata
│   ├── overlay-layers
│   ├── overlay-locks
│   ├── vfs-containers
│   │   └── 7afcfdf6ecb50a107ba66a9f464d0d57f0aa16fcc782761168630f43ca55bcfc
│   │       └── userdata
│   ├── vfs-layers
│   └── vfs-locks
├── crun
├── dbus-1
│   └── services
├── dconf
├── doc
│   └── by-app
├── gcr
├── gnupg
├── gvfs
├── gvfsd
├── keyring
├── libpod
│   └── tmp
│       └── exits
├── netns
├── podman
├── pulse
├── speech-dispatcher
│   ├── log
│   │   └── debug
│   └── pid
└── systemd
    ├── generator.late
    │   └── xdg-desktop-autostart.target.wants
    ├── inaccessible
    │   └── dir  [error opening dir]
    ├── transient
    └── units

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
- fail2ban
- ossec
- ...
