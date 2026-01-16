#!/bin/bash

type gh &>/dev/null
if [ $? -ne 0 ]; then
       echo gh command is missing
	echo Run labauto github-cli to install
	exit 1
fi

gh auth status &>/dev/null
if [ $? -ne 0 ] ; then
	echo Run gh auth login to login
	exit 1
fi

gh extension install katiem0/gh-environments &>/dev/null

read -p 'Enter OrgName: ' org_name
read -p 'Enter repo name( Multi repo with commans ): ' repo_name
if [ -z "${repo_name}" ]; then
	echo "Input repo is mandatory"
	exit 1
fi
user_id=$(gh api user -q ".id")
user_name=$(gh api user -q ".login")

echo RepositoryName,RepositoryID,EnvironmentName,AdminBypass,WaitTimer,Reviewers,PreventSelfReview,BranchPolicyType,Branches,CustomDeploymentProtectionPolicy,SecretsTotalCount,VariablesTotalCount >/tmp/gh-env-create.csv
for i in $(echo $repo_name | sed -e 's/,/ /g'); do
  for ENV in dev qa uat prod; do
    if [ $ENV == dev ]; then
      echo "$i,,$ENV,true,0,User;,false,,,,0,0" >>/tmp/gh-env-create.csv
    else
      echo "$i,,$ENV,true,0,User;$user_name;$user_id,false,,,,0,0" >>/tmp/gh-env-create.csv
    fi
  done
done

gh environments create $org_name --from-file /tmp/gh-env-create.csv

