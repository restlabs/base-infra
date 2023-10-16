"""
base infra deployer
"""
from typing import Any
import atexit
import os
import boto3

try:
    from .deployer_logger import logger
    from .tf_deployer import TFDeployer
    from .base_args import Base
    from .docker_deployer import DockerDeployer
except ImportError:
    from deployer_logger import logger
    from tf_deployer import TFDeployer
    from base_args import Base
    from docker_deployer import DockerDeployer

dirname = f'{os.getcwd()}'
TFPLAN_DEPLOY_FILENAME = 'terraform-deploy.plan'
TFVARS_FILENAME = 'terraform.tfvars.json'
TFBACKEND_FILE = 'backend-config.tfvars.json'
PARAMS_REGION = 'us-east-1'


def ssm_get(
        ssm_name: str,
        region=PARAMS_REGION
) -> Any:
    """
    retrieves ssm parameter. Used for creating terraform.tfvars.json
    """
    ssm = boto3.client('ssm', region)
    retval = ssm.get_parameter(Name=ssm_name)
    return retval['Parameter']['Value']


# base tags
# these params are set in ssm parameter store
app_email = ssm_get('/account/owner/email')
app_owner = ssm_get('/account/owner')
app_region = ssm_get('/account/region')
tf_state_bucket = ssm_get('/tools/terraform/state/bucket')
tf_state_lock_db = ssm_get('/tools/terraform/state/dynamodb')


def cleanup(
        tf_dir: str,
        tf_target: str
):
    """
    removes terraform.plan, backend-config.tfvars.json and terraform.tfvars.json
    """
    # pylint: disable=W1309
    # pylint: disable=W1203
    logger.info(f'DELETING {tf_target.upper()} TERRAFORM FILES................')
    for file in ('terraform-deploy.plan', 'backend-config.tfvars.json', 'terraform.tfvars.json'):
        logger.info(f'deleting {file} in {tf_dir}')
        if os.path.exists(f'{tf_dir}/{file}'):
            os.remove(f'{tf_dir}/{file}')


def main():
    # pylint: disable=C0116
    parser = Base(description='Runs base infra deployer')

    subparsers = parser.add_subparsers(title='subcommand', dest='subcommand')

    # terraform commands
    tf_subparser = subparsers.add_parser(
        name='terraform',
        help='Specify the target directory to deploy with terraform'
    )

    tf_subparser.add_argument(
        '--target',
        '-t',
        help='Specify the target directory to deploy',
        required=True
    )

    tf_subparser.add_argument(
        '--destroy',
        '-d',
        action='store_true',
        help='Destroys terraform resources',
        required=False
    )

    # docker commands
    docker_parser = subparsers.add_parser(
        name='docker',
        help='Specify the target directory to create a docker image'
    )

    docker_parser.add_argument(
        '--tag',
        '-ta',
        help='Creates tags for docker image',
        required=False
    )

    docker_parser.add_argument(
        '--target',
        '-t',
        help='Specify the target directory to build',
        required=True
    )

    args = parser.parse_args()
    print(args.subcommand)

    try:
        app_dir = f'{dirname}/{str(args.target.strip())}'

        if args.subcommand == 'terraform':
            # pylint: disable=W1309
            # pylint: disable=W1203
            logger.info(f'DEPLOYING: {args.target.upper()}')

            tf_deployer = TFDeployer(
                TFPLAN_DEPLOY_FILENAME,
                TFVARS_FILENAME,
                app_dir,
                args.target,
                app_email,
                app_owner,
                app_region,
                tf_state_bucket,
                tf_state_lock_db,
                TFBACKEND_FILE,
                PARAMS_REGION,
                bool(args.destroy)
            )

            # run cleanup even on errors or exits
            atexit.register(
                cleanup,
                app_dir,
                args.target
            )

            tf_deployer.apply()

        if args.subcommand == 'docker':
            logger.info('CREATING IMAGE FROM: %s', args.target.upper())
            docker_deployer = DockerDeployer(
                args.tag,
                app_dir
            )

            docker_deployer.system_info()
            docker_deployer.create_image()

    except Exception as e:
        raise logger.critical(e)


if __name__ == '__main__':
    main()
