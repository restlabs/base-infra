## ArgoCD Deployment

helm repo add argo https://argoproj.github.io/argo-helm

helm install argocd --namespace hello-world argo/argo-cd \
    --set redis-ha.enabled=true \
    --set controller.replicas=1 \
    --set server.autoscaling.enabled=true \
    --set server.autoscaling.minReplicas=2 \
    --set repoServer.autoscaling.enabled=true \
    --set repoServer.autoscaling.minReplicas=2 \
    --set applicationSet.replicaCount=2 \
    --set server.service.type=LoadBalancer


NAME: argocd
LAST DEPLOYED: Thu Oct  5 23:01:22 2023
NAMESPACE: hello-world
STATUS: deployed
REVISION: 1
NOTES:
DEPRECATED option applicationSet.replicaCount - Use applicationSet.replicas

In order to access the server UI you have the following options:

1. kubectl port-forward service/argocd-server -n hello-world 8080:443

    and then open the browser on http://localhost:8080 and accept the certificate

2. enable ingress in the values file `server.ingress.enabled` and either
      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
      - Set the `configs.params."server.insecure"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts


After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:


