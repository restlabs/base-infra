PYTHON ?= python3
PIP ?= $(PYTHON) -m pip
GO ?= go

.PHONY: clean install deploy deployer-test kitchen-test terratest test

deploy:
	$(PYTHON) base-infra-deployer/src/deployer.py

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
		base-infra \
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
		deployer/build \
		deployer/*egg-info \
		src/*.egg-info
