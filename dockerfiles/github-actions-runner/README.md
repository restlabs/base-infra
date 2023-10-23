# Github Actions Runner

use the latest version from the link
https://github.com/actions/runner/pkgs/container/actions-runner

this image is pushed to ECR

#### Log into ECR
```commandline
aws ecr-public get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin <ECR_URL>
```

### Pushing Image to Nexus
```commandline
docker tag <imageId or imageName> \
    <nexus-hostname>:<repository-port>/<image>:<tag>
    
docker tag af340544ed62 \
    nexus.example.com:18444/hello-world:mytag
```