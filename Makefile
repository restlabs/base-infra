PYTHON ?= python
PIP ?= $(PYTHON) -m pip
GO ?= go
TRIVY ?= trivy

.PHONY: deploy-all
deploy-all:
	base-deploy --version
	make deploy-vpc
	make deploy-s3
	make deploy-eks
	make deploy-argo
	make deploy-argo-example
	make deploy-jenkins-example
	make deploy-arc


.PHONY: destroy-all
destroy-all:
	make deploy-arc DESTROY=--destroy
	make deploy-argo-example DESTROY=--destroy
	make deploy-argo DESTROY=--destroy
	make deploy-eks DESTROY=--destroy
	make deploy-s3 DESTROY=--destroy
	make deploy-vpc DESTROY=--destroy


.PHONY: deploy-arc
deploy-arc:
	base-deploy --target "helm/github-arc" $(DESTROY)


.PHONY: deploy-argo
deploy-argo:
	base-deploy --target "helm/argo" $(DESTROY)


.PHONY: deploy-argo-example
deploy-argo-example:
	base-deploy --target "kubernetes/manifests/argo-example-app" $(DESTROY)


.PHONY: deploy-jenkins-example
deploy-jenkins-example:
	base-deploy --target "kubernetes/manifests/jenkins-example"	$(DESTROY)


.PHONY: deploy-eks
deploy-eks:
	base-deploy --target "eks/base" $(DESTROY)


.PHONY: deploy-s3
deploy-s3:
	base-deploy --target "s3/base" $(DESTROY)


.PHONY: deploy-vpc
deploy-vpc:
	base-deploy --target "vpc/base" $(DESTROY)


.PHONY: deployer-test
deployer-test:
	$(PYTHON) -m pylint base-infra-deployer/src
	$(PYTHON) -m unittest -v base-infra-deployer/tests/test_deployer.py


.PHONY: install
install:
	$(PYTHON) --version
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install base-infra-deployer/


.PHONY: kitchen-test
kitchen-test:
	cd cookbooks/base-ami && kitchen test


.PHONY: terratest
terratest:
	$(GO) -C terraform/modules/s3/test mod tidy
	$(GO) -C terraform/modules/s3/test test -v
	$(GO) -C terraform/modules/vpc/test mod tidy
	$(GO) -C terraform/modules/vpc/test test -v


.PHONY: test
test: install terratest deployer-test


.PHONY: tf-trivy
tf-trivy:
	$(TRIVY) config --config=trivy.yaml terraform


.PHONY: clean
clean:
	$(PIP) uninstall -y \
		asteroid \
		base-infra-deployer \
		boto3 \
		botocore \
		dill \
		isort \
		jmespath \
		mccabe \
		platformdirs \
		pylint \
		python-dateutil \
		six \
		s3transfer \
		tomlkit \
		urllib3

	rm -rf build \
		*.egg-info \
		base-infra-deployer/build \
		base-infra-deployer/src/*egg-info \
		src/*.egg-info
