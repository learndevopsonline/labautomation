#!/bin/bash

SOURCE_REPO=git@github.com:roboshop-devops-project-v1/

for component in cart catalogue user shipping payment dispatch frontend ; do
  cd /tmp
  rm -rf $component
  git clone $SOURCE_REPO/$component
done
