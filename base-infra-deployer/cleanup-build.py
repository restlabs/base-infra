#!/usr/env python
"""
Cleanup Build
"""

import os
import subprocess

PYTHON_PACKAGES = {
    'astroid',
    'base-infra-deployer',
    'boto3',
    'botocore',
    'build',
    'certifi',
    'charset-normalizer',
    'colorama',
    'dill',
    'docutils',
    'importlib-metadata',
    'idna',
    'isort',
    'jaraco.classes',
    'jmespath',
    'keyring',
    'markdown-it-py',
    'mccabe',
    'mdurl',
    'more-itertools',
    'nh3',
    'packaging'
    'pkginfo',
    'platformdirs',
    'pylint',
    'Pygments',
    'pyproject_hooks',
    'python-dateutil',
    'pywin32-ctypes',
    'readme-renderer',
    'requests',
    'requests-toolbelt',
    'rfc3986',
    'rich',
    's3transfer',
    'six',
    'tomlkit',
    'twine',
    'urllib3',
    'zipp'
}


def uninstall_package(package: str) -> None:
    print(f'Deleting {package}')
    subprocess.run(
        [
            'python',
            '-m',
            'pip',
            'uninstall',
            '-y',
            package
        ],
        check=True
    )


if __name__ == '__main__':
    def main():
        for pkg in PYTHON_PACKAGES:
            uninstall_package(pkg)
    
