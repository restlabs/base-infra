# Example Microservice
https://gitlab.com/twn-youtube/consul-crash-course/-/tree/main/kubernetes?ref_type=heads

based on:
https://github.com/GoogleCloudPlatform/microservices-demo

### Prerequisites:
- Kubernetes cluster

### Deploy Example Microservice
```commandline
kubectl apply -f config.yaml
```

### Deploy Consul
Reference: https://developer.hashicorp.com/consul/docs/k8s/installation/install

```commandline
helm repo add hashicorp https://helm.releases.hashicorp.com
```
```commandline
helm install consul hashicorp/consul \
    --set global.name=eks-consul \
    --set global.datacenter=eks \
    --create-namespace --namespace default \
    --values kubernetes/manifests/example-microservice-for-consul-testing/consul-values.yaml
```

### Errors to investigate

1.
```commandline
failed to provision volume with StorageClass "gp2": rpc error: code = Internal desc = Could not create volume "pvc-2c8d9b0d-4a27-41be-864e-908f758e22da": could not create volume in EC2: NoCredentialProviders: no valid providers in chain caused by: EnvAccessKeyNotFound: failed to find credentials in the environment. SharedCredsLoad: failed to load profile, . EC2RoleRequestError: no EC2 instance role found caused by: RequestError: send request failed caused by: Get "http://169.254.169.254/latest/meta-data/iam/security-credentials/": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
```

2.
```commandline
Startup probe failed: Get "http://10.0.18.220:9445/readyz/ready": dial tcp 10.0.18.220:9445: connect: connection refused
```