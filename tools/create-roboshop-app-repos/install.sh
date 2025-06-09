#!/bin/bash

echo All the repos are coming from https://github.com/roboshop-devops-project-v1/
echo
echo

read -p 'ORG Name: ' username

for repo in catalogue user cart shipping payment frontend dispatch ; do
  gh repo list $username  | grep roboshop-$repo
  if [ $? -eq 0 ]; then echo Repo Already Exists - SKIPPING ; continue ;fi
  cd /tmp
  git clone https://github.com/roboshop-devops-project-v1/$repo
  cd /home/centos
  gh repo create $username/$repo --public --clone
  cd /home/centos/$repo
  cp -r /tmp/$repo/* .
  git add -A
  git commit -m "Create Repo"
  git branch -m main
  git push --set-upstream origin main
done

logged_username=$(gh auth status | grep Logged | xargs -n1 | tail -n 2 | head -n1)
user_id=$(curl -s https://api.github.com/users/$logged_username | jq .id)

for repo in catalogue user cart shipping payment frontend dispatch ; do
  for env in DEV QA UAT PROD; do
    gh api \
      --method PUT \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      /repos/$username/roboshop-$repo/environments/$env \
      -F "prevent_self_review=false" -f "reviewers[][type]=User" -F "reviewers[][id]=$user_id"
  done
done


