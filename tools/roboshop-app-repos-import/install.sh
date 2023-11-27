#!/bin/bash

read -p 'Enter GitHub Username: ' gusername

SOURCE_REPO=https://github.com/roboshop-devops-project-v1

for component in cart catalogue user shipping payment dispatch frontend ; do
  cd /tmp
  rm -rf $component
  git clone $SOURCE_REPO/$component
  rm -rf /tmp/$component/.git
  cd /tmp/$component
  git init
  git branch -m main
  git add -A
  git commit -m INIT
  gh repo create $gusername/$component --public --source=. --push
done
