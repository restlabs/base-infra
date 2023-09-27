# Base Infra
[![Deploy Base Infra](https://github.com/pafable/base-infra/actions/workflows/deploy.yml/badge.svg)](https://github.com/pafable/base-infra/actions/workflows/deploy.yml)

Deploys base infrastructure to AWS. 
This project uses a python script (deployer.py) in the terraform folder to loop through the folders in terraform and deploys them. 

## Requirements
- Terraform 1.0+
- Python 3.11+
- Go 1.21+
- Chef 18.2.7+
- Kitchen 3.5.0+
- Packer 1.9.4+

### Instructions
1. Install dependencies
```commandline
make install
```

2. Deploy infrastructure
```commandline
make deploy
```

## Testing
1. Test terraform modules
```commandline
make terratest
```

2. Test Chef cookbooks
```commandline
make kitchen-test
```