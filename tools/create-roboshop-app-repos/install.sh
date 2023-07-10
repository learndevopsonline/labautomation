#!/bin/bash 

read -p 'Enter Username: ' username

for repo in catalogue user cart shipping payment frontend dispatch ; do
  cd /tmp
  git clone https://github.com/roboshop-devops-project-v1/$repo
  cd /home/centos
  gh repo create $username/$repo --public --clone
  cd /home/centos/$repo
  cp -r /tmp/$repo/* .
  break
done
