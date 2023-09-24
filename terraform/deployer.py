from typing import Any

import boto3
import json
import logging
import os
import subprocess

dirname = os.path.dirname(__file__)
tfplan_deploy_filename = 'terraform-deploy.plan'
tfvars_filename = 'terraform.tfvars.json'
tfbackend_file = 'backend-config.tfvars.json'
params_region = 'us-east-1'

# files for terraform to ignore within the terraform dir
ignore = [
    'base_infra.egg-info',
    'cookbooks',
    'deployer.py',
    'modules',
    tfplan_deploy_filename,
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
tf_state_bucket = ssm_get('/tools/terraform/state/bucket')
tf_state_lock_db = ssm_get('/tools/terraform/state/dynamodb')


class TFDeployer:
    """
    creates a terraform deployer object
    """
    def __init__(
            self,
            tfplan: str,
            tfvars: str,
            tfdir: str,
            tfkey: str,
            appemail: str,
            appowner: str,
            appregion: str
    ):
        self.tfplan = tfplan
        self.tfvars = tfvars
        self.tfdir = tfdir
        self.tfkey = tfkey
        self.appemail = appemail
        self.appowner = appowner
        self.appregion = appregion

    def _validate(self):
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

    def _create_backend_config(self):
        """
        creates a json file for terraform backend config
        """
        logger.info('creating backend config file')
        data = {
            'bucket': tf_state_bucket,
            'key': f'{self.tfkey}/terraform.tfstate',
            'region': params_region,
            'encrypt': 'true',
            'dynamodb_table': tf_state_lock_db
        }

        with open(f'{self.tfdir}/{tfbackend_file}', 'w') as json_file:
            json.dump(data, json_file)

        logger.info(f'displaying contents of {tfbackend_file} :')
        with open(f'{self.tfdir}/{tfbackend_file}', 'r') as json_file:
            data = json.load(json_file)
            logger.info(
                json.dumps(
                    data,
                    indent=4
                )
            )

    def _create_tfvars(self):
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

        logger.info(f'displaying contents of {self.tfvars} :')
        with open(f'{self.tfdir}/{self.tfvars}', 'r') as json_file:
            data = json.load(json_file)
            logger.info(
                json.dumps(
                    data,
                    indent=4
                )
            )

    def _tf_init(self):
        """
        initializes terraform
        """
        self._create_backend_config()
        self._create_tfvars()
        logger.info('initializing terraform')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'init',
                f'-backend-config={tfbackend_file}',
                '-reconfigure'
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )
        self._validate()

    def _plan(self, destroy=True):
        """
        creates a terraform plan
        """
        self._tf_init()
        logger.info('creating plan')

        tf_commands = [
            'terraform',
            f'-chdir={self.tfdir}',
            'plan',
            f'-var-file={self.tfvars}',
            '-out',
            self.tfplan
        ]

        if destroy:
            tf_commands.append('-destroy')

        subprocess.run(
            tf_commands,
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def apply(self):
        """
        applies a terraform plan
        """
        self._plan()
        logger.info('applying plan')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tfdir}',
                'apply',
                self.tfplan
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def delete_tfvars(self):
        """
        removes terraform.plan, backend-config.tfvars.json and terraform.tfvars.json
        """
        for file in [self.tfplan, self.tfvars, tfbackend_file]:
            logger.info(f'deleting {file}')
            if os.path.exists(f'{self.tfdir}/{file}'):
                os.remove(f'{self.tfdir}/{file}')


def main():
    for directory in os.listdir(dirname):
        if directory not in ignore:
            for app_dir in os.listdir(f'{dirname}/{directory}'):
                tf_key = f'{directory}/{app_dir}'
                logger.info(f'\nDEPLOYING: {tf_key}')
                app_dir = f'{dirname}/{directory}/{app_dir}'

                tf_deployer = TFDeployer(
                    tfplan_deploy_filename,
                    tfvars_filename,
                    app_dir,
                    tf_key,
                    app_email,
                    app_owner,
                    app_region
                )

                tf_deployer.apply()
                tf_deployer.delete_tfvars()


if __name__ == '__main__':
    main()
