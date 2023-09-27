from typing import Any
from deployer_logger import logger
from tfdeployer import TFDeployer
import boto3
import os

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


def ssm_get(ssm_name: str, region=params_region) -> Any:
    """
    retrieves ssm parameter. Used for creating terraform.tfvars.json
    """
    ssm = boto3.client('ssm', region)
    retval = ssm.get_parameter(
        Name=ssm_name
    )
    return retval['Parameter']['Value']


# base tags
# these params are set in ssm parameter store
app_email = ssm_get('/account/owner/email')
app_owner = ssm_get('/account/owner')
app_region = ssm_get('/account/region')
tf_state_bucket = ssm_get('/tools/terraform/state/bucket')
tf_state_lock_db = ssm_get('/tools/terraform/state/dynamodb')


class ChefDeployer:
    pass


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
                    app_region,
                    tf_state_bucket,
                    tf_state_lock_db,
                    tfbackend_file,
                    params_region
                )

                tf_deployer.apply()
                tf_deployer.delete_tfvars()


if __name__ == '__main__':
    main()
