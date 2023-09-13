# Base Infra

Deploys base infrastructure to AWS. 
This project uses a python script (deployer.py) in the terraform folder to loop through the folders in terraform and deploys them. 

### Instructions
1. Install dependencies
```commandline
make install
```

2. Deploy infrastructure
```commandline
make deploy
```