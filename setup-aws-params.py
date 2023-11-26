import boto3
import sys

SSM_REGION = 'us-east-1'

# arguments passed into the script
ENVIRONMENT = sys.argv[1]
OWNER = sys.argv[2]
EMAIL = sys.argv[3]
PUBLIC_IP = sys.argv[4]
APP_REGION = sys.argv[5]
TF_STATE_BUCKET = sys.argv[6]
TF_STATE_DYNAMODB_LOCK = sys.argv[7]
GITHUB_APP_ID = sys.argv[8]
GITHUB_APP_INSTALL_ID = sys.argv[9]
GITHUB_APP_PRIVATE_KEY_FILE = sys.argv[10]  # make sure the pem file is the root directory of this project
GITHUB_ORGANIZATION_URL = sys.argv[11]


def ssm_put(
        param_name: str,
        param_value: str,
        is_secure: bool = False
):
    file_type = 'SecureString' if is_secure else 'String'
    ssm = boto3.client('ssm', region_name=SSM_REGION)

    ssm.put_parameter(
        Name=param_name,
        Overwrite=True,
        Type=file_type,
        Value=param_value,
        Tags=[
            {
                'Key': 'project',
                'Value': 'base-infra'
            },
            {
                'key': 'code_location',
                'Value': 'setup-aws-params.py'
            }
        ]
    )


def main():
    # account params
    ssm_put('/account/environment', ENVIRONMENT)
    ssm_put('/account/owner', OWNER)
    ssm_put('/account/owner/email', EMAIL)
    ssm_put('/account/owner/public/ip', PUBLIC_IP)
    ssm_put('/account/region', APP_REGION)

    # terraform params
    ssm_put('/tools/terraform/state/bucket', TF_STATE_BUCKET)
    ssm_put('/tools/terraform/state/dynamodb', TF_STATE_DYNAMODB_LOCK)

    # github arc params
    ssm_put('/gihub/app/id', GITHUB_APP_ID)
    ssm_put('/github/app/installation/id', GITHUB_APP_INSTALL_ID)
    ssm_put('/github/app/private/key', GITHUB_APP_PRIVATE_KEY_FILE, True)
    ssm_put('/github/organization/url', GITHUB_ORGANIZATION_URL)


if __name__ == '__main__':
    main()
