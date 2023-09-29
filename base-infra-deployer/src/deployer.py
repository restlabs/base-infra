import atexit
from typing import Any
from deployer_logger import logger
from tf_deployer import TFDeployer
import boto3
import os

dirname = f'{os.getcwd()}/terraform'
tfplan_deploy_filename = 'terraform-deploy.plan'
tfvars_filename = 'terraform.tfvars.json'
tfbackend_file = 'backend-config.tfvars.json'
params_region = 'us-east-1'

# files for terraform to ignore within the terraform dir
ignore = [
    'base_infra.egg-info',
    'cookbooks',
    'base-infra-deployer.py',
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


def cleanup(tf_dir: str):
    """
    removes terraform.plan, backend-config.tfvars.json and terraform.tfvars.json
    """
    for file in ['terraform.plan', 'backend-config.tfvars.json', 'terraform.tfvars.json']:
        logger.info(f'deleting {file} in {tf_dir}')
        if os.path.exists(f'{tf_dir}/{file}'):
            os.remove(f'{tf_dir}/{file}')


def main():
    try:
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

                    atexit.register(cleanup, app_dir)  # run cleanup even on errors or exits
                    tf_deployer.apply()

    except Exception as e:
        raise logger.critical(e)


if __name__ == '__main__':
    main()
