"""
Cleanup Build on Linux, MacOS, and Windows
"""

import logging
import os
import shutil
import subprocess

# logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
log_formatter = logging.Formatter(
    datefmt='%Y-%m-%d %H:%M:%S',
    fmt='%(asctime)s [%(levelname)s] - %(message)s'
)
stream_handler = logging.StreamHandler()
stream_handler.setFormatter(log_formatter)
logger.addHandler(stream_handler)


PYTHON_PACKAGES = {
    'Pygments',
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
    'idna',
    'importlib-metadata',
    'isort',
    'jaraco.classes',
    'jmespath',
    'keyring',
    'localstack',
    'markdown-it-py',
    'mccabe',
    'mdurl',
    'more-itertools',
    'nh3',
    'packaging',
    'pkginfo',
    'platformdirs',
    'pylint',
    'pyproject-hooks',
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


class Cleaner:
    @staticmethod
    def remove_dir() -> None:
        dirname = os.getcwd()
        base_infra_deployer_root = 'base-infra-deployer'

        if os.name != 'posix':
            build = f'\\{base_infra_deployer_root}\\build'
            dist = f'\\{base_infra_deployer_root}\\dist'
            egg = f'\\{base_infra_deployer_root}\\src\\base_infra_deployer.egg-info'
        else:
            build = f'/{base_infra_deployer_root}/build'
            dist = f'/{base_infra_deployer_root}/dist'
            egg = f'/{base_infra_deployer_root}/src/base_infra_deployer.egg-info'

        build_dir = f'{dirname}{build}'
        dist_dir = f'{dirname}{dist}'
        egg_dir = f'{dirname}{egg}'

        for directory in [build_dir, dist_dir, egg_dir]:
            try:
                logger.info(f'deleting {directory}')
                shutil.rmtree(directory)
            except Exception as e:
                logger.info(e)

    @staticmethod
    def uninstall_package(package: str) -> None:
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


def main():
    try:
        cleaner = Cleaner()
        cleaner.remove_dir()
        for pkg in PYTHON_PACKAGES:
            cleaner.uninstall_package(pkg)
    except Exception as e:
        logger.critical(e)


if __name__ == '__main__':
    main()
