from typing import Any

import boto3
import json
import logging
import os
import subprocess

dirname = os.path.dirname(__file__)
tfplan_filename = 'terraform.plan'
tfvars_filename = 'terraform.tfvars.json'
params_region = 'us-east-1'

# files for terraform to ignore within the terraform dir
ignore = [
    'deployer.py',
    'modules',
    tfplan_filename,
    tfvars_filename
]


def logger() -> logging.Logger:
    """
    creates a logger
    """
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
    """
    retrieves ssm parameter. Used for creating terraform.tfvars.json
    """
    ssm = boto3.client('ssm', region)
    retval = ssm.get_parameter(
        Name=ssm_name
    )
    return retval['Parameter']['Value']


logger = logger()

# base tags
# these params are set in ssm parameter store
app_email = ssm_get('/account/owner/email')
app_owner = ssm_get('/account/owner')
app_region = ssm_get('/account/region')


class TFDeployer:
    """
    creates a terraform deployer object
    """
    def __init__(
            self,
            tfplan: str,
            tfvars: str,
            tfdir: str,
            appemail: str,
            appowner: str,
            appregion: str
    ):
        self.tfplan = tfplan
        self.tfvars = tfvars
        self.tfdir = tfdir
        self.appemail = appemail
        self.appowner = appowner
        self.appregion = appregion

    def validate(self):
        """
        validates terraform files have correct syntax
        """
        logger.info('validating terraform files')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'validate'
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def create_tfvars(self):
        """
        creates a json file for tfvars
        """
        logger.info('creating tfvars')
        data = {
            'email': self.appemail,
            'owner': self.appowner,
            'region': self.appregion
        }
        with open(f'{self.tfdir}/{self.tfvars}', 'w') as json_file:
            json.dump(data, json_file)

        logger.info(f'displaying contents of {self.tfvars}')
        with open(f'{self.tfdir}/{self.tfvars}', 'r') as json_file:
            data = json.load(json_file)
            logger.info(
                json.dumps(
                    data,
                    indent=4
                )
            )

    def init(self):
        """
        initializes terraform
        """
        logger.info('initializing terraform')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'init'
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def plan(self):
        """
        creates a terraform plan
        """
        logger.info('creating plan')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'plan',
                f'-var-file={self.tfvars}',
                '-out',
                self.tfplan
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def apply(self):
        """
        applies a terraform plan
        """
        logger.info('applying plan')
        out = subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'apply',
                self.tfplan
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def delete(self):
        """
        removes terraform.plan and terraform.tfvars.json
        """
        for file in [self.tfplan, self.tfvars]:
            logger.info(f'deleting {file}')
            if os.path.exists(f'{self.tfdir}/{file}'):
                os.remove(f'{self.tfdir}/{file}')


def main():
    for directory in os.listdir(dirname):
        if directory not in ignore:
            for app_dir in os.listdir(f'{dirname}/{directory}'):
                app_dir = f'{dirname}/{directory}/{app_dir}'

                tf_deployer = TFDeployer(
                    tfplan_filename,
                    tfvars_filename,
                    app_dir,
                    app_email,
                    app_owner,
                    app_region
                )

                tf_deployer.init()
                tf_deployer.validate()
                tf_deployer.create_tfvars()
                tf_deployer.plan()
                tf_deployer.apply()
                tf_deployer.delete()


if __name__ == '__main__':
    main()
