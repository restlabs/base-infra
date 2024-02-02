# EKS Cluster
This will deploy an EKS cluster based on:
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

You will need to deploy the base-infra vpc (terraform/vpc/base) before you can use this cluster.

### Deploying this cluster
You can run the `make` command in the Base Infra root directory
```commandline
make deploy-eks
```

Alternatively you can run the `base-deploy` command.
```commandline
base-deploy --target "eks/base"
```

### Connect kubectl to your EKS cluster
To connect kubectl to your newly created EKS cluster you will need to update the kube config file.
```commandline
aws eks \                                               
    --region <AWS_REGION> \
    update-kubeconfig \
    --name <EKS_CLUSTER_NAME>
```

### Azure AD integration
Azure AD integration is enabled to allow users to authenticate to the cluster using their Azure AD credentials.
https://aws.amazon.com/pt/blogs/containers/using-azure-active-directory-to-authenticate-to-amazon-eks/

### Karpenter
Added karpenter as the cluster autoscaler

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