# Base Infra
[![Deploy Base Infra](https://github.com/pafable/base-infra/actions/workflows/deploy.yml/badge.svg)](https://github.com/pafable/base-infra/actions/workflows/deploy.yml)

[![CI Tests](https://github.com/pafable/base-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/pafable/base-infra/actions/workflows/ci.yml)

Deploys base infrastructure to AWS. 
This project uses a python script (base_infra_deployer.py) in the deployer folder to deploy infrastructure in the terraform folder.

When adding more terraform resources into the project, create a folder for your project in the terraform folder. 
When you're ready to deploy your project build and install the base-infra-deployer code, it will create a CLI command called `base-deploy`.

Building the project
```commandline
python3 -m pip install base-infra-deployer
```

Executing the base-deploy CLI tool. Pass in the directory name in the terraform folder
```commandline
base-deploy --target "s3/base"
```

To destroy run the following
```commandline
base-deploy --target "s3/base" --destroy
```


### Requirements
- Ansible Core 2.15+
- Chef 18.2.7+
- Go 1.21+
- Kitchen 3.5.0+
- Packer 1.9.4+
- Python 3.11+
- Terraform 1.0+

### Instructions
1. Install dependencies

This will automatically install python libraries needed by base-infra-deployer and create the `base-deploy` CLI command.
```commandline
make install
```

2. Deploy all infrastructure
This will deploy all in terraform folder.
```commandline
make deploy-all
```
3. Destroying the deployed infrastructure
Set the environment variable `DESTROY` to `--destroy`. 
```commandline
make deploy-all
```

You can also use the `base-deploy` command with the `--destroy` flag.
```commandline
base-deploy --target "s3/base" --destroy
```

### Testing
1. Test deployer

Runs unittest for base-infra-deployer
```commandline
make deployer-test
```

2. Test terraform modules


Runs tests for terraform modules
```commandline
make terratest
```

3. Test Chef cookbooks


Runs tests for Chef cookbooks
```commandline
make kitchen-test
```

4. Run all tests (terraform and python deployer)
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
