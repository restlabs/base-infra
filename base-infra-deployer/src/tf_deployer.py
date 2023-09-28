from deployer_logger import logger
import json
import subprocess


class TFDeployer:
    """
    creates a terraform base-infra-deployer object
    """
    def __init__(
            self,
            tf_plan: str,
            tf_vars: str,
            tf_dir: str,
            tf_key: str,
            app_email: str,
            app_owner: str,
            app_region: str,
            backend_bucket: str,
            backend_dynamo: str,
            backend_file: str,
            params_region: str
    ):
        self.tf_plan = tf_plan
        self.tf_vars = tf_vars
        self.tf_dir = tf_dir
        self.tf_key = tf_key
        self.app_email = app_email
        self.app_owner = app_owner
        self.app_region = app_region
        self.backend_bucket = backend_bucket
        self.backend_dynamo = backend_dynamo
        self.backend_file = backend_file
        self.params_region = params_region

    def _validate(self):
        """
        validates terraform files have correct syntax
        """
        logger.info('validating terraform files')
        subprocess.run(
            [
                'terraform',
                f'-chdir={self.tf_dir}',
                'validate'
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )

    def _write_json_to_file(
            self,
            data_json: dict,
            file_to_display: str
    ):
        with open(f'{self.tf_dir}/{file_to_display}', 'w') as json_file:
            json.dump(data_json, json_file)

        logger.info(f'displaying contents of {file_to_display} :')
        with open(f'{self.tf_dir}/{file_to_display}', 'r') as json_file:
            data = json.load(json_file)
            logger.info(
                json.dumps(
                    data,
                    indent=4
                )
            )

    def _create_backend_config(self):
        """
        creates a json file for terraform backend config
        """
        logger.info('creating backend config file')
        data = {
            'bucket': self.backend_bucket,
            'key': f'{self.tf_key}/terraform.tfstate',
            'region': self.params_region,
            'encrypt': 'true',
            'dynamodb_table': self.backend_dynamo
        }

        self._write_json_to_file(data, self.backend_file)

    def _create_tfvars(self):
        """
        creates a json file for tfvars
        """
        logger.info('creating tfvars')
        data = {
            'email': self.app_email,
            'owner': self.app_owner,
            'region': self.app_region
        }

        self._write_json_to_file(data, self.tf_vars)

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
                f'-chdir={self.tf_dir}',
                'init',
                f'-backend-config={self.backend_file}',
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
            f'-chdir={self.tf_dir}',
            'plan',
            f'-var-file={self.tf_vars}',
            '-out',
            self.tf_plan
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
                f'-chdir={self.tf_dir}',
                'apply',
                self.tf_plan
            ],
            # will throw an error and stop the script if terraform runs into an error
            check=True
        )
