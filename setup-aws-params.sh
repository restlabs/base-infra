#!/usr/bin/env bash

set -euo pipefail

# NAME: Setup AWS Params
# DESC: This script will create entries in SSM parameters in AWS Parameter Store
# Default region: us-east-1
#
# Usage:
#   setup-aws-params.sh \
#     <ENVIRONMENT> \
#     <OWNER> \
#     <EMAIL> \
#     <PUBLIC_IP> \
#     <APP_REGION> \
#     <TF_STATE_BUCKET> \
#     <TF_STATE_DYNAMODB_LOCK> \
#     <GITHUB_APP_ID> \
#     <GITHUB_APP_INSTALL_ID> \
#     <GITHUB_APP_PRIVATE_KEY_FILE> \
#     <GITHUB_ORGANIZATION_URL>

AWS_REGION='us-east-1'
ENVIRONMENT=${1}
OWNER=${2}
EMAIL=${3}
PUBLIC_IP=${4}
APP_REGION=${5}
TF_STATE_BUCKET=${6}
TF_STATE_DYNAMODB_LOCK=${7}
GITHUB_APP_ID=${8}
GITHUB_APP_INSTALL_ID=${9}
GITHUB_APP_PRIVATE_KEY_FILE=${10} # make sure the pem file is the root directory of this project
GITHUB_ORGANIZATION_URL=${11}

# shellcheck disable=SC2034
trap unset AWS_PAGER EXIT
export AWS_PAGER=""

function ssm_put() {
  if [ "${3}" == "secure"  ]; then
      TYPE="SecureString"
      FILE="file://${2}"
  else
      TYPE="String"
      FILE=${2}
  fi

  echo "added parameter: ${1}"
  aws ssm put-parameter \
    --name "${1}" \
    --value "${FILE}" \
    --type ${TYPE} \
    --output json \
    --overwrite \
    --region "${AWS_REGION}"

  aws ssm add-tags-to-resource \
    --resource-type "Parameter" \
    --resource-id "${1}" \
    --tags '[{"Key":"project","Value":"base-infra"}, {"Key":"code_location","Value":"setup-aws-params.sh"}]'
}

# account params
ssm_put "/account/environment" "${ENVIRONMENT}"
ssm_put "/account/owner" "${OWNER}"
ssm_put "/account/owner/email" "${EMAIL}"
ssm_put "/account/owner/public/ip" "${PUBLIC_IP}"
ssm_put "/account/region" "${APP_REGION}"

# terraform params
ssm_put "/tools/terraform/state/bucket" "${TF_STATE_BUCKET}"
ssm_put "/tools/terraform/state/dynamodb" "${TF_STATE_DYNAMODB_LOCK}"

# github arc params
ssm_put "/gihub/app/id" "${GITHUB_APP_ID}"
ssm_put "/github/app/installation/id" "${GITHUB_APP_INSTALL_ID}"
ssm_put "/github/app/private/key" "${GITHUB_APP_PRIVATE_KEY_FILE}" "secure"
ssm_put "/github/organization/url" "${GITHUB_ORGANIZATION_URL}"

unset AWS_PAGER
