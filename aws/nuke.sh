#!/bin/bash

# DANGER : This script is going to delete all the resources in AWS account.
# Note: Prefer to run in cloud shell of aws.

## Pre-Setup Steps
# 1. Configure AWS CLI with Credentials. Only this credentials user will be discarded
# 2. clone this repo and run this script
#     git clone https://github.com/linuxautomations/labautomation
#     cd  labautomation
#     bash aws/nuke.sh
#



# Delete IAM Users

# List IAM Users
CURRENT_USER=$(aws sts get-caller-identity | jq '.Arn' |sed -e 's/"//g')
ALL_USERS=$(aws iam list-users | jq '.Users[].Arn' | sed -e 's/"//g' | grep -v "${CURRENT_USER}" | awk -F / '{print $NF}')

for user in ${ALL_USERS}; do
  aws iam delete-user --user-name $user
done

ROLES=$(aws iam list-roles --query 'Roles[].RoleName' --output text|xargs -n1 | grep -Ev '^AWS|cross_role|main_role|OrganizationAccountAccessRole|workstation')

for role in ${ROLES}; do
  aws iam delete-role --role-name $role
done

POLICIES=$(aws iam list-policies --scope Local --query "Policies[].Arn" --output text   | xargs -n1)

for policy in ${POLICIES}; do
  aws iam delete-policy --policy-arn $policy
done