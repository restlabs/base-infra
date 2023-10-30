# Ansible Tutorial

#### Set ansible.cfg
```commandline
export ANSBILE_CONFG=ansible.cfg
```

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
    playbook/<PLAYBOOK>
```

alternatively you can pass in the password using `-E`
```commandline
ansible-playbook \
    -u scleft \
    playbooks/uninstall_apache.yml \
    -e "ansible_become_pass=<YOUR_SUDO_PASSWORD>"
```