# Consul

### Deploy using makefile
```commandline
make deploy-consul
```

### Consul Testing
Note Consul is installed by default by Terraform.
Steps below is for manual deployment of Consul and Example Microservice for testing.
1. Example Microservice
   https://gitlab.com/twn-youtube/consul-crash-course/-/tree/main/kubernetes?ref_type=heads

based on:
https://github.com/GoogleCloudPlatform/microservices-demo

2. Deploy Example Microservice
```commandline
kubectl apply -f config.yaml
```

3. Deploy Consul
   Reference: https://developer.hashicorp.com/consul/docs/k8s/installation/install

```commandline
helm repo add hashicorp https://helm.releases.hashicorp.com
```
```commandline
helm install consul hashicorp/consul \
    --version 1.0.0 \  
    --set global.name=eks-consul \
    --set global.datacenter=eks \
    --create-namespace --namespace consul \
    --values kubernetes/manifests/example-microservice-for-consul-testing/consul-values.yaml
```

4. Delete Consul helm release
```commandline
helm delete consul -n consul
```