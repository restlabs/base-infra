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