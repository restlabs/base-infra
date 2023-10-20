# Nexus Repository

Retrieves initial admin password
```commandline
kubectl exec -it \
    <NEXUS-SERVER-POD> \
    -- bash -c "cat /nexus-data/admin.password" 
```