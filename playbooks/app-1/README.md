# Ansible Tutorial

#### Check hosts
Add public key on the 3 servers
```commandline
ansible test -u <USER> -m ping
```

```commandline
 ansible test -u <USER> -m gather_facts
```