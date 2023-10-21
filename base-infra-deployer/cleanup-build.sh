#!/usr/bin/env bash

PYTHON=$(which python)

${PYTHON} -m pip uninstall -y \
	astroid \
	base-infra-deployer \
	boto3 \
	botocore \
	certifi \
	charset-normalizer \
	colorama \
	dill \
	docutils \
	importlib-metadata \
	idna \
	isort \
	jaraco.classes \
	jmespath \
	keyring \
	markdown-it-py \
	mccabe \
	mdurl \
	more-itertools \
	nh3 \
	pkginfo \
	platformdirs \
	pylint \
	Pygments \
	python-dateutil \
	pywin32-ctypes \
	readme-renderer \
	requests \
	requests-toolbelt \
	rfc3986 \
	rich \
	s3transfer \
	six \
	tomlkit \
	twine \
	urllib3 \
	zipp

rm -rf build \
	*.egg-info \
	base-infra-deployer/build \
	base-infra-deployer/dist \
	base-infra-deployer/src/*egg-info \
	src/*.egg-info