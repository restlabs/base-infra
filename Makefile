PYTHON ?= python3
PIP ?= $(PYTHON) -m pip

.PHONY: clean install

deploy:
	$(PYTHON) terraform/deploy.py

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install .

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