# BASE-INFRA-DEPLOYER

### Uploading to Nexus 
Set the following environment variables
`TWINE_USERNAME` & `TWINE_PASSWORD`

```commandline
python -m twine upload --verbose \
		--repository-url <NEXUS_URL> \
		dist/*
```

### Download and Install
PIP_INDEX_URL=<NEXUS_PYPI_URL>/simple pip3 install -U base-infra-deployer
