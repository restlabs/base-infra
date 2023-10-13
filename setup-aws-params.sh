#!/usr/bin/env bash

# NAME: Setup AWS Params
# DESC: This script will create entries in SSM parameters in AWS Parameter Store
# Default region: us-east-1
# Usage: setup-aws-params.sh <ENV> <OWNER> <EMAIL> <PUBLIC_IP> <APP_REGION> <TF_STATE_BUCKET> <TF_STATE_DYNAMODB_LOCK>

AWS_REGION='us-east-1'
ENV=$1
OWNER=$2
EMAIL=$3
PUBLIC_IP=$4
APP_REGION=$5
TF_STATE_BUCKET=$6
TF_STATE_DYNAMODB_LOCK=$7

function ssm_put() {
    aws ssm put-parameter \
      --name "${1}" \
      --value "${2}" \
      --type String \
      --overwrite \
      --region "${AWS_REGION}"
}

ssm_put "/account/env" "${ENV}"
ssm_put "/account/owner" "${OWNER}"
ssm_put "/account/owner/email" "${EMAIL}"
ssm_put "/account/owner/public/ip" "${PUBLIC_IP}"
ssm_put "/account/region" "${APP_REGION}"
ssm_put "/tools/terraform/state/bucket" "${TF_STATE_BUCKET}"
ssm_put "/tools/terraform/state/dynamodb" "${TF_STATE_DYNAMODB_LOCK}"
