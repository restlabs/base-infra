# Github Actions Runner Controller

https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller

#### ACTIONS-RUNNER-CONTROLLER
oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

#### ACTIONS-SCALE-SET
oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set


#### Create a github app
https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api#deploying-using-personal-access-token-classic-authentication

Inject secret into kubernetes cluster
```commandline
kubectl create secret generic pre-defined-secret \
   --namespace=my_namespace \
   --from-literal=github_app_id=123456 \
   --from-literal=github_app_installation_id=654321 \
   --from-literal=github_app_private_key='-----BEGIN RSA PRIVATE KEY-----********'
```