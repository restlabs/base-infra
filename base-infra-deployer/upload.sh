#!/usr/bin/env bash

PYTHON=$(which python)
PYPI_REPO_URL="https://test.pypi.org/legacy/"

${PYTHON} -m twine check dist/*

${PYTHON} -m twine upload --verbose \
  --repository-url ${PYPI_REPO_URL} dist/*
