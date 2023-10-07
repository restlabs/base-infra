PYTHON ?= python
PIP ?= $(PYTHON) -m pip
GO ?= go
TRIVY ?= trivy

.PHONY: clean install deploy-all deploy-eks deployer-test kitchen-test terratest test

deploy-all:
	base-deploy --version
	make deploy-vpc
	make deploy-s3

deploy-argo:
	base-deploy --target "helm/argo" $(DESTROY)

deploy-eks:
	base-deploy --target "eks/base" $(DESTROY)

deploy-s3:
	base-deploy --target "s3/base" $(DESTROY)

deploy-vpc:
	base-deploy --target "vpc/base" $(DESTROY)

deployer-test:
	$(PYTHON) -m pylint base-infra-deployer/src
	$(PYTHON) -m unittest -v base-infra-deployer/tests/test_deployer.py

install:
	$(PYTHON) --version
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install base-infra-deployer/

kitchen-test:
	cd cookbooks/base-ami && kitchen test

terratest:
	$(GO) -C terraform/modules/s3/test mod tidy
	$(GO) -C terraform/modules/s3/test test -v
	$(GO) -C terraform/modules/vpc/test mod tidy
	$(GO) -C terraform/modules/vpc/test test -v

test: install terratest deployer-test

tf-trivy:
	$(TRIVY) config --config=trivy.yaml terraform


clean:
	$(PIP) uninstall -y \
		base-infra-deployer \
		boto3 \
		botocore \
		jmespath \
		pylint \
		python-dateutil \
		six \
		s3transfer \
		urllib3

	rm -rf build \
		*.egg-info \
		base-infra-deployer/build \
		base-infra-deployer/src/*egg-info \
		src/*.egg-info
