#!/bin/bash

# DANGER : This script is going to delete all the resources in AWS account.
# Note: Prefer to run in cloud shell of aws.

## Pre-Setup Steps
# 1. Configure AWS CLI with Credentials. Only this credentials user will be discarded
# 2. clone this repo and run this script
#     git clone https://github.com/learndevopsonline/labautomation
#     cd  labautomation
#     bash aws/nuke.sh
#

AccountNo=$(aws sts get-caller-identity | jq .Account |xargs)

# Delete Instances Other than Workstation

# Delete spot instances
SIDS=$(aws ec2 describe-spot-instance-requests --query 'SpotInstanceRequests[*].SpotInstanceRequestId' --output text  | xargs)
for i in $SIDS ; do
  aws ec2 cancel-spot-instance-requests --spot-instance-request-ids $i
done

# Delete the instances
INSTANCES=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,State:State.Name,Name:Tags[?Key==`Name`]|[0].Value}' --output table | grep i- | grep -Ev 'workstation|terminated' | awk '{print $2}' |xargs)
for i in $INSTANCES; do
  aws ec2 terminate-instances --instance-ids $i
done


# Delete IAM Users

USERS=$(aws iam list-users --query 'Users[*].UserName' --output text)
for user in $USERS; do
  policies=$(aws iam list-user-policies --user-name $user --query 'PolicyNames[*]' --output text)
  for policy in ${policies}; do
    aws iam detach-user-policy --user-name $user --policy-arn arn:aws:iam::${AccountNo}:policy/$policy
    aws iam delete-user-policy --user-name $user --policy-name $policy
  done

  keys=$(aws iam list-access-keys     --user-name $user --query 'AccessKeyMetadata[*].AccessKeyId' --output text)
  for key in $keys ; do
    aws iam delete-access-key --access-key-id $key --user-name $user
  done

  aws iam delete-user --user-name $user
done

# List IAM Users
CURRENT_USER=$(aws sts get-caller-identity | jq '.Arn' |sed -e 's/"//g')
ALL_USERS=$(aws iam list-users | jq '.Users[].Arn' | sed -e 's/"//g' | grep -v "${CURRENT_USER}" | awk -F / '{print $NF}')

for user in ${ALL_USERS}; do
  aws iam delete-user --user-name $user
done

# IAM ROLES

ROLES=$(aws iam list-roles --query 'Roles[].RoleName' --output text|xargs -n1 | grep -Ev '^AWS|OrganizationAccountAccessRole|workstation')


for role in ${ROLES}; do
  aws iam remove-role-from-instance-profile --instance-profile-name $role --role-name $role
  for policyarn in $(aws iam list-attached-role-policies --role-name $role --query 'AttachedPolicies[*].PolicyArn' --output text); do
    aws iam detach-role-policy --role-name  $role --policy-arn $policyarn
  done
  for inline_policy in $(aws iam list-role-policies --role-name $role --query 'PolicyNames[*]' --output text); do
    aws iam delete-role-policy --role-name $role --policy-name ${inline_policy}
  done
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


## Route53
zones=$(aws route53 list-hosted-zones --query "HostedZones[*].{ID:Id,Name:Name,Private:Config.PrivateZone}" --output text | awk -F / '{print $NF}')
for zone in $zones ; do
  records=$(aws route53 list-resource-record-sets --hosted-zone-id $zone --query 'ResourceRecordSets[*].Name' --output text)
  for record in $records ; do

echo '{
  "Comment": "Created Server - Private IP address - IPADDRESS , DNS Record - COMPONENT-dev.DOMAIN_NAME",
  "Changes": [{
    "Action": "DELETE",
    "ResourceRecordSet": {
      "Name": "COMPONENT",
      "Type": "A",
      "TTL": 30,
      "ResourceRecords": [{ "Value": "IPADDRESS"}]
    }}]
}' | sed -e "s/COMPONENT/$record/" -e "s/IPADDRESS/1.1.1.1/" >/tmp/record.json

  aws route53 change-resource-record-sets --hosted-zone-id $zone --change-batch file:///tmp/record.json
echo '{
  "Comment": "Created Server - Private IP address - IPADDRESS , DNS Record - COMPONENT-dev.DOMAIN_NAME",
  "Changes": [{
    "Action": "DELETE",
    "ResourceRecordSet": {
      "Name": "COMPONENT",
      "Type": "CNAME",
      "TTL": 30,
      "ResourceRecords": [{ "Value": "www.google.com"}]
    }}]
}' | sed -e "s/COMPONENT/$record/" >/tmp/record.json

  aws route53 change-resource-record-sets --hosted-zone-id $zone --change-batch file:///tmp/record.json
  done
  aws route53 delete-hosted-zone --id $zone
done

## ACM
certs=$(aws acm list-certificates --query 'CertificateSummaryList[*].CertificateArn' --output text)
for cert in $certs ; do
  aws acm delete-certificate --certificate-arn $cert
done