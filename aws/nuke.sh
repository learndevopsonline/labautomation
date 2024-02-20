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

# Delete Instances Other than Workstation

# Delete spot instances
SIDS=$(aws ec2 describe-spot-instance-requests --query 'SpotInstanceRequests[*].SpotInstanceRequestId' --output text  | xargs)
for i in $SIDS ; do
  aws ec2 cancel-spot-instance-requests --spot-instance-request-ids $i
done


# Delete IAM Users

# List IAM Users
CURRENT_USER=$(aws sts get-caller-identity | jq '.Arn' |sed -e 's/"//g')
ALL_USERS=$(aws iam list-users | jq '.Users[].Arn' | sed -e 's/"//g' | grep -v "${CURRENT_USER}" | awk -F / '{print $NF}')

for user in ${ALL_USERS}; do
  aws iam delete-user --user-name $user
done

ROLES=$(aws iam list-roles --query 'Roles[].RoleName' --output text|xargs -n1 | grep -Ev '^AWS|OrganizationAccountAccessRole|workstation')

for role in ${ROLES}; do
  aws iam delete-role --role-name $role
done

POLICIES=$(aws iam list-policies --scope Local --query "Policies[].Arn" --output text   | xargs -n1)

for policy in ${POLICIES}; do
  echo $policy

  for version in `aws iam list-policy-versions --policy-arn $policy --query "Versions[].VersionId" --output text`; do
    aws iam delete-policy-version --policy-arn $policy --version-id $version
  done
  aws iam delete-policy --policy-arn $policy
done

REPOS=$(aws ecr describe-repositories --query 'repositories[].repositoryName' --output text)
for repo in ${REPOS}; do
  aws ecr delete-repository --repository-name $repo --force
done

BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text)
for bucket in $BUCKETS; do
  aws s3 rb s3://$bucket --force
done

PARAMS=$(aws ssm describe-parameters --query 'Parameters[].Name' --output text |xargs)

for param in $PARAMS; do
  aws ssm delete-parameter --name $param
done