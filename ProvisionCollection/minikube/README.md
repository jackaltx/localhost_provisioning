Role Name
=========

[Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)  is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

I like to have [kubectl](https://kubernetes.io/docs/reference/kubectl/) available.  You can use "minikube kubectl --" to get the same effect, but no.  However, I put a flag to make it your choice.


Requirements
------------

What you’ll need:

- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager, such as: Docker, QEMU, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMware FusionWorkstation

Role Variables
--------------

By default this role installs. There are the state variable is 'present' or 'absent'.  See the playbook for how to use.


```
minikube_state: present
minikube_install_kubectl: true
```


Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- name: MiniKube Removal
  hosts: localhost
  connection: local

  vars:
    minikube_state: absent

  roles:
    - minikube
```

License
-------

MIT

Author Information
------------------

Jack Lavender, et al.