PYTHON ?= python3
PIP ?= $(PYTHON) -m pip
GO ?= go

.PHONY: clean install deploy terratest

deploy:
	$(PYTHON) deployer/src/deployer.py

deployer-test:
	$(PYTHON) -m unittest -v deployer/tests/test_deployer.py

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install deployer/

terratest:
	$(GO) -C terraform/modules/s3/test mod tidy
	$(GO) -C terraform/modules/s3/test test -v

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