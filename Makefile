PYTHON ?= python3
PIP ?= $(PYTHON) -m pip
GO ?= go

.PHONY: clean install deploy deployer-test kitchen-test terratest test

deploy:
	base-deploy --version
	base-deploy --target "s3/base" --destroy $(DESTROY)
	base-deploy --target "vpc/base" --destroy $(DESTROY)
	base-deploy --target "eks/base" --destroy $(DESTROY)

deployer-test:
	$(PYTHON) -m unittest -v base-infra-deployer/tests/test_deployer.py

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install base-infra-deployer/

kitchen-test:
	cd cookbooks/base-ami && kitchen test

terratest:
	$(GO) -C terraform/modules/s3/test mod tidy
	$(GO) -C terraform/modules/s3/test test -v
	$(GO) -C terraform/modules/vpc/test mod tidy
	$(GO) -C terraform/modules/vpc/test test -v

test: terratest deployer-test

clean:
	$(PIP) uninstall -y \
		base-infra-deployer \
		boto3 \
		botocore \
		jmespath \
		python-dateutil \
		six \
		s3transfer \
		urllib3

	rm -rf build \
		*.egg-info \
		base-infra-deployer/build \
		base-infra-deployer/src/*egg-info \
		src/*.egg-info
