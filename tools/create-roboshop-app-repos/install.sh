#!/bin/bash

echo All the repos are coming from https://github.com/roboshop-devops-project-v1/
echo
echo

read -p 'ORG Name: ' username

for repo in catalogue user cart shipping payment frontend dispatch ; do
  gh repo list $username  | grep roboshop-$repo
  if [ $? -eq 0 ]; then echo Repo Already Exists; continue ;fi
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
