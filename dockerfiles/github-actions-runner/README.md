# Github Actions Runner

use the latest version from the link
https://github.com/actions/runner/pkgs/container/actions-runner

this image is pushed to ECR

#### Log into ECR
```commandline
aws ecr-public get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin <ECR_URL>
```