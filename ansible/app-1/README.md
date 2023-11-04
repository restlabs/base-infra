# Ansible Tutorial

#### Set ansible.cfg
```commandline
export ANSIBLE_CONFIG=ansible.cfg
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

alternatively you can pass in the password using `-e`
```commandline
ansible-playbook \
    -u <USER> \
    playbooks/uninstall_apache.yml \
    --extra-vars "ansible_sudo_pass=<YOUR_SUDO_PASSWORD>"
```