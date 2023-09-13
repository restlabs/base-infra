from typing import Any

import boto3
import json
import logging
import os
import subprocess

tfplan_filename = 'terraform.plan'
tfvars_filename = 'terraform.tfvars.json'
params_region = 'us-east-1'

ignore = [
    'deployer.py',
    'modules',
    tfplan_filename,
    tfvars_filename
]


def logger() -> logging.Logger:
    retval = logging.getLogger(__name__)

    if not retval.hasHandlers():
        retval.setLevel(logging.INFO)
        log_formatter = logging.Formatter(
            datefmt='%Y-%m-%d %H:%M:%S',
            fmt='%(asctime)s [%(levelname)s] - %(message)s'
        )
        stream_handler = logging.StreamHandler()
        stream_handler.setFormatter(log_formatter)
        retval.addHandler(stream_handler)

    return retval


def ssm_get(ssm_name: str, region=params_region) -> Any:
    """Retrieves ssm parameter. Used for creating terraform.tfvars.json"""
    ssm = boto3.client('ssm', region)
    retval = ssm.get_parameter(
        Name=ssm_name
    )
    return retval['Parameter']['Value']


logger = logger()


class TFDeployer:
    def __init__(self, tfplan: str, tfvars: str, tfdir: str):
        self.tfplan = tfplan
        self.tfvars = tfvars
        self.tfdir = tfdir

    def validate(self):
        logger.info('validating terraform files')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'validate'
            ]
        )

    def create_tfvars(self):
        logger.info('creating tfvars')
        data = {
            'app_name': 'base-infra',
            'email': 'my-test@example.com',
            'owner': 'pafable',
            'region': 'us-east-2'
        }
        with open(f'{self.tfdir}/{self.tfvars}', 'w') as json_file:
            json.dump(data, json_file)

        with open(f'{self.tfdir}/{self.tfvars}', 'r') as json_file:
            data = json.load(json_file)
            logger.info(
                json.dumps(
                    data,
                    indent=4
                )
            )

    def init(self):
        logger.info('initializing terraform')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'init'
            ]
        )

    def plan(self):
        logger.info('creating plan')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'plan',
                f'-var-file={self.tfvars}',
                '-out',
                self.tfplan
            ]
        )

    def apply(self):
        logger.info('applying plan')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'apply',
                self.tfplan
            ]
        )


def main():
    for directory in os.listdir():
        if directory not in ignore:
            for app_dir in os.listdir(directory):
                app_dir = f'{directory}/{app_dir}'

                tf_deployer = TFDeployer(
                    tfplan_filename,
                    tfvars_filename,
                    app_dir
                )

                tf_deployer.validate()
                tf_deployer.create_tfvars()
                tf_deployer.init()
                tf_deployer.plan()
                tf_deployer.apply()


if __name__ == '__main__':
    main()
