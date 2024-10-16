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

#  Future

The roles in "Provision Collection" will be reusable. 
