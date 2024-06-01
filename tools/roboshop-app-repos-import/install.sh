#!/bin/bash

type gh &>/dev/null
if [ $? -ne 0 ]; then
  echo gh cli is missing.
  echo -e "Run \e[1;33msudo labauto github-cli\e[0m to install it"
  exit 1
fi

read -p 'Enter GitHub Username/OrganizationName: ' gusername

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
  gh repo create $gusername/roboshop-$component --public --source=. --push
done
