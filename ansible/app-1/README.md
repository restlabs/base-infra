# Ansible Tutorial

#### Check hosts
Add public key on the 3 servers
```commandline
ansible test \
    -u <USER> \
    -m ping
```

```commandline
 ansible test \
    -u <USER> \
    -m gather_facts
```

```commandline
 ansible test \
    -u <USER> \
    -m apt \
    -a update_cache=true \
    --become \
    --ask-become-pass
```

```commandline
 ansible-playbook \
    --ask-become-pass \
    -u <USER> \
    playbook/install_apache.yml
```