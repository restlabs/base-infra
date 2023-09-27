PYTHON ?= python3
PIP ?= $(PYTHON) -m pip
GO ?= go

.PHONY: clean install deploy terratest

deploy:
	$(PYTHON) terraform/deployer.py

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install .

terratest:
	$(GO) -C terraform/modules/s3/test mod tidy
	$(GO) -C terraform/modules/s3/test test -v

clean:
	$(PIP) uninstall -y \
		base-infra \
		boto3 \
		botocore \
		jmespath \
		python-dateutil \
		six \
		s3transfer \
		urllib3

	rm -rf build \
		*.egg-info