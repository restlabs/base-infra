# Argo Example App

This will create an application within argo that will automatically be deployed when this [repo](https://github.com/pafable/kubernetes-apps.git) is updated.

### Deploying with make
Go to the project's root and execute the following command

```commandline
make deploy-argo-example
```

### Manual deploy with kubectl

```commandline
kubectl apply --filename kubernetes/manifests/argo-example-app
```