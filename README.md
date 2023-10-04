# Base Infra
[![Deploy Base Infra](https://github.com/pafable/base-infra/actions/workflows/deploy.yml/badge.svg)](https://github.com/pafable/base-infra/actions/workflows/deploy.yml)

[![CI Tests](https://github.com/pafable/base-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/pafable/base-infra/actions/workflows/ci.yml)

Deploys base infrastructure to AWS. 
This project uses a python script (base_infra_deployer.py) in the deployer folder to deploy infrastructure in the terraform folder.

When adding more terraform resources into the project, create a folder for your project in the terraform folder. 
When you're ready to deploy your project build and install the base-infra-deployer code, it will create a CLI command called `base-deploy`.

__TESTED ON__: MacOS and Linux
### Requirements
- Ansible Core 2.15+
- AWSCLI 2+
- Chef 18.2.7+
- Go 1.21+
- Kitchen 3.5.0+
- Packer 1.9.4+
- Python 3.11+
- Terraform 1.0+

### Prerequisites
Create an S3 bucket and dynamodb table to serve as a remote backends for terraform.
Configure AWS credentials by using either environment variables or credentials file.

Log into AWS or use the AWSCLI and set the following parameters in Systems Manager Parameter Store in us-east-1 region. 
These parameters are used by base-deploy to create a terraform backend config file.
Fill in the parameters based on your environment. You can change the region for base-deploy to check by editing this [line](https://github.com/pafable/base-infra/blob/main/base-infra-deployer/src/deployer/base_infra_deployer.py#L19).

| Parameters                      | Description                                                                    |
|---------------------------------|--------------------------------------------------------------------------------|
| /account/owner/email            | owner email                                                                    |
| /account/owner                  | owner                                                                          |
| /account/region                 | region for terraform to deploy resources to (NOT THE TERRAFORM BACKEND REGION) |
| /tools/terraform/state/bucket   | terraform s3 backend bucket                                                    |
| /tools/terraform/state/dynamodb | terraform dynamodb backend                                                     |

## Instructions:
### Building the project
1. _Install dependencies_

This will automatically install python libraries needed by base-infra-deployer and create the `base-deploy` CLI command.
```commandline
make install
```

Alternatively you can achieve the same command by doing the following
```commandline
python3 -m pip install base-infra-deployer
```

2. _Deploy all infrastructure_

This will deploy all in terraform folder.
```commandline
make deploy-all
```
If you want to only deploy a certain project, you can use the `base-deploy` CLI command
```commandline
base-deploy --target "s3/base" 
```

3. _Destroying the deployed infrastructure_

Set the environment variable `DESTROY` to `--destroy`. 
```commandline
make deploy-all
```

You can also use the `base-deploy` command with the `--destroy` flag.
```commandline
base-deploy --target "s3/base" --destroy
```

### Testing
1. _Test deployer_

Runs unittest for base-infra-deployer
```commandline
make deployer-test
```

2. _Test terraform modules_

Runs tests for terraform modules
```commandline
make terratest
```

3. _Test Chef cookbooks_


Runs tests for Chef cookbooks
```commandline
make kitchen-test
```

4. _Run all tests (terraform and python deployer)_
```commandline
make test
```

### Setting up a development environment
The required python libraries are:
- boto3
- pylint

Create a python virtual environment, use `make install` or `python3 -m pip install base-infra-deployer` to install dependencies.
Please use pylint to check your code for style issues.

Set up your AWS access keys by either setting up environment variables or editing the aws credentials file.

### TODO
- Add Packer to base-infra-deployer script to deploy chef cookbooks and ansible playbooks
- Create ephemeral github actions self-hosted runner in a docker container
