#!/bin/bash

echo All the repos are coming from https://github.com/roboshop-devops-project-v1/
echo
echo

read -p 'Enter Username: ' username

for repo in catalogue user cart shipping payment frontend dispatch ; do
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
