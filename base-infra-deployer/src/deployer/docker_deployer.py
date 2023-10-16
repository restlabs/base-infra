"""
THIS IS STILL A WIP
Docker deployer
"""

import subprocess

try:
    from .deployer_logger import logger
except ImportError:
    from deployer_logger import logger


class DockerDeployer:
    """
    creates a docker base-infra-deployer object
    """
    def __init__(
            self,
            tag: str,
            directory: str
    ):
        self.tag = tag
        self.directory = directory

    @property
    def system_info(self):
        """
        checks build system info
        """
        logger.info('checking build system info...')
        return logger.info(
                '\n' + subprocess.run(
                    [
                        'docker',
                        'info'
                    ],
                    check=True,
                    capture_output=True
                ).stdout.decode()
            )

    def create_image(self):
        """
        creates docker image
        """
        logger.info('creating docker image...')
        subprocess.run(
            [
                'docker',
                'build',
                f'--tag={self.tag}',
                f'{self.directory}'
            ],
            check=True
        )
