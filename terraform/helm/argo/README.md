## ArgoCD Deployment
The helm repo utilized in this project is https://argoproj.github.io/argo-helm

helm artifacthub: https://artifacthub.io/packages/helm/argo/argo-cd

### Terraform deployment with make
To automatically install go to the base-infra root directory and run `make deploy-argo` command.

### Manual deployment with helm
You will need the following commands installed
- helm
- kubectl


Adding helm repo:
```commandline
helm repo add argo https://argoproj.github.io/argo-helm
```


Installing argo chart:
```commandline
helm install argocd --namespace hello-world argo/argo-cd \
    --set redis-ha.enabled=true \
    --set controller.replicas=1 \
    --set server.autoscaling.enabled=true \
    --set server.autoscaling.minReplicas=2 \
    --set repoServer.autoscaling.enabled=true \
    --set repoServer.autoscaling.minReplicas=2 \
    --set applicationSet.replicaCount=2 \
    --set server.service.type=LoadBalancer # do not include this if you do not want your argo server to be publicly accessible through the internet
```


### Retrieving initial admin password
```commandline
kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```


