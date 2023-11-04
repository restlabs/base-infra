PYTHON ?= python
PIP ?= $(PYTHON) -m pip
GO ?= go
TRIVY ?= trivy


.PHONY: check-python
check-python:
	$(PYTHON) --version


.PHONY: create-container
create-container:
	base-deploy docker --tag hydra-runner --target dockerfiles/github-actions-runner


.PHONY: deploy-all
deploy-all:
	base-deploy --version
	make deploy-vpc
	#make deploy-s3
	make deploy-eks
	#make deploy-argo
	#make deploy-argo-example
	#make deploy-jenkins-example
	#make deploy-arc
	#make deploy-nexus


.PHONY: deploy-karpenter
deploy-karpenter:
	base-deploy terraform --target "terraform/helm/karpenter" $(DESTROY)


.PHONY: destroy-karpenter
destroy-karpenter:
	make deploy-karpenter DESTROY=--destroy


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
	base-deploy terraform --target "terraform/helm/github-arc" $(DESTROY)


.PHONY: deploy-argo
deploy-argo:
	base-deploy terraform --target "terraform/helm/argo" $(DESTROY)


.PHONY: deploy-argo-example
deploy-argo-example:
	base-deploy terraform --target "terraform/kubernetes/manifests/argo-example-app" $(DESTROY)


.PHONY: deploy-jenkins-example
deploy-jenkins-example:
	base-deploy terraform --target "terraform/kubernetes/manifests/jenkins-example"	$(DESTROY)


.PHONY: deploy-eks
deploy-eks:
	base-deploy terraform --target "terraform/eks/base" $(DESTROY)


.PHONY: deploy-nexus
deploy-nexus:
	base-deploy terraform --target "terraform/kubernetes/manifests/nexus" $(DESTROY)


.PHONY: deploy-s3
deploy-s3:
	base-deploy terraform --target "terraform/s3/base" $(DESTROY)


.PHONY: deploy-vpc
deploy-vpc:
	base-deploy terraform --target "terraform/vpc/base" $(DESTROY)


.PHONY: deployer-test
deployer-test:
	$(PYTHON) -m pylint base-infra-deployer/src
	$(PYTHON) -m unittest -v base-infra-deployer/tests/test_deployer.py


.PHONY: build
build:
	$(PYTHON) -m build base-infra-deployer
	$(PYTHON) -m twine check base-infra-deployer/dist/*


.PHONY: install
install:
	$(PYTHON) --version
	$(PIP) install --upgrade pip
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


.PHONY: test-shell
test-shell:
	shellcheck setup-aws-params.sh


.PHONY: test
test:  test-shell terratest install deployer-test


.PHONY: tf-trivy
tf-trivy:
	$(TRIVY) config --config=trivy.yaml terraform


.PHONY: clean
clean: check-python
	$(PYTHON) base-infra-deployer/cleanup_build.py