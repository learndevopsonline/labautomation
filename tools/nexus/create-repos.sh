#!/bin/bash

nexus3 login

REPO_LIST=$(nexus3 repository  list  |grep localhost| awk '{print $1}')

echo Delete existing repos
for repo in ${REPO_LIST}; do
  nexus3 repository delete $repo --yes
done

echo Create Roboshop repos
for repo in cart catalogue user frontend shipping payment; do
  nexus3 repository create hosted raw $repo
done



