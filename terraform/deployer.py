from typing import Any

import boto3
import json
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

def ssm_get(ssm_name: str, region=params_region) -> Any:
    """Retrieves ssm parameter. Used for creating terraform.tfvars.json"""
    ssm = boto3.client('ssm', region)
    retval = ssm.get_parameter(
        Name=ssm_name
    )
    return retval['Parameter']['Value']


class TFDeployer:
    def __init__(self, tfplan: str, tfvars: str, tfdir: str):
        self.tfplan = tfplan
        self.tfvars = tfvars
        self.tfdir = tfdir

    def validate(self):
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'validate'
            ]
        )

    def create_tfvars(self):
        data = {
            'app_name': 'fix_a',
            'owner': 'fix_b'
        }
        with open(self.tfvars, 'w') as json_file:
            json.dump(data, json_file)

        subprocess.run(['cat', self.tfvars])

    def init(self):
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'init'
            ]
        )

    def plan(self):
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
                tf_deployer = TFDeployer(
                    tfplan_filename,
                    tfvars_filename,
                    f'{directory}/{app_dir}'
                )

                tf_deployer.validate()
                tf_deployer.create_tfvars()
                # tf_deployer.init()
                # tf_deployer.plan()
                # tf_deployer.apply


if __name__ == '__main__':
    main()
