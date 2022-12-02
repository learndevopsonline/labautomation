#!/bin/bash

SOURCE_REPO=https://github.com/orgs/roboshop-devops-project-v1/repositories

for component in cart catalogue user shipping payment dispatch frontend ; do
  cd /tmp
  rm -rf $component
  git clone $SOURCE_REPO/$component
done
